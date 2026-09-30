#!/usr/bin/env python3
"""
SEKIRO: SHADOWS DIE TWICE — SHINOBI SANCTUARY DASHBOARD
A completely custom, standalone Wayland Control Center with falling Sakura petals,
Combat HUD gauges (Vitality & Posture), and Shinobi Prosthetic Tools.
100% Free & Open Source • Author: Jairo Herrera Romero (@TheJPlay2006)
"""

import os
import sys
import json
import signal
import subprocess
import re
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
gi.require_version('WebKit2', '4.1')

from gi.repository import Gtk, Gdk, GtkLayerShell, WebKit2, GLib

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
HTML_PATH = os.path.join(SCRIPT_DIR, "dashboard.html")

def check_single_instance_toggle():
    current_pid = os.getpid()
    try:
        out = subprocess.check_output(["pgrep", "-f", "sekiro_dashboard.py"], text=True).strip().splitlines()
        other_pids = [int(p) for p in out if int(p) != current_pid]
        if other_pids:
            for p in other_pids:
                try:
                    os.kill(p, signal.SIGTERM)
                except OSError:
                    pass
            sys.exit(0)
    except Exception:
        pass


class SekiroDashboard(Gtk.Window):
    def __init__(self):
        super().__init__()

        # Configure Layer Shell
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.ON_DEMAND)
        GtkLayerShell.set_namespace(self, "sekiro-sanctuary")

        # Placement: Top Right under the bar
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, 48)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, 14)

        # Window dimensions
        self.set_default_size(500, 770)
        self.set_resizable(False)

        # True Transparency
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        # WebKit Setup
        manager = WebKit2.UserContentManager()
        manager.register_script_message_handler("pyhandler")
        manager.connect("script-message-received::pyhandler", self.on_js_message)

        self.webview = WebKit2.WebView.new_with_user_content_manager(manager)
        self.webview.set_background_color(Gdk.RGBA(0, 0, 0, 0))

        settings = self.webview.get_settings()
        settings.set_enable_javascript(True)
        settings.set_enable_developer_extras(False)
        settings.set_allow_file_access_from_file_urls(True)
        settings.set_allow_universal_access_from_file_urls(True)

        self.webview.load_uri(f"file://{HTML_PATH}")
        self.add(self.webview)

        # Events
        self.connect("key-press-event", self.on_key_press)
        self.connect("destroy", Gtk.main_quit)

        # System stats state
        self.prev_cpu_idle = 0
        self.prev_cpu_total = 0
        GLib.timeout_add(150, self.push_system_stats)
        GLib.timeout_add(1500, self.push_system_stats)

        # Show immediately
        self.show_all()

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.close_dashboard()
            return True
        return False

    def close_dashboard(self):
        self.destroy()
        Gtk.main_quit()

    def on_js_message(self, manager, js_result):
        try:
            msg_str = js_result.get_js_value().to_string()
            data = json.loads(msg_str)
            action = data.get("action")
            value = data.get("value")
            self.handle_action(action, value)
        except Exception as e:
            print("Error handling JS message:", e, file=sys.stderr)

    def handle_action(self, action, value):
        if action == "close":
            self.close_dashboard()

        elif action == "set_volume":
            try:
                val = max(0, min(100, int(value)))
                subprocess.run(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "0"], stderr=subprocess.DEVNULL)
                subprocess.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", f"{val}%"], stderr=subprocess.DEVNULL)
            except Exception:
                pass

        elif action == "set_brightness":
            try:
                val = max(5, min(100, int(value)))
                if os.path.exists("/sys/class/backlight"):
                    for b in os.listdir("/sys/class/backlight"):
                        max_file = f"/sys/class/backlight/{b}/max_brightness"
                        if os.path.isfile(max_file):
                            with open(max_file) as f:
                                max_b = int(f.read().strip())
                            target = int((val / 100.0) * max_b)
                            subprocess.run([
                                "busctl", "call", "org.freedesktop.login1",
                                "/org/freedesktop/login1/session/auto",
                                "org.freedesktop.login1.Session", "SetBrightness",
                                "ssu", "backlight", b, str(target)
                            ], stderr=subprocess.DEVNULL)
                            break
            except Exception:
                pass

        elif action == "toggle_wifi":
            try:
                cur = subprocess.check_output(["nmcli", "radio", "wifi"], text=True, stderr=subprocess.DEVNULL).strip()
                new_state = "off" if "enabled" in cur.lower() else "on"
                subprocess.run(["nmcli", "radio", "wifi", new_state], stderr=subprocess.DEVNULL)
            except Exception:
                pass
            GLib.timeout_add(350, self.push_system_stats)

        elif action == "toggle_bluetooth":
            try:
                state = subprocess.check_output(["bluetoothctl", "show"], text=True, stderr=subprocess.DEVNULL)
                if "Powered: yes" in state:
                    subprocess.run(["bluetoothctl", "power", "off"], stderr=subprocess.DEVNULL)
                else:
                    subprocess.run(["rfkill", "unblock", "bluetooth"], stderr=subprocess.DEVNULL)
                    subprocess.run(["bluetoothctl", "power", "on"], stderr=subprocess.DEVNULL)
            except Exception:
                pass
            GLib.timeout_add(350, self.push_system_stats)

        elif action == "open_terminal":
            self.close_dashboard()
            subprocess.Popen(["alacritty"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "open_browser":
            self.close_dashboard()
            subprocess.Popen(["brave"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "open_files":
            self.close_dashboard()
            subprocess.Popen(["nautilus"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "open_code":
            self.close_dashboard()
            subprocess.Popen(["code"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "launch_app":
            self.close_dashboard()
            if value:
                cmd = value if isinstance(value, list) else [value]
                subprocess.Popen(cmd, start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "media_toggle":
            subprocess.run(["playerctl", "play-pause"], stderr=subprocess.DEVNULL)
            GLib.timeout_add(250, self.push_system_stats)

        elif action == "media_next":
            subprocess.run(["playerctl", "next"], stderr=subprocess.DEVNULL)
            GLib.timeout_add(250, self.push_system_stats)

        elif action == "media_prev":
            subprocess.run(["playerctl", "previous"], stderr=subprocess.DEVNULL)
            GLib.timeout_add(250, self.push_system_stats)

        elif action == "power_lock":
            self.close_dashboard()
            subprocess.Popen(["bash", "-c", "swaylock -f -c 100b0d || loginctl lock-session"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "power_logout":
            self.close_dashboard()
            subprocess.Popen(["niri", "msg", "action", "quit", "-s"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "power_reboot":
            self.close_dashboard()
            subprocess.Popen(["systemctl", "reboot"], start_new_session=True, stderr=subprocess.DEVNULL)

        elif action == "power_shutdown":
            self.close_dashboard()
            subprocess.Popen(["systemctl", "poweroff"], start_new_session=True, stderr=subprocess.DEVNULL)

    def collect_system_stats(self):
        stats = {}

        # CPU calculation
        try:
            with open("/proc/stat") as f:
                fields = [float(x) for x in f.readline().strip().split()[1:]]
            idle = fields[3]
            total = sum(fields)
            if self.prev_cpu_total > 0:
                diff_idle = idle - self.prev_cpu_idle
                diff_total = total - self.prev_cpu_total
                cpu_usage = max(0, min(100, int((1.0 - diff_idle / max(1, diff_total)) * 100)))
            else:
                cpu_usage = 12
            self.prev_cpu_idle = idle
            self.prev_cpu_total = total
            stats["cpu"] = cpu_usage
        except Exception:
            stats["cpu"] = 0

        # RAM calculation
        try:
            with open("/proc/meminfo") as f:
                mem = {}
                for line in f:
                    parts = line.split(":")
                    if len(parts) == 2:
                        mem[parts[0].strip()] = int(parts[1].split()[0])
            total_g = mem.get("MemTotal", 1) / (1024 * 1024)
            avail_g = mem.get("MemAvailable", 1) / (1024 * 1024)
            used_g = total_g - avail_g
            ram_pct = max(0, min(100, int((used_g / max(1, total_g)) * 100)))
            stats["ram_percent"] = ram_pct
            stats["ram_text"] = f"{used_g:.1f} / {total_g:.1f} GB"
        except Exception:
            stats["ram_percent"] = 0
            stats["ram_text"] = "0 / 0 GB"

        # Wi-Fi SSID and state
        try:
            wifi_state = subprocess.check_output(["nmcli", "radio", "wifi"], text=True, stderr=subprocess.DEVNULL).strip()
            stats["wifi_enabled"] = ("enabled" in wifi_state.lower())
            if stats["wifi_enabled"]:
                wifi_out = subprocess.check_output(["nmcli", "-t", "-f", "active,ssid", "dev", "wifi"], stderr=subprocess.DEVNULL, text=True)
                active_ssid = next((line.split(":")[1] for line in wifi_out.splitlines() if line.startswith("yes:")), None)
                stats["wifi_ssid"] = active_ssid if active_ssid else "Disconnected"
            else:
                stats["wifi_ssid"] = "Wi-Fi Disabled"
        except Exception:
            stats["wifi_enabled"] = True
            stats["wifi_ssid"] = "Connected"

        # Bluetooth status
        try:
            bt_out = subprocess.check_output(["bluetoothctl", "show"], text=True, stderr=subprocess.DEVNULL)
            stats["bluetooth_enabled"] = ("Powered: yes" in bt_out)
            info_out = subprocess.check_output(["bluetoothctl", "devices", "Connected"], text=True, stderr=subprocess.DEVNULL).strip()
            if stats["bluetooth_enabled"]:
                if info_out:
                    stats["bluetooth_text"] = info_out.split(" ", 2)[-1] if len(info_out.split(" ")) >= 3 else "Connected"
                else:
                    stats["bluetooth_text"] = "On"
            else:
                stats["bluetooth_text"] = "Off"
        except Exception:
            stats["bluetooth_enabled"] = False
            stats["bluetooth_text"] = "Off"

        # Battery
        try:
            bat_dir = "/sys/class/power_supply"
            bat_found = False
            if os.path.exists(bat_dir):
                for b in os.listdir(bat_dir):
                    if b.startswith("BAT"):
                        with open(f"{bat_dir}/{b}/capacity") as f:
                            cap = f.read().strip()
                        with open(f"{bat_dir}/{b}/status") as f:
                            st = f.read().strip()
                        icon = "󰢝" if st == "Charging" else "󰁹"
                        stats["battery"] = f"{icon} {cap}%"
                        bat_found = True
                        break
            if not bat_found:
                stats["battery"] = "󰚥 AC Power"
        except Exception:
            stats["battery"] = "󰁹 100%"

        # Volume
        try:
            vol_out = subprocess.check_output(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"], stderr=subprocess.DEVNULL, text=True)
            match = re.search(r"Volume:\s*([0-9.]+)", vol_out)
            if match:
                stats["volume"] = int(float(match.group(1)) * 100)
            stats["is_muted"] = ("[MUTED]" in vol_out)
        except Exception:
            stats["volume"] = 50
            stats["is_muted"] = False

        # Brightness
        try:
            if os.path.exists("/sys/class/backlight"):
                for b in os.listdir("/sys/class/backlight"):
                    with open(f"/sys/class/backlight/{b}/brightness") as f:
                        cur = float(f.read().strip())
                    with open(f"/sys/class/backlight/{b}/max_brightness") as f:
                        m = float(f.read().strip())
                    stats["brightness"] = max(5, min(100, int((cur / m) * 100)))
                    break
        except Exception:
            stats["brightness"] = 70

        # Uptime
        try:
            up_out = subprocess.check_output(["uptime", "-p"], stderr=subprocess.DEVNULL, text=True).strip()
            up_clean = up_out.replace("up ", "")
            stats["uptime"] = up_clean
        except Exception:
            stats["uptime"] = "Just awakened"

        # Media
        try:
            media_title = subprocess.check_output(["playerctl", "metadata", "title"], stderr=subprocess.DEVNULL, text=True).strip()
            media_artist = subprocess.check_output(["playerctl", "metadata", "artist"], stderr=subprocess.DEVNULL, text=True).strip()
            status = subprocess.check_output(["playerctl", "status"], stderr=subprocess.DEVNULL, text=True).strip()
            stats["media_title"] = media_title if media_title else "Quiet Sanctuary"
            stats["media_artist"] = media_artist if media_artist else "Sekiro: Shadows Die Twice OST"
            stats["media_playing"] = (status == "Playing")
        except Exception:
            stats["media_title"] = "Quiet Sanctuary"
            stats["media_artist"] = "Sekiro: Shadows Die Twice OST"
            stats["media_playing"] = False

        return stats

    def push_system_stats(self):
        stats = self.collect_system_stats()
        json_data = json.dumps(stats)
        js_code = f"updateDashboard({json_data});"
        try:
            self.webview.run_javascript(js_code, None, None, None)
        except Exception:
            pass
        return True


def main():
    check_single_instance_toggle()
    dashboard = SekiroDashboard()
    Gtk.main()

if __name__ == "__main__":
    main()

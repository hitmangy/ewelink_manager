import time, hmac, hashlib, random, base64, json, requests, uuid, string
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
from http import HTTPStatus
import threading
import os
import sys
from datetime import datetime

class ModernUI:
    """Custom styles and theming for a modern dark UI"""
    
    DARK_BG = "#1e1e1e"
    DARKER_BG = "#121212"
    ACCENT = "#007acc"  # Blue accent color
    ACCENT_HOVER = "#0098ff"
    TEXT = "#e0e0e0"
    SECONDARY_TEXT = "#a0a0a0"
    SUCCESS = "#4caf50"  # Green for ON status
    WARNING = "#ff9800"
    ERROR = "#f44336"    # Red for OFF status
    
    def __init__(self, root):
        self.root = root
        self.style = ttk.Style()
        
        # Configure the theme
        if "azure" in self.style.theme_names():
            self.style.theme_use("azure")  # Use azure theme if available
        else:
            self.style.theme_use("clam")  # Fallback to clam
            
        # Configure colors
        self.root.configure(bg=self.DARK_BG)
        self.style.configure(".", 
                            background=self.DARK_BG, 
                            foreground=self.TEXT,
                            troughcolor=self.DARKER_BG,
                            selectbackground=self.ACCENT,
                            selectforeground=self.TEXT,
                            fieldbackground=self.DARKER_BG,
                            borderwidth=0,
                            focuscolor=self.ACCENT)
        
        # Configure TLabel
        self.style.configure("TLabel", 
                            background=self.DARK_BG, 
                            foreground=self.TEXT)
        
        # Configure TButton
        self.style.configure("TButton", 
                            background=self.ACCENT, 
                            foreground=self.TEXT,
                            borderwidth=0,
                            focusthickness=0,
                            padding=6)
        self.style.map("TButton",
                      background=[("active", self.ACCENT_HOVER), ("pressed", self.ACCENT_HOVER)],
                      relief=[("pressed", "flat"), ("!pressed", "flat")])
        
        # Configure Accent.TButton
        self.style.configure("Accent.TButton", 
                            background=self.ACCENT, 
                            foreground=self.TEXT)
        
        # Configure Success.TButton
        self.style.configure("Success.TButton", 
                            background=self.SUCCESS, 
                            foreground=self.TEXT)
        self.style.map("Success.TButton",
                      background=[("active", "#5dbb63"), ("pressed", "#5dbb63")])
        
        # Configure Warning.TButton
        self.style.configure("Warning.TButton", 
                            background=self.WARNING, 
                            foreground=self.TEXT)
        
        # Configure Error.TButton
        self.style.configure("Error.TButton", 
                            background=self.ERROR, 
                            foreground=self.TEXT)
        self.style.map("Error.TButton",
                      background=[("active", "#ff5252"), ("pressed", "#ff5252")])
        
        # Configure Small.TButton
        self.style.configure("Small.TButton", 
                            padding=2,
                            font=("Segoe UI", 8))
        
        # Configure Small.Success.TButton
        self.style.configure("Small.Success.TButton", 
                            background=self.SUCCESS, 
                            foreground=self.TEXT,
                            padding=2,
                            font=("Segoe UI", 8))
        self.style.map("Small.Success.TButton",
                      background=[("active", "#5dbb63"), ("pressed", "#5dbb63")])
        
        # Configure Small.Error.TButton
        self.style.configure("Small.Error.TButton", 
                            background=self.ERROR, 
                            foreground=self.TEXT,
                            padding=2,
                            font=("Segoe UI", 8))
        self.style.map("Small.Error.TButton",
                      background=[("active", "#ff5252"), ("pressed", "#ff5252")])
        
        # Configure TEntry
        self.style.configure("TEntry", 
                            fieldbackground=self.DARKER_BG,
                            foreground=self.TEXT,
                            insertcolor=self.TEXT,
                            borderwidth=0,
                            padding=8)
        
        # Configure TFrame
        self.style.configure("TFrame", 
                            background=self.DARK_BG)
        
        # Configure Card.TFrame
        self.style.configure("Card.TFrame", 
                            background=self.DARKER_BG,
                            relief="flat",
                            borderwidth=0)
        
        # Configure TLabelframe
        self.style.configure("TLabelframe", 
                            background=self.DARKER_BG,
                            foreground=self.TEXT,
                            borderwidth=1,
                            relief="solid")
        self.style.configure("TLabelframe.Label", 
                            background=self.DARKER_BG,
                            foreground=self.ACCENT)
        
        # Configure Treeview
        self.style.configure("Treeview", 
                            background=self.DARKER_BG,
                            foreground=self.TEXT,
                            fieldbackground=self.DARKER_BG,
                            borderwidth=0)
        self.style.map("Treeview",
                      background=[("selected", self.ACCENT)],
                      foreground=[("selected", self.TEXT)])
        
        # Configure Treeview.Heading
        self.style.configure("Treeview.Heading", 
                            background=self.DARK_BG,
                            foreground=self.ACCENT,
                            relief="flat")
        self.style.map("Treeview.Heading",
                      background=[("active", self.DARKER_BG)],
                      relief=[("active", "flat")])
        
        # Configure Horizontal.TScrollbar
        self.style.configure("Horizontal.TScrollbar", 
                            background=self.DARKER_BG,
                            troughcolor=self.DARK_BG,
                            borderwidth=0,
                            arrowsize=12)
        
        # Configure Vertical.TScrollbar
        self.style.configure("Vertical.TScrollbar", 
                            background=self.DARKER_BG,
                            troughcolor=self.DARK_BG,
                            borderwidth=0,
                            arrowsize=12)
        
        # Configure TNotebook
        self.style.configure("TNotebook", 
                            background=self.DARK_BG,
                            borderwidth=0)
        self.style.configure("TNotebook.Tab", 
                            background=self.DARKER_BG,
                            foreground=self.TEXT,
                            padding=[10, 2],
                            borderwidth=0)
        self.style.map("TNotebook.Tab",
                      background=[("selected", self.ACCENT)],
                      expand=[("selected", [1, 1, 1, 0])])
        
        # Configure TSeparator
        self.style.configure("TSeparator", 
                            background=self.ACCENT)
        
        # Configure Status.TLabel
        self.style.configure("Status.TLabel", 
                            background=self.DARKER_BG,
                            foreground=self.SECONDARY_TEXT,
                            padding=5)
        
        # Configure Title.TLabel
        self.style.configure("Title.TLabel", 
                            background=self.DARK_BG,
                            foreground=self.TEXT,
                            font=("Segoe UI", 16, "bold"))
        
        # Configure Subtitle.TLabel
        self.style.configure("Subtitle.TLabel", 
                            background=self.DARK_BG,
                            foreground=self.ACCENT,
                            font=("Segoe UI", 12))
        
        # Configure Login.TFrame
        self.style.configure("Login.TFrame", 
                            background=self.DARKER_BG,
                            relief="flat",
                            borderwidth=0)
        
        # Configure On.TLabel - for ON status
        self.style.configure("On.TLabel", 
                            background=self.DARKER_BG,
                            foreground=self.SUCCESS,
                            font=("Segoe UI", 9, "bold"))
        
        # Configure Off.TLabel - for OFF status
        self.style.configure("Off.TLabel", 
                            background=self.DARKER_BG,
                            foreground=self.ERROR,
                            font=("Segoe UI", 9, "bold"))


class StatusIndicator(tk.Canvas):
    """Custom canvas widget for status indicator"""
    def __init__(self, parent, status="off", **kwargs):
        super().__init__(parent, **kwargs)
        self.configure(width=15, height=15, bg=ModernUI.DARKER_BG, highlightthickness=0)
        self.status = status
        self.draw_indicator()
    
    def draw_indicator(self):
        self.delete("all")
        if self.status.lower() == "on":
            color = ModernUI.SUCCESS
        else:
            color = ModernUI.ERROR
        
        # Draw circle
        self.create_oval(3, 3, 12, 12, fill=color, outline="")
    
    def set_status(self, status):
        self.status = status
        self.draw_indicator()


class LoginScreen:
    def __init__(self, root, ui, on_login_success):
        self.root = root
        self.ui = ui
        self.on_login_success = on_login_success
        
        # Variables
        self.email_var = tk.StringVar(value="xxx@gmail.com")
        self.password_var = tk.StringVar(value="xxx")
        self.status_var = tk.StringVar(value="Please login to continue")
        
        # Create login UI
        self.create_ui()
    
    def create_ui(self):
        # Main container
        self.main_container = ttk.Frame(self.root)
        self.main_container.pack(fill=tk.BOTH, expand=True)
        
        # Center login card
        center_frame = ttk.Frame(self.main_container)
        center_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        
        # Login card
        login_card = ttk.Frame(center_frame, style="Card.TFrame")
        login_card.pack(padx=30, pady=30, ipadx=20, ipady=20)
        
        # App logo/title
        title_frame = ttk.Frame(login_card, style="Card.TFrame")
        title_frame.pack(pady=(0, 20))
        
        title_label = ttk.Label(title_frame, text="eWelink Manager", style="Title.TLabel")
        title_label.pack()
        
        subtitle_label = ttk.Label(title_frame, text="Login to your account", style="Subtitle.TLabel")
        subtitle_label.pack(pady=(5, 0))
        
        # Login form
        form_frame = ttk.Frame(login_card, style="Card.TFrame")
        form_frame.pack(fill=tk.X, pady=10)
        
        # Email field
        email_label = ttk.Label(form_frame, text="Email", style="Subtitle.TLabel")
        email_label.pack(anchor=tk.W, pady=(0, 5))
        
        email_entry = ttk.Entry(form_frame, textvariable=self.email_var, width=30)
        email_entry.pack(fill=tk.X, pady=(0, 15))
        
        # Password field
        password_label = ttk.Label(form_frame, text="Password", style="Subtitle.TLabel")
        password_label.pack(anchor=tk.W, pady=(0, 5))
        
        password_entry = ttk.Entry(form_frame, textvariable=self.password_var, width=30, show="•")
        password_entry.pack(fill=tk.X, pady=(0, 15))
        
        # Login button
        login_button = ttk.Button(form_frame, text="Login", style="Accent.TButton", command=self.login)
        login_button.pack(fill=tk.X, pady=(10, 0))
        
        # Status message
        status_label = ttk.Label(form_frame, textvariable=self.status_var, style="Status.TLabel", anchor=tk.CENTER)
        status_label.pack(fill=tk.X, pady=(15, 0))
        
        # Set focus to email field
        email_entry.focus_set()
        
        # Bind Enter key to login
        self.root.bind("<Return>", lambda event: self.login())
    
    def login(self):
        """Handle login process"""
        self.status_var.set("Logging in...")
        self.root.update_idletasks()
        
        # Start login in a separate thread
        threading.Thread(target=self._login_thread, daemon=True).start()
    
    def _login_thread(self):
        """Login thread to keep UI responsive"""
        try:
            credentials = {
                'email': self.email_var.get(),
                'password': self.password_var.get(),
                'imei': str(uuid.uuid4())
            }
            
            # Create API handler
            api = EwelinkAPI()
            user_info = api.login(credentials)
            
            if 'error' in user_info:
                self.root.after(0, lambda: self.status_var.set(f"Error: {user_info['error']}"))
                return
                
            if 'at' not in user_info['response']:
                self.root.after(0, lambda: self.status_var.set("Login failed! Check credentials"))
                return
            
            # Login successful
            self.root.after(0, lambda: self.on_login_success(user_info, api))
            
        except Exception as e:
            self.root.after(0, lambda: self.status_var.set(f"Error: {str(e)}"))


class EwelinkAPI:
    """API handler for eWelink"""
    
    def create_signature(self, credentials):
        app_details = {
            'email': credentials['email'],
            'password': credentials['password'],
            'version': '6',
            'ts': int(time.time()),
            'nonce': ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(8)),
            'appid': 'R8Oq3y0eSZSYdKccHlrQzT1ACCOUT9Gv',
            'imei': credentials['imei'],
            'os': 'iOS',
            'model': 'iPhone11,8',
            'romVersion': '13.2',
            'appVersion': '3.11.0'
        }
        decryptedAppSecret = b'1ve5Qk9GXfUhKAn1svnKwpAlxXkMarru'
        hex_dig = hmac.new(
            decryptedAppSecret,
            str.encode(json.dumps(app_details)),
            digestmod=hashlib.sha256).digest()
        sign = base64.b64encode(hex_dig).decode()
        return (sign, app_details)

    def login(self, credentials, api_region='us'):
        sign, payload = self.create_signature(credentials)
        headers = {
            'Authorization' : 'Sign ' + sign,
            'Content-Type'  : 'application/json;charset=UTF-8'
        }

        r = requests.post('https://{}-api.coolkit.cc:8080/api/user/login'.format(api_region),
            headers=headers, json=payload)

        if not (r.status_code == HTTPStatus.OK):
            return ({"error": "Unable to access coolkit api server [{}]".format(r.text)})

        resp = r.json()
        if 'error' in resp and 'region' in resp and resp['error'] == HTTPStatus.MOVED_PERMANENTLY:
            api_region = resp['region']
            print('API region set to: {}'.format(api_region))
            return self.login(credentials, api_region)

        return {"response": resp, "region": api_region, "imei": credentials['imei']}

    def list_devices(self, user_info, attempt=1):
        headers = {
            'Authorization' : 'Bearer ' + user_info['response']['at'],
            'Content-Type'  : 'application/json;charset=UTF-8'
        }

        r = requests.get('https://{}-api.coolkit.cc:8080/api/user/device?lang=en&apiKey={}&getTags=1&version=6&ts=%s&nonce=%s&appid=oeVkj2lYFGnJu5XUtWisfW4utiN4u9Mq&imei=%s&os=iOS&model=%s&romVersion=%s&appVersion=%s'.format(
                user_info['region'], user_info['response']['user']['apikey'], str(int(time.time())), ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(8)), user_info['imei'], 'iPhone10,6', '11.1.2', '3.5.3'), headers=headers)

        resp = r.json()
        if 'error' in resp and resp['error'] in [HTTPStatus.BAD_REQUEST, HTTPStatus.UNAUTHORIZED]:
            if (attempt == 5):
                print("Unable to fetch devices, please close eWelink application across all devices and try again.")
                return None
            return self.list_devices(user_info, attempt+1)

        return resp['devicelist']
    
    def toggle_device(self, user_info, device_id, new_state):
        """Toggle a device on/off"""
        headers = {
            'Authorization' : 'Bearer ' + user_info['response']['at'],
            'Content-Type'  : 'application/json;charset=UTF-8'
        }
        
        payload = {
            'deviceid': device_id,
            'params': {
                'switch': 'on' if new_state else 'off'
            }
        }
        
        r = requests.post('https://{}-api.coolkit.cc:8080/api/user/device/status'.format(user_info['region']),
            headers=headers, json=payload)
        
        if r.status_code != HTTPStatus.OK:
            return {"error": f"Failed to toggle device: {r.text}"}
        
        return r.json()


class DeviceFrame(ttk.Frame):
    """Frame for displaying a single device with controls"""
    def __init__(self, parent, device, ui, toggle_callback, details_callback):
        super().__init__(parent, style="Card.TFrame")
        self.device = device
        self.ui = ui
        self.toggle_callback = toggle_callback
        self.details_callback = details_callback
        
        self.create_ui()
    
    def create_ui(self):
        # Main container with padding
        self.configure(padding=10)
        
        # Device name and status row
        header_frame = ttk.Frame(self, style="Card.TFrame")
        header_frame.pack(fill=tk.X, expand=True)
        
        # Status indicator
        switch_state = "off"
        if 'params' in self.device and 'switch' in self.device['params']:
            switch_state = self.device['params']['switch']
        
        self.status_indicator = StatusIndicator(header_frame, status=switch_state)
        self.status_indicator.pack(side=tk.LEFT, padx=(0, 10))
        
        # Device name
        device_name = ttk.Label(header_frame, text=self.device.get('name', 'Unknown Device'), 
                               style="Subtitle.TLabel", font=("Segoe UI", 11, "bold"))
        device_name.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        # Control buttons
        if 'params' in self.device and 'switch' in self.device['params']:
            is_on = self.device['params']['switch'] == 'on'
            
            # Toggle button
            if is_on:
                toggle_button = ttk.Button(header_frame, text="Turn OFF", 
                                         style="Small.Error.TButton", width=8,
                                         command=lambda: self.toggle_callback(self.device, True))
            else:
                toggle_button = ttk.Button(header_frame, text="Turn ON", 
                                         style="Small.Success.TButton", width=8,
                                         command=lambda: self.toggle_callback(self.device, False))
            
            toggle_button.pack(side=tk.RIGHT, padx=(5, 0))
        
        # Details button
        details_button = ttk.Button(header_frame, text="Details", 
                                  style="Small.TButton", width=8,
                                  command=lambda: self.details_callback(self.device))
        details_button.pack(side=tk.RIGHT)
        
        # Device info
        info_frame = ttk.Frame(self, style="Card.TFrame")
        info_frame.pack(fill=tk.X, expand=True, pady=(10, 0))
        
        # Model info
        model_frame = ttk.Frame(info_frame, style="Card.TFrame")
        model_frame.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        model_label = ttk.Label(model_frame, text="Model:", style="Status.TLabel")
        model_label.pack(side=tk.LEFT)
        
        model_value = ttk.Label(model_frame, 
                               text=f"{self.device.get('brandName', 'Unknown')} {self.device.get('productModel', '')}")
        model_value.pack(side=tk.LEFT, padx=(5, 0))
        
        # Status info
        status_frame = ttk.Frame(info_frame, style="Card.TFrame")
        status_frame.pack(side=tk.RIGHT)
        
        status_label = ttk.Label(status_frame, text="Status:", style="Status.TLabel")
        status_label.pack(side=tk.LEFT)
        
        if 'params' in self.device and 'switch' in self.device['params']:
            is_on = self.device['params']['switch'] == 'on'
            status_style = "On.TLabel" if is_on else "Off.TLabel"
            status_text = "ON" if is_on else "OFF"
        else:
            status_style = "Status.TLabel"
            status_text = "N/A"
        
        status_value = ttk.Label(status_frame, text=status_text, style=status_style)
        status_value.pack(side=tk.LEFT, padx=(5, 0))
    
    def update_device(self, device):
        """Update the device data and refresh UI"""
        self.device = device
        
        # Destroy all children
        for widget in self.winfo_children():
            widget.destroy()
        
        # Recreate UI
        self.create_ui()


class MainApp:
    def __init__(self, root, ui, user_info, api):
        self.root = root
        self.ui = ui
        self.user_info = user_info
        self.api = api
        self.devices = []
        self.device_frames = {}  # Store device frames for updates
        self.status_var = tk.StringVar(value="Loading devices...")
        self.time_var = tk.StringVar()
        
        # Clear any existing widgets
        for widget in self.root.winfo_children():
            widget.destroy()
        
        # Create main UI
        self.create_ui()
        
        # Load devices
        self.refresh_devices_thread()
        
        # Start time updater
        self.update_time()
    
    def create_ui(self):
        # Main container
        self.main_container = ttk.Frame(self.root)
        self.main_container.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)
        
        # Header
        header_frame = ttk.Frame(self.main_container)
        header_frame.pack(fill=tk.X, pady=(0, 15))
        
        # App title
        title_label = ttk.Label(header_frame, text="eWelink Device Manager", style="Title.TLabel")
        title_label.pack(side=tk.LEFT)
        
        # User info
        user_email = self.user_info['response']['user']['email']
        user_label = ttk.Label(header_frame, text=f"Logged in as: {user_email}", style="Subtitle.TLabel")
        user_label.pack(side=tk.RIGHT)
        
        # Content notebook (tabs)
        self.notebook = ttk.Notebook(self.main_container)
        self.notebook.pack(fill=tk.BOTH, expand=True)
        
        # Devices tab
        self.devices_frame = ttk.Frame(self.notebook)
        self.notebook.add(self.devices_frame, text="Devices")
        
        # Create toolbar for devices tab
        toolbar = ttk.Frame(self.devices_frame)
        toolbar.pack(fill=tk.X, pady=(0, 10))
        
        # Refresh button
        refresh_button = ttk.Button(toolbar, text="Refresh Devices", command=self.refresh_devices_thread)
        refresh_button.pack(side=tk.LEFT, padx=(0, 5))
        
        # Export button
        export_button = ttk.Button(toolbar, text="Export to JSON", command=self.export_to_json)
        export_button.pack(side=tk.LEFT, padx=5)
        
        # Logout button
        logout_button = ttk.Button(toolbar, text="Logout", style="Warning.TButton", command=self.logout)
        logout_button.pack(side=tk.LEFT, padx=5)
        
        # Search frame (right side of toolbar)
        search_frame = ttk.Frame(toolbar)
        search_frame.pack(side=tk.RIGHT)
        
        ttk.Label(search_frame, text="Search:").pack(side=tk.LEFT, padx=(0, 5))
        self.search_var = tk.StringVar()
        self.search_var.trace("w", self.filter_devices)
        search_entry = ttk.Entry(search_frame, textvariable=self.search_var, width=20)
        search_entry.pack(side=tk.LEFT)
        
        # Create a canvas with scrollbar for the devices
        self.canvas_frame = ttk.Frame(self.devices_frame)
        self.canvas_frame.pack(fill=tk.BOTH, expand=True)
        
        self.canvas = tk.Canvas(self.canvas_frame, bg=self.ui.DARK_BG, highlightthickness=0)
        scrollbar = ttk.Scrollbar(self.canvas_frame, orient=tk.VERTICAL, command=self.canvas.yview)
        
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.canvas.configure(yscrollcommand=scrollbar.set)
        
        # Frame inside canvas for devices
        self.devices_container = ttk.Frame(self.canvas)
        self.canvas_window = self.canvas.create_window((0, 0), window=self.devices_container, anchor=tk.NW)
        
        # Configure canvas to resize with window
        self.canvas.bind('<Configure>', self.on_canvas_configure)
        self.devices_container.bind('<Configure>', self.on_frame_configure)
        
        # Bind mousewheel for scrolling
        self.canvas.bind_all("<MouseWheel>", self.on_mousewheel)
        
        # About tab
        about_frame = ttk.Frame(self.notebook)
        self.notebook.add(about_frame, text="About")
        
        # About content
        about_content = ttk.Frame(about_frame, style="Card.TFrame")
        about_content.pack(fill=tk.BOTH, expand=True, padx=20, pady=20)
        
        about_title = ttk.Label(about_content, text="eWelink Device Manager", style="Title.TLabel")
        about_title.pack(pady=(20, 10))
        
        about_version = ttk.Label(about_content, text="Version 3.0", style="Subtitle.TLabel")
        about_version.pack(pady=(0, 20))
        
        about_desc = ttk.Label(about_content, 
                              text="A modern interface for managing your eWelink smart devices.\n"
                                   "This application allows you to view and control devices connected to your eWelink account.",
                              wraplength=500, justify=tk.CENTER)
        about_desc.pack(pady=10)
        
        # Footer with status
        footer_frame = ttk.Frame(self.main_container)
        footer_frame.pack(fill=tk.X, pady=(15, 0))
        
        # Status bar
        status_bar = ttk.Label(footer_frame, textvariable=self.status_var, style="Status.TLabel", anchor=tk.W)
        status_bar.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        # Current time
        time_label = ttk.Label(footer_frame, textvariable=self.time_var, style="Status.TLabel")
        time_label.pack(side=tk.RIGHT)
    
    def on_canvas_configure(self, event):
        """Handle canvas resize"""
        # Update the width of the canvas window
        self.canvas.itemconfig(self.canvas_window, width=event.width)
    
    def on_frame_configure(self, event):
        """Reset the scroll region to encompass the inner frame"""
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))
    
    def on_mousewheel(self, event):
        """Handle mousewheel scrolling"""
        self.canvas.yview_scroll(int(-1*(event.delta/120)), "units")
    
    def update_time(self):
        """Update the time display in the footer"""
        current_time = datetime.now().strftime("%H:%M:%S")
        self.time_var.set(current_time)
        self.root.after(1000, self.update_time)
    
    def toggle_device(self, device, is_on):
        """Toggle a device on/off"""
        # Start toggle in a separate thread
        threading.Thread(
            target=self._toggle_device_thread, 
            args=(device, is_on),
            daemon=True
        ).start()
    
    def _toggle_device_thread(self, device, is_on):
        """Thread to toggle device state"""
        try:
            self.status_var.set(f"Toggling {device.get('name', 'device')}...")
            
            # Toggle to opposite state
            new_state = not is_on
            
            # Call API to toggle device
            result = self.api.toggle_device(self.user_info, device['deviceid'], new_state)
            
            if 'error' in result:
                self.root.after(0, lambda: messagebox.showerror("Error", result['error']))
                self.root.after(0, lambda: self.status_var.set("Failed to toggle device"))
                return
            
            # Update the device in our list
            for i, d in enumerate(self.devices):
                if d['deviceid'] == device['deviceid']:
                    # Update the switch state in the device data
                    if 'params' not in self.devices[i]:
                        self.devices[i]['params'] = {}
                    self.devices[i]['params']['switch'] = 'on' if new_state else 'off'
                    
                    # Update the device frame if it exists
                    if device['deviceid'] in self.device_frames:
                        self.root.after(0, lambda: self.device_frames[device['deviceid']].update_device(self.devices[i]))
                    break
            
            # Show success message
            self.root.after(0, lambda: self.status_var.set(f"Successfully turned {device.get('name', 'device')} {'ON' if new_state else 'OFF'}"))
            
        except Exception as e:
            self.root.after(0, lambda: messagebox.showerror("Error", f"Failed to toggle device: {str(e)}"))
            self.root.after(0, lambda: self.status_var.set("Error occurred"))
    
    def show_device_details(self, device):
        """Show device details in a new window"""
        # Create a new window for device details
        details_window = tk.Toplevel(self.root)
        details_window.title(f"Device Details: {device.get('name', 'Unknown')}")
        details_window.geometry("700x500")
        details_window.configure(bg=self.ui.DARK_BG)
        details_window.minsize(600, 400)
        
        # Make the window modal
        details_window.transient(self.root)
        details_window.grab_set()
        
        # Main frame
        main_frame = ttk.Frame(details_window)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)
        
        # Header
        header_frame = ttk.Frame(main_frame)
        header_frame.pack(fill=tk.X, pady=(0, 15))
        
        # Device name as title
        title_label = ttk.Label(header_frame, text=device.get('name', 'Unknown Device'), style="Title.TLabel")
        title_label.pack(side=tk.LEFT)
        
        # Device ID subtitle
        subtitle_label = ttk.Label(header_frame, text=f"ID: {device.get('deviceid', 'Unknown')}", style="Subtitle.TLabel")
        subtitle_label.pack(side=tk.LEFT, padx=(10, 0))
        
        # Switch state if available
        if 'params' in device and 'switch' in device['params']:
            switch_state = device['params']['switch']
            state_style = "On.TLabel" if switch_state == 'on' else "Off.TLabel"
            state_text = "ON" if switch_state == 'on' else "OFF"
            
            state_label = ttk.Label(header_frame, text=f"State: {state_text}", style=state_style)
            state_label.pack(side=tk.RIGHT)
            
            # Toggle button
            toggle_button = ttk.Button(
                header_frame, 
                text="Turn OFF" if switch_state == 'on' else "Turn ON",
                style="Error.TButton" if switch_state == 'on' else "Success.TButton",
                command=lambda: self._toggle_from_details(device, switch_state == 'on', details_window)
            )
            toggle_button.pack(side=tk.RIGHT, padx=10)
        
        # Notebook for different detail views
        notebook = ttk.Notebook(main_frame)
        notebook.pack(fill=tk.BOTH, expand=True)
        
        # JSON View tab
        json_frame = ttk.Frame(notebook)
        notebook.add(json_frame, text="JSON Data")
        
        # Create a text widget with custom colors for JSON
        text = scrolledtext.ScrolledText(json_frame, wrap=tk.WORD, bg=self.ui.DARKER_BG, fg=self.ui.TEXT, insertbackground=self.ui.TEXT)
        text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Insert formatted JSON
        text.insert(tk.END, json.dumps(device, indent=2))
        text.config(state=tk.DISABLED)  # Make read-only
        
        # Summary tab
        summary_frame = ttk.Frame(notebook)
        notebook.add(summary_frame, text="Summary")
        
        # Create a canvas with scrollbar for the summary
        canvas = tk.Canvas(summary_frame, bg=self.ui.DARKER_BG, highlightthickness=0)
        scrollbar = ttk.Scrollbar(summary_frame, orient=tk.VERTICAL, command=canvas.yview)
        
        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        canvas.configure(yscrollcommand=scrollbar.set)
        
        # Frame inside canvas for summary content
        summary_content = ttk.Frame(canvas)
        canvas.create_window((0, 0), window=summary_content, anchor=tk.NW)
        
        # Add summary information
        row = 0
        for key, value in {
            "Name": device.get('name', 'Unknown'),
            "Brand": device.get('brandName', 'Unknown'),
            "Model": device.get('productModel', 'Unknown'),
            "Device ID": device.get('deviceid', 'Unknown'),
            "API Key": device.get('devicekey', 'Unknown'),
            "MAC Address": device.get('params', {}).get('staMac', 'N/A'),
            "Switch State": "ON" if device.get('params', {}).get('switch') == 'on' else "OFF" if device.get('params', {}).get('switch') == 'off' else "N/A",
            "IP Address": device.get('params', {}).get('ip', 'N/A'),
            "SSID": device.get('params', {}).get('ssid', 'N/A'),
            "Firmware Version": device.get('params', {}).get('fwVersion', 'N/A'),
            "Created At": datetime.fromtimestamp(device.get('createdAt', 0)).strftime('%Y-%m-%d %H:%M:%S') if device.get('createdAt') else 'N/A',
            "Updated At": datetime.fromtimestamp(device.get('updateAt', 0)).strftime('%Y-%m-%d %H:%M:%S') if device.get('updateAt') else 'N/A',
        }.items():
            label_frame = ttk.Frame(summary_content)
            label_frame.grid(row=row, column=0, sticky=tk.W, padx=10, pady=5)
            
            key_label = ttk.Label(label_frame, text=f"{key}:", width=15, style="Subtitle.TLabel")
            key_label.pack(side=tk.LEFT)
            
            # Use colored labels for switch state
            if key == "Switch State" and value in ["ON", "OFF"]:
                value_style = "On.TLabel" if value == "ON" else "Off.TLabel"
                value_label = ttk.Label(label_frame, text=str(value), wraplength=400, style=value_style)
            else:
                value_label = ttk.Label(label_frame, text=str(value), wraplength=400)
            
            value_label.pack(side=tk.LEFT, padx=(10, 0))
            
            row += 1
        
        # Update the scrollregion after the frame size is updated
        summary_content.update_idletasks()
        canvas.config(scrollregion=canvas.bbox("all"))
        
        # Button frame
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X, pady=(15, 0))
        
        # Close button
        close_button = ttk.Button(button_frame, text="Close", style="Accent.TButton", 
                                 command=details_window.destroy)
        close_button.pack(side=tk.RIGHT)
    
    def _toggle_from_details(self, device, is_on, details_window):
        """Toggle device from details window and close the window"""
        # Toggle the device
        self.toggle_device(device, is_on)
        
        # Close the details window
        details_window.destroy()
    
    def filter_devices(self, *args):
        """Filter devices based on search text"""
        search_text = self.search_var.get().lower()
        
        # Clear existing device frames
        for widget in self.devices_container.winfo_children():
            widget.destroy()
        
        self.device_frames = {}
        
        # Add filtered devices
        if self.devices:
            filtered_devices = []
            for device in self.devices:
                # Check if search text is in any of the device fields
                device_text = (
                    device.get('brandName', '').lower() +
                    device.get('productModel', '').lower() +
                    device.get('name', '').lower() +
                    device.get('deviceid', '').lower()
                )
                
                if search_text in device_text:
                    filtered_devices.append(device)
            
            self._display_devices(filtered_devices)
    
    def refresh_devices_thread(self):
        """Start refresh in a separate thread"""
        threading.Thread(target=self.refresh_devices, daemon=True).start()
    
    def refresh_devices(self):
        """Refresh the device list"""
        self.status_var.set("Fetching devices...")
        self.root.update_idletasks()
        
        try:
            self.devices = self.api.list_devices(self.user_info)
            
            # Clear existing device frames
            for widget in self.devices_container.winfo_children():
                widget.destroy()
            
            self.device_frames = {}
            
            # Display devices
            if self.devices:
                self._display_devices(self.devices)
                self.status_var.set(f"Found {len(self.devices)} devices")
            else:
                self.status_var.set("No devices found")
                
                # Show no devices message
                no_devices_label = ttk.Label(self.devices_container, 
                                           text="No devices found. Please check your eWelink account.",
                                           style="Subtitle.TLabel")
                no_devices_label.pack(pady=50)
        
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {str(e)}")
            self.status_var.set("Error occurred")
    
    def _display_devices(self, devices):
        """Display devices in the container"""
        # Sort devices by name
        sorted_devices = sorted(devices, key=lambda d: d.get('name', '').lower())
        
        # Create a frame for each device
        for device in sorted_devices:
            device_frame = DeviceFrame(
                self.devices_container, 
                device, 
                self.ui, 
                self.toggle_device, 
                self.show_device_details
            )
            device_frame.pack(fill=tk.X, pady=5, padx=5)
            
            # Store reference to the frame
            self.device_frames[device['deviceid']] = device_frame
    
    def export_to_json(self):
        """Export devices to a JSON file"""
        if not self.devices:
            messagebox.showinfo("Info", "No devices to export")
            return
        
        try:
            filename = f"ewelink_devices_{int(time.time())}.json"
            with open(filename, 'w') as f:
                json.dump(self.devices, f, indent=2)
            
            messagebox.showinfo("Export Successful", f"Devices exported to {filename}")
        except Exception as e:
            messagebox.showerror("Export Error", f"Failed to export: {str(e)}")
    
    def logout(self):
        """Logout and return to login screen"""
        if messagebox.askyesno("Logout", "Are you sure you want to logout?"):
            # Clear any existing widgets
            for widget in self.root.winfo_children():
                widget.destroy()
            
            # Show login screen
            LoginScreen(self.root, self.ui, on_login_success)


def on_login_success(user_info, api):
    """Callback when login is successful"""
    # Create main app
    MainApp(root, ui, user_info, api)


if __name__ == '__main__':
    root = tk.Tk()
    
    # Set window icon (optional)
    if sys.platform == "win32":
        root.iconbitmap(default="")  # You can add an .ico file path here
    
    # Set window title
    root.title("eWelink Device Manager")
    
    # Create UI theme
    ui = ModernUI(root)
    
    # Center window on screen
    window_width = 1000
    window_height = 700
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    center_x = int(screen_width/2 - window_width/2)
    center_y = int(screen_height/2 - window_height/2)
    root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')
    
    # Show login screen
    LoginScreen(root, ui, on_login_success)
    
    # Start the main loop
    root.mainloop()
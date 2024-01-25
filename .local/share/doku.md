# DWM and LF Configuration README

This README provides an overview of the keybindings and settings applied in the DWM (Dynamic Window Manager) and LF (List Files) file manager configurations. DWM is a minimalistic, highly customizable window manager for X, and LF is a console file manager that emphasizes speed and efficiency. These custom configurations enhance their respective functionalities.

## DWM Key Bindings

### Spawning Applications
- `MODKEY + XK_grave`: Spawn `dmenuunicode`.
- `MODKEY + XK_BackSpace`: Spawn `sysact`.
- `MODKEY + XK_minus`: Decrease volume by 5%.
- `MODKEY|ShiftMask + XK_minus`: Decrease volume by 15%.
- `MODKEY + XK_equal`: Increase volume by 5%.
- `MODKEY|ShiftMask + XK_equal`: Increase volume by 15%.
- `MODKEY + XK_Tab`: Switch to the next tag.
- `MODKEY + XK_w`: Open web browser.
- `MODKEY|ShiftMask + XK_w`: Open network manager in terminal.
- `MODKEY + XK_e`: Open email client in terminal.
- `MODKEY|ShiftMask + XK_e`: Open address book in terminal.
- `MODKEY + XK_r`: Open file manager in terminal.
- `MODKEY|ShiftMask + XK_r`: Open system monitor in terminal.
- `MODKEY + XK_n`: Open text editor with Vimwiki index.
- `MODKEY|ShiftMask + XK_m`: Toggle mute.
- `MODKEY + XK_Left`: Focus on the monitor to the left.
- `MODKEY|ShiftMask + XK_Left`: Move window to the monitor on the left.
- `MODKEY + XK_Right`: Focus on the monitor to the right.
- `MODKEY|ShiftMask + XK_Right`: Move window to the monitor on the right.
- `MODKEY + XK_Page_Up`: View previous tag.
- `MODKEY|ShiftMask + XK_Page_Up`: Move window to previous tag.
- `MODKEY + XK_Page_Down`: View next tag.
- `MODKEY|ShiftMask + XK_Page_Down`: Move window to next tag.
- `MODKEY + XK_F1`: Open a specific PDF file with Zathura.
- `MODKEY + XK_F2`: Execute `tutorialvids`.
- `MODKEY + XK_F3`: Display selection script.
- `MODKEY + XK_F4`: Open audio mixer in terminal.
- `MODKEY + XK_F5`: Reload X resources.
- `MODKEY + XK_F6`: Launch Tor Browser.
- `MODKEY + XK_F7`: Toggle task daemon.
- `MODKEY + XK_F8`: Sync mail.
- `MODKEY + XK_F9`: Disk mounting script.
- `MODKEY + XK_F10`: Disk unmounting script.
- `MODKEY + XK_F11`: Start webcam.
- `MODKEY + XK_F12`: Execute remapping script.
- `MODKEY + XK_Print`: Start/stop screen recording.
- `MODKEY|ShiftMask + XK_Print`: Stop screen recording.
- `MODKEY + XK_Delete`: Stop screen recording.
- `MODKEY + XK_Scroll_Lock`: Toggle on-screen keyboard.
- `MODKEY + XK_d`: Launch dmenu.
- `MODKEY + XK_Return`: Open terminal.
- `MODKEY|ControlMask + XK_p`: Launch dmenu in sync mode.
- `MODKEY|ControlMask + XK_Return`: Spawn terminal in rio mode.

### Window Management
- `MODKEY + XK_b`: Toggle status bar.
- `MODKEY + XK_j/k`: Focus next/previous window.
- `MODKEY + XK_h/l`: Decrease/increase master area size.
- `MODKEY|ShiftMask + XK_h/l`: Adjust window factor.
- `MODKEY|ShiftMask + XK_o`: Reset window factor.
- `MODKEY|ShiftMask + XK_j/k`: Move window in stack.
- `MODKEY + XK_space`: Zoom in on window.
- `MODKEY + XK_y`: Toggle fullscreen.
- `MODKEY|ShiftMask + XK_s`: Toggle sticky.
- `MODKEY + XK_q`: Close window.
- `MODKEY|ShiftMask + XK_x`: Kill unselected windows.
- `MODKEY|ShiftMask + XK_q`: Quit DWM.

### Layout Management
- `MODKEY + XK_t/m/c/f`: Set layout to tiled, monocle, centered master, or floating.
- `MODKEY|ControlMask + XK_comma/period`: Cycle through layouts.
- `MODKEY + XK_0`: View all tags.
- `MODKEY|ShiftMask + XK_0`: Apply current tag to window.
- `MODKEY + XK_comma/period`: Focus on previous/next monitor.
- `MODKEY|ShiftMask + XK_comma/period`: Move window to previous/next monitor.
- `MODKEY|Mod1Mask|ShiftMask + XK_comma/period`: Move all tags to previous/next monitor.
- `MODKEY|ShiftMask + XK_b`: Toggle alternative tag display.

## LF Key Bindings

### File Operations
- `E`: Extract files from archives.
- `D`: Delete files or directories.
- `C`: Copy files to a specified directory.
- `M`: Move files to a specified directory.
- `A`: Rename file (at the end).
- `c`: Rename file (clear input).
- `I`: Rename file (at the beginning).
- `i`: Rename file (before extension).
- `a`: Rename file (after extension).
- `B`: Bulk rename files.
- `b`: Set image as background.

### Navigation
- `<c-f>`: Open a file search prompt.
- `J`: Jump to a directory from bookmarks.
- `g`: Move to the top of the file list.
- `<c-n>`: Create a new directory.
- `<c-r>`: Reload current directory.
- `<c-s>`: Toggle hidden files.
- `<c-e>`: Move cursor down.
- `<c-y>`: Move cursor up.
- `V`: Open file in text editor.
- `W`: Open a new terminal window.
- `Y`: Copy file paths to clipboard.

## Mouse Bindings for DWM

Mouse bindings set in the DWM configuration:

- Click on dmenu: Launch dmenu.
- Click on layout symbol: Set layout.
- Right-click on layout symbol: Open layout menu.
- Click on window title: Zoom/focus on window.
- Click on status text: Send signal to status bar.
- Scroll on status text: Send scroll signal to status bar.
- Click on client window with MODKEY: Move or place window.
- Right-click on client window with MODKEY: Toggle floating.
- Drag client window with MODKEY: Resize window.
- Click on tag bar: View tag.
- Right-click on tag bar: Toggle view of tag.
- Click with MODKEY on tag bar: Apply tag to window.
- Right-click with MODKEY on tag bar: Toggle tag on window.

For further information and customization options, refer to the DWM and LF documentation and source code. This README provides a concise overview of the keybindings for quick reference in both DWM and LF.

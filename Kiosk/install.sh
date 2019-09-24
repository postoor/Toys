#!/bin/bash
# Config
URL="https://mail.google.com"

# PKG update
sudo apt -qq update && \
sudo apt -qq -y dist-upgrade

# Install vim sshd
sudo apt -qq -y install vim openssh-server
# Install brower
sudo apt -qq -y install chromium-browser

# Set Autorun
mkdir -p $HOME/.config/autostart
echo "
[Desktop Entry]
Type=Application
Name=Kiosk
Exec=$HOME/.local/bin/kiosk
X-GNOME-Autostart-enabled=true
" > \
$HOME/.config/autostart/kiosk.desktop

# Set Script
mkdir -p $HOME/.local/bin
echo "
#!/bin/bash

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' $HOME/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' $HOME/.config/chromium/Default/Preferences

/usr/bin/chromium-browser --kiosk $URL --password-store=basic &
" > $HOME/.local/bin/kiosk && chmod +X $HOME/.local/bin/kiosk

# Disable pkg update check
sudo systemctl disable --now apt-daily{,-upgrade}.{timer,service}

# Enable Auto Login
sudo sed -i 's/^.*AutomaticLoginEnable.*/AutomaticLoginEnable=true/' /etc/gdm3/custom.conf
sudo sed -i "s/^.*AutomaticLogin[^E].*/AutomaticLogin=$USER/" /etc/gdm3/custom.conf

# Disable Screensaver
gsettings set org.gnome.desktop.session idle-delay 0
# Disable screen lock
gsettings set org.gnome.desktop.screensaver lock-enabled false
# Enable Screen Keyboard
gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
#!/bin/bash

set -e

echo "Checking if GRUB is installed..."
if ! command -v grub-install &> /dev/null; then
    echo "GRUB not found, installing..."
    sudo pacman -S --noconfirm grub
else
    echo "GRUB is already installed."
fi

echo "Installing sbctl..."
sudo pacman -S --noconfirm sbctl

# GRUB EFI installation
echo "Installing GRUB EFI..."
sudo grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
echo "GRUB EFI installation completed."

# sbctl status check
echo "Checking sbctl status..."
setup_mode_status=$(sudo sbctl status | grep -i "setup mode" || true)

if echo "$setup_mode_status" | grep -iq "enabled"; then
    echo "Setup Mode is enabled, continuing..."
elif echo "$setup_mode_status" | grep -iq "disabled"; then
    if echo "$setup_mode_status" | grep -iq "secure boot enabled"; then
        echo "Secure Boot is already open."
    else
        echo "Enable the Setup Mode first."
        exit 1
    fi
fi

# sbctl verify and sign
echo "Verifying unsigned files..."
unsigned_files=$(sudo sbctl verify 2>&1 | grep "not signed" || true)

if [ -n "$unsigned_files" ]; then
    echo "Unsigned files found, signing..."
    while IFS= read -r file; do
        sudo sbctl sign "$file"
    done <<< "$unsigned_files"
    echo "All files signed."
else
    echo "All files are already signed."
fi

# Prompt for reboot
read -p "Do you want to reboot the system now? (y/N): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    sudo reboot
else
    echo "Reboot skipped."
fi

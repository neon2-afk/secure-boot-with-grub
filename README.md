# secure-boot-with-grub
easy script to install secure boot grub 
it will use sudo command so you should be in sudoers file also it will setup grub if you dont have and check if secure boot is enabled 
Setup Instructions

1. Clone the repository

git clone https://github.com/yourusername/your-repo.git
cd secure-boot-with-grub

2. Make the script executable

chmod +x secureboot-setup.sh

3. Run the script

./secureboot-setup.sh

> Note: You may need to run as root for some operations. If prompted, prepend sudo:



sudo ./secureboot-setup.sh

4. Script Actions

The script will perform the following actions:

1. Check if GRUB is installed, install it if missing.


2. Install sbctl if not present.


3. Install GRUB EFI with TPM support.


4. Check Setup Mode and Secure Boot status:

If Setup Mode is enabled → continue.

If Setup Mode is disabled and Secure Boot is disabled → ask to enable Setup Mode.

If Setup Mode is disabled but Secure Boot is already enabled → notify user and continue.



5. Verify unsigned files and sign them automatically.


6. Ask the user if they want to reboot the system.



5. Reboot

If you choose not to reboot immediately, make sure to manually reboot later for changes to take effect:

sudo reboot

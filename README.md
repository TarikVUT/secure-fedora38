# Important Notice:
This script is tailored for Fedora 38. It operates under root permissions. If you lack extensive Linux expertise, refrain from altering its contents. Take the time to thoroughly understand the script's functionality before deciding whether to execute it.

# secure-fedora38


The semester project involves the development of an advanced iteration of the Fedora operating system with an emphasis on modularity and enhanced security with minimal human intervention. The project focuses primarily on increasing resilience against physical and network threats by incorporating features such as disk integrity checking, disk encryption, and a robust firewall.
Automatic and secure updates will be an essential element to ensure seamless and secure updates at regular intervals. The directory structure will be carefully arranged to reduce the risk of system crashes due to lack of space by thoughtfully allocating partitions for the root directory and its subdirectories.
## 2- Dual boot
## 3- Partition structure and encryption of disks
To set up the partitions and encrypt data as described above, adhere to the steps below during the installation procedure:

Begin by booting your computer with the Fedora 38 Installer media in UEFI mode. Navigate to the "Install to Hard Drive" option on the Welcome to Fedora screen. Choose your preferred language. In the INSTALLATION SUMMARY screen, configure your Keyboard, Time & Date, and proceed to the Installation Destination.
Once on the INSTALLATION DESTINATION screen, select the Advanced Custom (Blivet-GUI) option and then confirm with the Done button.

You'll be directed to the BLIVET GUI PARTITIONING screen. Here, you'll craft the necessary partitions, file systems, and Btrfs subvolumes for Fedora 38 Workstation installation.

Begin by creating and mounting the EFI partition. Select the available space and utilize the + symbol to generate a partition. Set the partition size to 512 MiB, the Filesystem to EFI System Partition, and Mountpoint to /boot/efi.

Proceed to create and mount the /boot partition. Select the remaining free space, use the + sign to create a partition, set its size to 1 GiB, Filesystem to ext4, and Mountpoint to /boot.

Establish a LUKS2 encrypted Btrfs volume where the necessary subvolumes for Fedora Linux will reside. Utilize the remaining free space, configure it as a Btrfs Volume, set its size, name the volume (e.g., FEDORA), choose encryption type (luks2), and provide a robust password.

Create three subvolumes: root, home, and var. Root will be mounted at /, home at /home, and var at /var.

Select the Btrfs Volume from the left panel, click on the + symbol on the right panel, and create the var subvolume with Mountpoint as /var. Repeat the same process for / and /home.

Verify the configuration of partitions and subvolumes on the SUMMARY OF CHANGES screen. Confirm changes by clicking Accept Changes.

Upon completion of installation, click Finish installation and restart your computer. After restart, you'll be prompted for the LUKS2 passphrase.
## 4- Using strong passwords
## 5- Network configuration







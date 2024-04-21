> [!WARNING]
> This script is tailored for Fedora 38. It operates under root permissions. If you lack extensive Linux expertise, refrain from altering its contents. Take the time to thoroughly understand the script's functionality before deciding whether to execute it.

# Secure-fedora38
![](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/Desktop.png)
## Content
1. [Dual boot](#Dual_boot)
2. [Secure boot](#Secure_boot)
3. [Partition structure and encryption of disks](#Partition_structure)
4. [Set a strong password](#password)
5. [Network configuration](#Network)
6. [SELinux (Security-Enhanced Linux)](#SELinux)
7. [Users account permissions](#account_permissions)
8. [Audit Logging](#Audit_Logging)
9. [Regular backup](#Regular_backup)
10. [Update (fail-safe update)](#fail-safe)

-----------------------------------

The semester project involves the development of an advanced iteration of the Fedora operating system with an emphasis on modularity and enhanced security with minimal human intervention. The project focuses primarily on increasing resilience against physical and network threats by incorporating features such as disk integrity checking, disk encryption, and a robust firewall.
Automatic and secure updates will be an essential element to ensure seamless and secure updates at regular intervals. The directory structure will be carefully arranged to reduce the risk of system crashes due to lack of space by thoughtfully allocating partitions for the root directory and its subdirectories.


## 1- Dual boot
<a name="Dual_boot"></a>
Our system will feature dual boot functionality, comprising two operating systems. 
The primary system will serve as the main operating environment, while the secondary system will be a minimal setup devoid of a graphical user interface (GUI), facilitating SSH connectivity.


## 2- Secure boot
<a name="Secure_boot"></a>
You can protect GRUB with a password in two ways:

- Password is required for modifying menu entries but not for booting existing menu entries.
- Password is required for modifying menu entries as well as for booting existing menu entries.

### Setting password protection only for modifying menu entries
1- Issue the grub2-setpassword command as root.
```bash
# grub2-setpassword
```
2- Enter the password for the user and press the Enter key to confirm the password.
```bash
Enter password:
Confirm the password:
```
### Setting password protection for modifying and booting menu entries
1- Open the Boot Loader Specification (BLS) file for boot entry you want to modify from the /boot/loader/entries/ directory.

2- Find the line beginning with grub_users. This parameter passes extra arguments to menuentry.

3- Set the grub_users attribute to the user name that is allowed to boot the entry besides the superusers, by default this user is root. Here is a sample configuration file:
```bash
grub_users root
grub_arg --unrestricted
grub_class kernel
```
> [!NOTE]
> For more information refer to [Protecting GRUB with a password](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/assembly_protecting-grub-with-a-password_managing-monitoring-and-updating-the-kernel) .

### The result

https://github.com/TarikVUT/secure-fedora38/assets/78847793/116d3576-cf30-4739-9f13-f739783912fb


## 3- Partition structure and encryption of disks
<a name="Partition_structure"></a>
To set up the partitions and encrypt data as described above, adhere to the steps below during the installation procedure:

1. Begin by booting your computer with the Fedora 38 Installer media in UEFI mode. Navigate to the "Install to Hard Drive" option on the Welcome to Fedora screen. Choose your preferred language. In the INSTALLATION SUMMARY screen, configure your Keyboard, Time & Date, and proceed to the Installation Destination.
Once on the INSTALLATION DESTINATION screen, select the Advanced Custom (Blivet-GUI) option and then confirm with the Done button.


![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/1_set_encrypt.png)

2. You'll be directed to the BLIVET GUI PARTITIONING screen. Here, you'll craft the necessary partitions, file systems, and Btrfs subvolumes for Fedora 38 Workstation installation.

   
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/2_set_encrypt.png)

3. Begin by creating and mounting the EFI partition. Select the available space and utilize the + symbol to generate a partition. Set the partition size to 512 MiB, the Filesystem to EFI System Partition, and Mountpoint to /boot/efi.
   
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/3_EFI.png)

4. Proceed to create and mount the /boot partition. Select the remaining free space, use the + sign to create a partition, set its size to 1 GiB, Filesystem to ext4, and Mountpoint to /boot.
   
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/4_luks2.png)

5. Establish a LUKS2 encrypted Btrfs volume where the necessary subvolumes for Fedora Linux will reside. Utilize the remaining free space, configure it as a Btrfs Volume, set its size, name the volume (e.g., FEDORA), choose encryption type (luks2), and provide a robust password.
   
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/5_crypt.png)

6. Create three subvolumes: root, home, and var. Root will be mounted at /, home at /home, and var at /var.
Select the Btrfs Volume from the left panel, click on the + symbol on the right panel, and create the var subvolume with Mountpoint as /var. Repeat the same process for / and /home.

![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/6_partition.png)

7. Verify the configuration of partitions and subvolumes on the SUMMARY OF CHANGES screen. Confirm changes by clicking Accept Changes.
   
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/7_LUKS.png)

8. Upon completion of installation, click Finish installation and restart your computer. After restart, you'll be prompted for the LUKS2 passphrase.
   
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/8_partitions.png)

The outcome is a system comprising five partitions: /, /boot, /boot/efi, /home, and /var, with encryption applied to /, /home, and /var. It's essential to note that the /boot/efi partition is established for EFI-based systems. Conversely, for BIOS-based systems, a "biosboot" partition of 1 MiB is created instead.
Refer to [Install Fedora 38 with LUKS Full Disk Encryption (FDE)](https://sysguides.com/fedora-35-luks-full-disk-encryption)

## 4- Set a strong password
<a name="password"></a>
In Fedora 38 the default configuration file for pam_pwquality is /etc/security/pwquality.conf.\\
The examples provided are for only illustrative purposes, for more information refer to man pwquality.conf.\\
Insert the following option in /etc/security/pwquality.conf or create the .conf file in /etc/security/pwquality.d:\\

1- Password size (Minimum acceptable length for the new password).
```bash
minlen = 12
```
2- Maximum credit for having digits in the password.
```bash
dcredit = -1
```
3- Maximum credit for having uppercase characters in the password.
```bash
ucredit = -1
```
4- Maximum credit for having lowercase characters in the password.
```bash
lcredit = 1
```
5- Maximum credit for having other characters in the password.
```bash
ocredit = 1
```
> [!Note]
> On credits: The credit values configured for dcredit, ucredit, lcredit & ocredit are only for illustrative purposes. The credit values can be configured in different ways as per requirements. The credit values can be set as follows:
> - Credit Value > 0: Maximum credit for having respective characters in the new password.
> - Credit Value < 0: Minimum mandatory credit required for having respective characters in the new password.
> - Credit Value = 0: No mandatory requirement for having the respective character class in the new password.

6- Minimum number of required character classes in the password.
```bash
minclass = 1
```
7- Maximum number of allowed consecutive same characters in the password.
```bash
maxrepeat = 2
```
8- Maximum number of allowed consecutive characters of the same class in the password.
```bash
maxclassrepeat = 2
```
9- Set the number of characters from the old password that must not be present in the new password.
```bash
difok = 5
```
> [!Note]
> This option will not work for root as root is not asked for an old password so the checks that compare the old and new password are not performed.
> For more information refer to [Passphrase policy](https://docs.fedoraproject.org/en-US/fesco/Passphrase_policy/)







## 5- Network configuration
<a name="Network"></a>
### 1- OpenSSH
SSH (Secure Shell) is a protocol that facilitates secure communication between two systems using the client-server architecture and allows users to remotely log on to the server's host systems. Unlike other remote communication protocols, such as FTP, Telnet, or rlogin, SSH encrypts the login session so that intruders cannot obtain unencrypted passwords.

By default, SSH is disabled and stopped in Fedora. To enable and run the SSH daemon (sshd), use the following command in the first step.
Enabling and Starting SSH service at system startup:
```bash
# systemctl enable sshd
# systemctl start sshd
```
When these commands are executed, SSH should be enabled and executed in Fedora

Fedora by default uses a set of key exchange algorithms, ciphers, Message Authentication Code (MAC) algorithms, and server host key algorithms. Some of these are obsolete and are designed to establish stable connections with older operating systems that do not support newer alternatives. On our system, we deactivate all unsecured algorithms, ciphers, MACs, etc. The following list represents the output of the nmap command, which reveals the enabled algorithms, ciphers, and MACs in Fedora by default.

```bash
[root@fedora ~]# nmap --script ssh2-enum-algos -sV -p 22 127.0.0.1
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-26 21:05 CET
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000089s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.0 (protocol 2.0)
| ssh2-enum-algos: 
|   kex_algorithms: (10)
|       curve25519-sha256
|       curve25519-sha256@libssh.org
|       ecdh-sha2-nistp256
|       ecdh-sha2-nistp384
|       ecdh-sha2-nistp521
|       diffie-hellman-group-exchange-sha256
|       diffie-hellman-group14-sha256
|       diffie-hellman-group16-sha512
|       diffie-hellman-group18-sha512
|       kex-strict-s-v00@openssh.com
|   server_host_key_algorithms: (4)
|       rsa-sha2-512
|       rsa-sha2-256
|       ecdsa-sha2-nistp256
|       ssh-ed25519
|   encryption_algorithms: (5)
|       aes256-gcm@openssh.com
|       chacha20-poly1305@openssh.com
|       aes256-ctr
|       aes128-gcm@openssh.com
|       aes128-ctr
|   mac_algorithms: (8)
|       hmac-sha2-256-etm@openssh.com
|       hmac-sha1-etm@openssh.com
|       umac-128-etm@openssh.com
|       hmac-sha2-512-etm@openssh.com
|       hmac-sha2-256
|       hmac-sha1
|       umac-128@openssh.com
|       hmac-sha2-512
|   compression_algorithms: (2)
|       none
|_      zlib@openssh.com
```
#### SSH vulnerabilities:

##### 1- [CVE-2020-15778](https://bugzilla.redhat.com/show_bug.cgi?id=1860487)

An error was found in the scp program supplied with the openssh-clients package. An attacker who had the ability to copy files with the scp program to a remote server could execute any command on the remote server by inserting a command in the name of the copied file on the server. This command is executed with the user's rights with which the files were copied to the remote server.
Mitigation of impacts:
The way to mitigate the vulnerability of CVE-2020-15778 is to change the SCP privilege so that it cannot be triggered:
```bash
chmod 0000 /usr/bin/scp
```
> [!IMPORTANT]
> Please note that this solution is temporary and will revert to the original permissions in case of reinstallation or update of openssh-clients.

##### 2- [CVE-2023-48795/ HMAC (SHA1)](https://bugzilla.redhat.com/show_bug.cgi?id=2254210)

An SSH channel integrity error was found. By manipulating sequential numbers during a handshake, an attacker can delete the initial messages of a secure channel without causing a MAC failure. For example, an attacker could disable the ping extension, rendering inoperable the new countermeasure in OpenSSH 9.5 against attacks by keystroke timing. SHA1 is no longer considered safe and must be disabled.
Mitigation of impacts:\\
As an alternative, less invasive countermeasure, the affected chacha20-poly1305 cipher modes and all Mac-based encryption variants (generic EtM) can be (temporarily) disabled. Some cipher modes, in particular AES-GCM, are not affected and can continue to be used unchanged.\\
Deactivation of these ciphers and MACs can be done through cryptographic policies. System-wide cryptographic policies function as basic configurations of cryptographic subsystems and include protocols such as TLS, IPsec, SSH, DNSsec and Kerberos. These policies offer a concise selection from which administrators can choose. To achieve this modification, sub-policies with the following content can be implemented.

```bash
cipher@SSH = -CHACHA20-POLY1305
mac@ssh = -SHA1
ssh_etm = 0
```
By inserting these lines into /etc/crypto-policies/policies/modules/CVE-2023-48795.pmod, using the resulting sub-policy using
```bash
# update-crypto-policies --set $(update-crypto-policies --show):CVE-2023-48795
```
and restart the openssh server.
```bash
# systemctl restart sshd
```
Output of Nmaps after mitigation of those vulnerabilities.
```bash
[root@fedora ~]# nmap --script ssh2-enum-algos -sV -p 22 127.0.0.1
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-26 21:05 CET
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000089s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.0 (protocol 2.0)
| ssh2-enum-algos: 
|   kex_algorithms: (10)
|       curve25519-sha256
|       curve25519-sha256@libssh.org
|       ecdh-sha2-nistp256
|       ecdh-sha2-nistp384
|       ecdh-sha2-nistp521
|       diffie-hellman-group-exchange-sha256
|       diffie-hellman-group14-sha256
|       diffie-hellman-group16-sha512
|       diffie-hellman-group18-sha512
|       kex-strict-s-v00@openssh.com
|   server_host_key_algorithms: (4)
|       rsa-sha2-512
|       rsa-sha2-256
|       ecdsa-sha2-nistp256
|       ssh-ed25519
|   encryption_algorithms: (4)
|       aes256-gcm@openssh.com
|       aes256-ctr
|       aes128-gcm@openssh.com
|       aes128-ctr
|   mac_algorithms: (3)
|       hmac-sha2-256|
|       umac-128@openssh.com
|       hmac-sha2-512
|   compression_algorithms: (2)
|       none
|_      zlib@openssh.com
```
Alternatively, when configuring a "crypto-policy" such as FUTURE, the vulnerable key exchange algorithm, cipher and MAC can be disabled. This configuration has a wide impact and affects various services, such as TLS, IPsec, SSH, DNSsec and Kerberos. However, it is necessary to use specific steps to increase the security of openSSH in order to address vulnerabilities such as CVE-2020-15778 and CVE-2023-48795/HMAC (SHA1).

### 2- OpenSSL
OpenSSL in Fedora is a widely used open source library that provides cryptographic functionality. It is used in various security-sensitive applications for data encryption, secure communications, and more.
Like OpenSSH, OpenSSL in Fedora implements the "DEFAULT" cryptographic policy, which may allow some weak ciphers for compatibility. To mitigate this vulnerability, Fedora offers the 'FUTURE' cryptographic policy, which effectively disables all weak ciphers. In addition, the 'FUTURE' policy disables TLSv1, TLSv1.1, and SSLv3 protocols that are obsolete. Below you will find a list of ciphers allowed under the DEFAULT policy, along with ciphers under the FUTURE policy.

```bash
[root@fedora modules]# openssl ciphers -s -v
TLS_AES_256_GCM_SHA384         TLSv1.3 Kx=any      
TLS_CHACHA20_POLY1305_SHA256   TLSv1.3 Kx=any      
TLS_AES_128_GCM_SHA256         TLSv1.3 Kx=any      
TLS_AES_128_CCM_SHA256         TLSv1.3 Kx=any      
ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2 Kx=ECDH     
ECDHE-RSA-AES256-GCM-SHA384    TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-CHACHA20-POLY1305  TLSv1.2 Kx=ECDH     
ECDHE-RSA-CHACHA20-POLY1305    TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-AES256-CCM         TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-AES128-GCM-SHA256  TLSv1.2 Kx=ECDH     
ECDHE-RSA-AES128-GCM-SHA256    TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-AES128-CCM         TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-AES256-SHA         TLSv1   Kx=ECDH     
ECDHE-RSA-AES256-SHA           TLSv1   Kx=ECDH     
ECDHE-ECDSA-AES128-SHA         TLSv1   Kx=ECDH     
ECDHE-RSA-AES128-SHA           TLSv1   Kx=ECDH     
AES256-GCM-SHA384              TLSv1.2 Kx=RSA      
AES256-CCM                     TLSv1.2 Kx=RSA      
AES128-GCM-SHA256              TLSv1.2 Kx=RSA      
AES128-CCM                     TLSv1.2 Kx=RSA      
AES256-SHA                     SSLv3   Kx=RSA      
AES128-SHA                     SSLv3   Kx=RSA      
DHE-RSA-AES256-GCM-SHA384      TLSv1.2 Kx=DH       
DHE-RSA-CHACHA20-POLY1305      TLSv1.2 Kx=DH       
DHE-RSA-AES256-CCM             TLSv1.2 Kx=DH       
DHE-RSA-AES128-GCM-SHA256      TLSv1.2 Kx=DH       
DHE-RSA-AES128-CCM             TLSv1.2 Kx=DH       
DHE-RSA-AES256-SHA             SSLv3   Kx=DH       
DHE-RSA-AES128-SHA             SSLv3   Kx=DH  
```
After applying the "FUTURE" crypto-policy.
```bash
[root@fedora modules]# openssl ciphers -s -v
TLS_AES_256_GCM_SHA384         TLSv1.3 Kx=any      
TLS_CHACHA20_POLY1305_SHA256   TLSv1.3 Kx=any      
ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2 Kx=ECDH     
ECDHE-RSA-AES256-GCM-SHA384    TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-CHACHA20-POLY1305  TLSv1.2 Kx=ECDH     
ECDHE-RSA-CHACHA20-POLY1305    TLSv1.2 Kx=ECDH     
ECDHE-ECDSA-AES256-CCM         TLSv1.2 Kx=ECDH     
DHE-RSA-AES256-GCM-SHA384      TLSv1.2 Kx=DH       
DHE-RSA-CHACHA20-POLY1305      TLSv1.2 Kx=DH       
DHE-RSA-AES256-CCM             TLSv1.2 Kx=DH
```
### 3- Firewall
The firewall consists of 3 input strings: INPUT, FORWARD and OUTPUT. As part of our project, we will focus only on the INPUT input string, because the FORWARD string would only be relevant to us if the OS forwards packets further, which is not the case at the end station, and the last OUTPUT string is mainly suitable for routers and networks where we are not able to ensure absolute control over user stations. In our project, we will not try to prevent unwanted traffic from leaving, but prevent it by further securing the system.

Thus, we continue only with the INPUT string, which upon arrival has 3 possible actions: the packet will be discarded (DROP), rejected (REJECT) or accepted (ACCEPT). The executed action will be executed depending on the rule that first satisfies the input parameters. The input rules are numbered and checked in a certain order, as we can see below in the picture. For the order of the rules, it is advisable to stick to the concept where the rule with the highest traffic will be placed highest in the table and the rule with the least traffic as the penultimate. The last rule is one that discards any remaining packets.

In our system we use Uncomplicated Firewall(ufw), which already solves the above mentioned last rule automatically and it is enough only to allow packets, in our case it is SSH protocol working on TCP port 22.


## 6- SELinux (Security-Enhanced Linux)
<a name="SELinux"></a>
SELinux is a Linux kernel-integrated security architecture that provides mandatory access controls. SELinux helps prevent unauthorized access, increases system security, and minimizes the impact of security vulnerabilities


SELinux increases system security by enforcing access policies and limiting the actions that processes and users can take. Keeping it active helps protect the system from various security threats and potential abuses. Shutting down SELinux can weaken system security.

You can check the state of SELinux by running the sestatus command:
```bash
$ sestatus
```


If SELinux is active, "enabled" is displayed on the output. If SELinux is not active, "disabled" is displayed.
SELinux modes include "Enforcing", "Permissive" and "Disabled". To set SELinux to Enforcing mode:
```bash
$ sudo setenforce 1
```

The above command sets SELinux to Enforcing. In our operating system, this change must be permanent, which can be affected by editing "/etc/selinux/config", changing the line starting with SELINUX= to SELINUX=enforcing.
```bash
$ sudo vi /etc/selinux/config

SELINUX=enforcing
```

## 7- Users account permissions
<a name="account_permissions"></a>
The goallsit is to create a hierarchical user structure consisting of three levels:
  - Administrators
  - Users
  - Technicians
    
This arrangement is intended to increase system security. These levels correspond to the following groups:

  - AdminUsers: Members of this group have permissions equivalent to those of root, including the ability to use OpenSSH. Non-members, on the other hand, are prohibited from using OpenSSH.
  - passwd_group: Users assigned to this group have permissions to change their passwords.
  - Newly added users who do not belong to either AdminUsers or passwd_group are assigned to the Technicians category. Technicians do not have the ability to change their passwords and cannot change their home directories.

To implement this configuration, the following steps are described:

1- Create the AdminUserss group, grant root-level access to members, and grant permission to use OpenSSH.
- To create the "AdminUser" group in Fedora, usually use the "groupadd" command. Here is the procedure:
```bash
# groupadd Admin_User
```
This command creates a new group called "AdminUsers" in Fedora.

- After creating the group, you can add users to it using the usermod command:

```bash
# usermod -aG AdminUser username
```
Replace the username with the username of the user you want to add to the "AdminUser" group.
Note: Note that after adding a user to the "AdminUsers" group, you may need to log out and log in again for the changes to take effect.

- To grant sudo permission to the "AdminUsers" group, create the "AdminUsers" file in "/etc/sudoers.d/" and add the following line to it:

```bash
%AdminUser ALL=(ALL) ALL
```
This line means that any user in the "AdminUser" group can run any command as any user using sudo.

- Set the group for accessing OpenSSH. To allow only users in the "AdminUsers" group to access OpenSSH, you can edit the SSH server configuration file (sshd_config) by adding the line below to the end of the "/etc/ssh/sshd_config" file.
```bash
AllowGroups AdminUsers
```
Restart the SSH service to apply the changes.
```bash
# systemctl restart sshd
```
With this configuration, only users who are members of the AdminUsers group will be able to access SSH. Other users will not be able to log in via SSH.

2- Create the "passwd_group" group to make it easier for users assigned to it to change their passwords.

- Change the permissions to /usr/bin/passwd:
 Open the terminal and run the following command:
```bash
sudo chmod o-rx /usr/bin/passwd
```
This command removes the read and run permissions for other users in /usr/bin/passwd, preventing them from running passwd.

- Create a group for users who are allowed to change passwords:
```bash
sudo groupadd password_group
```
- Add users to a new group:
```bahs
sudo usermod -aG password_group <username>
```

- Change passwd group ownership to password_group and set group permissions so that members of this group can run passwd. Run:
```bash
# chown root:password_group /usr/bin/passwd
```
This command will allow members of the password_group to run passwd.

By following above steps, only users who are members of the password_group (i sudoers) will be able to change their passwords, while others will not be able to access passwd.i to log on via SSH.

3- All users who are newly added to the system and are not explicitly assigned to any of the specified groups will be automatically marked as Technicians, without any predefined permissions.

## 8- Audit Logging
<a name="Audit_Logging"></a>
Log files contain messages about the system, including the kernel, services, and applications that run on it. They contain information that helps solve problems or simply monitor system functions. Fedora uses the systemd system and service manager. Thanks to systemd, messages for most services are now stored in the systemd journal, a binary file that needs to be accessed with the journalctl command.
For more details refer to [Viewing and Managing Log Files](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/monitoring-and-automation/Viewing_and_Managing_Log_Files/)

To install the rsyslog package in Fedora, use the following command:
```bash
# dnf install -y rsyslog
```
After the installation, start the rsyslog service:
```bash
# systemctl start rsyslog
```
And enable it to start the system:
```bash
# systemctl enable rsyslog.
```
### Rotate logs to another server
When it comes to rotating logs to another server, you can configure rsyslog to forward logs to a remote server. To do this, you need to edit the /etc/rsyslog.conf configuration file or create a new configuration file in the /etc/rsyslog.d/ directory.
There are several ways to send protocols from client to server.

- Rotation via UDP
- Rotation via TCP
- Rotation via RELP
- Rotation over TLS

---------------------------- 
 
#### Rotation via UDP
Below are steps to configure client-to-server protocol rotation over UDP. Before you continue, make sure the "rsyslog" service is installed and running:

- Enable the UDP port to transfer the protocol from the client to the server on both sides. In our case, use port 514/udp:
```bash
# firewall-cmd --permanent --add-port=514/udp
# firewall-cmd --reload
```

- On the client side, rotate all protocols to the server by adding the following configuration line at the end of the "/etc/rsyslog.conf" file:
```bash
*.* @192.168.0.123:514
```
"*.*" indicates all logs.
"@" indicates the use of the UDP protocol.

On the server side, add the following line at the end of the "/etc/rsyslog.conf" file:
```bash
module(load="imudp")
input(type="imudp" port="514")
```
This configuration allows the server to receive logs from the client and store them in the default log directory "/var/log/".

The image below shows the successful transfer of logs from client to server. It appears that the "logger" command was used on the client side for testing purposes.

![](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/test_udp_logs.png)

---------------------------- 

#### Rotation via TCP
Rotating the protocol over TCP is similar to the UDP protocol. It starts by enabling the port and ends with configuration on the server side. 

- Enable the TCP port to transfer the protocol from client to server on both sides. In our case, use the port 10514/tcp:
```bash
# firewall-cmd --permanent --add-port=10514/tcp
# firewall-cmd --reload
```

- On the client side, rotate all protocols to the server by adding the following configuration line at the end of "/etc/rsyslog.conf":
```bash
*.* @@192.168.0.123:10514
```
"@" indicates TCP usage.
- On the server side, add the following line to the end of the "/etc/rsyslog.conf" file:
```bash
module(load="imtcp")
input(type="imtcp" port="10514")
```

The image below shows the successful transfer of logs from client to server. It appears that the "logger" command was used on the client side for testing purposes.

![]()

---------------------------- 

#### Rotation via RELP
Using the Reliable Event Logging Protocol (RELP) facilitates the secure transmission and reception of syslog messages over TCP, thereby significantly minimizing the probability of losing a message. RELP ensures reliable transmission of event messages, making it particularly valuable in environments where the loss of such messages is unbearable. To implement RELP, the configuration requires setting the imrelp input module on the server responsible for receiving the logs and the omrelp output module on the client in charge of transferring the logs to the specified logging server.

Some prerequisites must be met before continuing with the RELP configuration:
Installing the **rsyslog**, **librelp** and **rsyslog-relp** packages on both the server and client systems. Ensuring that the specified port is authorized under SELinux and enabled through firewall settings to facilitate uninterrupted communication.
- On the client system, create a new .conf file in the /etc/rsyslog.d/ directory named for example relpclient.conf and insert the following content:
```bash
module(load="omrelp")
*.* action(type="omrelp" target="_target_IP_" port="_target_port_")
```
__target_IP__ is the server's IP address.
__target_port__ is the server's port.

Save the changes to /etc/rsyslog.d/relpclient.conf, and restart the rsyslog service.
```bash
# systemctl restart rsyslog
```
- On the server, create a new .conf file in the /etc/rsyslog.d/ directory named for example relpserv.conf, and insert the following content:
```bash
ruleset(name="relp"){
*.* action(type="omfile" file="_log_path_")
}
module(load="imrelp")
input(type="imrelp" port="_target_port_" ruleset="relp")
```
__log_path__ the path for storing messages.
__target_port__ is server's port. Use the same value as in the client's configuration file.

- Save the changes to /etc/rsyslog.d/relpserv.conff, and restart the rsyslog service.
```bash
# systemctl restart rsyslog
```
![](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/relp-logs.png)

---------------------------- 

#### Rotation via TLS
Refer to [Configuring a remote logging solution](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/assembly_configuring-a-remote-logging-solution_security-hardening)

## 9- Regular backup
<a name="Regular_backup"></a>
When a software or hardware failure occurs, the system administrator must address three tasks to restore the system to a fully functional state in the new hardware environment:
1- booting a rescue system on the new hardware
2- replicating the original storage layout
3- restoring user and system files

### How to set up ReaR to backup with NFS method
Take the following steps on the NFS system.
1- Install the nfs-utils package.
```bash
# yum install nfs-utils
```
2-  Create and export a directory on the NFS system. In this example, /storage is the exported directory.
```bash
# mkdir /storage

# cat /etc/exports
/storage        *(fsid=0,rw,sync,no_root_squash,no_subtree_check,crossmnt)
```
3- Start NFS server.
```bash
# systemctl start nfs-server
```
Take the following steps on the client system that you intend to backup.

1- Install the rear and nfs-utils packages.
```bash
# yum install rear nfs-utils
```
2- Modify the /etc/rear/local.conf configuration file on the client system to reflect the following settings. In this example, the local IP address 192.168.56.1 represents the NFS system.
```bash
# cat /etc/rear/local.conf
OUTPUT=ISO
OUTPUT_URL=nfs://192.168.56.1/storage
BACKUP=NETFS
BACKUP_URL=nfs://192.168.56.1/storage
NETFS_KEEP_OLD_BACKUP_COPY=y
```
3- Run the following command to generate the disaster recovery system and backup files.
```bash
# rear -d -v mkbackup
```


> [!IMPORTANT]
> For details information refer [ Relax-and-Recover (ReaR)](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-relax-and-recover_rear)

## 10- System update 
<a name="fail-safe"></a>
To ensure that the system is always up to date without major intervention, we need to configure automatic updates using the Cronjob tool. Manual updates can lead to missing critical updates and~you need to have the latest updates and patches to keep the device safe from both security flaws and software errors. Cronjobs makes this easier by performing tasks automatically at certain intervals without any user intervention.

To guarantee the security and safety of the system, it will undergo a daily security update and a comprehensive update every week. Additionally, system backups will occur daily, scheduled to run before each update.

### Installation, enable and start cron

```bash
# dnf install cronie -y 
# systemctl enable crond
# systemctl start crond
```
To plan a daily security update using the  /etc/Cron.daily/, we can create a script that makes the update.
- Creating a script called daily_system_Update.sh
```bash
#!/bin/bash

# Here you should run the command to backup the system.
# The command will depend on the method you use to back up your system
#
# The command 
#
# Update the package repositories
sudo dnf -y update --security

# Log the update processe
echo "Daily system update executed on $(date)" >> /var/log/daily_system_update.log
```
To plan a weekly update using the  /etc/Cron.weekly/, we can create a script that makes the update.
- Creating a script called weekly_system_Update.sh
```bash
#!/bin/bash
# Here you should run the command to backup the system.
# The command will depend on the method you use to back up your system
#
# The command 
#
# Update the package repositories
sudo dnf -y update

# Log the update processe
echo "Weekly system update executed on $(date)" >> /var/log/weekly_system_update.log

```
Make sure the scripts are executable:
```bash
# chmod +x daily_system_update.sh.
# chmod +x weekly_system_update.sh.
```
Move the "daily_system_Update.sh" to the /etc/cron.daily/, and the script "weekly_system_update.sh" to the /etc/cron.weekly/ directory:
```bash
# mv daily_system_update.sh /etc/cron.daily/
# mv weekly_system_update.sh /etc/cron.weekly/
```
Now the script for the security update will run every day and the script for the whole system update will run weekly and update the system. The results can be checked in the protocol file (in this example /var/log/daily_system_update.log and /var/log/weekly_system_update.log.)
> [!WARNING]
> Critical note: Prioritize system backup before commencing the update process. This precautionary measure safeguards against potential failures during the update. In the event of a system crash, recovery can be swiftly facilitated using the backup. This approach supersedes the OSTree update method.


# Current state of the solution

- [ ] Dual boot
- [x] Secure boot
- [x] Partition structure and encryption of disks
- [x] Set a strong password
- [x] Network configuration
     - [x] OpenSSH
     - [x] OpenSSL
     - [x] Firewall
- [x] SELinux (Security-Enhanced Linux)
- [x] Users account permissions
- [x] Audit Logging
    - [x] UDP
    - [x] TCP
    - [x] RELP
    - [x] OVER TLS
- [ ] Regular backup
- [ ] Update (fail-safe update)



# Important Notice:
This script is tailored for Fedora 38. It operates under root permissions. If you lack extensive Linux expertise, refrain from altering its contents. Take the time to thoroughly understand the script's functionality before deciding whether to execute it.

# secure-fedora38


The semester project involves the development of an advanced iteration of the Fedora operating system with an emphasis on modularity and enhanced security with minimal human intervention. The project focuses primarily on increasing resilience against physical and network threats by incorporating features such as disk integrity checking, disk encryption, and a robust firewall.
Automatic and secure updates will be an essential element to ensure seamless and secure updates at regular intervals. The directory structure will be carefully arranged to reduce the risk of system crashes due to lack of space by thoughtfully allocating partitions for the root directory and its subdirectories.
## 2- Dual boot
## 3- Partition structure and encryption of disks
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

6. Establish a LUKS2 encrypted Btrfs volume where the necessary subvolumes for Fedora Linux will reside. Utilize the remaining free space, configure it as a Btrfs Volume, set its size, name the volume (e.g., FEDORA), choose encryption type (luks2), and provide a robust password.
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/5_crypt.png)

7. Create three subvolumes: root, home, and var. Root will be mounted at /, home at /home, and var at /var.
Select the Btrfs Volume from the left panel, click on the + symbol on the right panel, and create the var subvolume with Mountpoint as /var. Repeat the same process for / and /home.
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/6_partition.png)

8. Verify the configuration of partitions and subvolumes on the SUMMARY OF CHANGES screen. Confirm changes by clicking Accept Changes.
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/7_LUKS.png)

9. Upon completion of installation, click Finish installation and restart your computer. After restart, you'll be prompted for the LUKS2 passphrase.
![My Remote Image](https://github.com/TarikVUT/secure-fedora38/blob/main/Images/8_partitions.png)

The outcome is a system comprising five partitions: /, /boot, /boot/efi, /home, and /var, with encryption applied to /, /home, and /var. It's essential to note that the /boot/efi partition is established for EFI-based systems. Conversely, for BIOS-based systems, a "biosboot" partition of 1 MiB is created instead.
Refer to [Install Fedora 38 with LUKS Full Disk Encryption (FDE)](https://sysguides.com/fedora-35-luks-full-disk-encryption)

## 4- Set a strong password
## 5- Network configuration
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
Please note that this solution is temporary and will revert to the original permissions in case of reinstallation or update of openssh-clients.

##### 2- [CVE-2023-48795/ HMAC (SHA1)](https://bugzilla.redhat.com/show_bug.cgi?id=2254210)
An SSH channel integrity error was found. By manipulating sequential numbers during a handshake, an attacker can delete the initial messages of a secure channel without causing a MAC failure. For example, an attacker could disable the ping extension, rendering inoperable the new countermeasure in OpenSSH 9.5 against attacks by keystroke timing. SHA1 is no longer considered safe and must be disabled.
Mitigation of impacts:
As an alternative, less invasive countermeasure, the affected chacha20-poly1305 cipher modes and all Mac-based encryption variants (generic EtM) can be (temporarily) disabled. Some cipher modes, in particular AES-GCM, are not affected and can continue to be used unchanged.
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
The goallsit is to create a hierarchical user structure consisting of three levels:
    - Administrators
    - Users
    - Technicians
    
This arrangement is intended to increase system security. These levels correspond to the following groups:

  - AdminUsers: Members of this group have permissions equivalent to those of root, including the ability to use OpenSSH. Non-members, on the other hand, are prohibited from using OpenSSH.
  - passwd_group: Users assigned to this group have permissions to change their passwords.
  - Newly added users who do not belong to either AdminUsers or passwd_group are assigned to the Technicians category. Technicians do not have the ability to change their passwords and cannot change their home directories.

## 8- Audit Logging
## 9- Regular backup

# Current state of the solution

- [ ]
- [ ] Dual boot
- [x] Partition structure and encryption of disks
- [x] Set a strong password
- [x] Network configuration
      - [x] OpenSSH
      - [x] OpenSSL
      - [ ] Firewall
- [ ]
- [ ]
- [ ]
- [ ]



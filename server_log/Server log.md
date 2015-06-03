# Server log

This is a log for how I configured a server I purchased.

The main purpose of the server was to run RAM intensive computations, but I got addicted to Linux and decided to host everything myself.


Server specs:
Dell 2950
2x 3.0 GHz Intel Xeon quad cores 
32 GB of ram

1) Install Ubunutu

I had a bootable Ubunutu flash drive from when I was installing it on my laptop, so I went ahead and installed the standard 64 bit version of Ubunutu.

2) Convert Ubunutu to Ubuntu server

The kernal is the same, Ubunutu server just removes the user interface and just provides a command line.

Taken from here: (http://www.darrinhodges.com/converting-ubuntu-12-04-lts-desktop-to-server/) I used the following commands:

	
	sudo apt-get install tasksel

	sudo tasksel remove ubuntu-desktop (Note: this may take a few minutes to complete)

	sudo tasksel install server

	sudo apt-get install linux-server linux-image-server

	sudo apt-get –purge remove lightdm

Providing all that went well, you can edit your /etc/default/grub configuration file to update the following settings:

GRUB_TIMEOUT=5
( Comment out ‘GRUB_HIDDEN_TIMEOUT’ )
GRUB_CMDLINE_LINUX_DEFAULT=”"
GRUB_TERMINAL=console ( only for PC )
sudo update-grub

When the grub update has finished, you can reboot and you should be good to go.

3) Setting up domain to point to static ip address

I (unfortunately) bought my personal domain name on godaddy.  I went to the launch domain name, and added an A record which points to the IP of the server with a subdomain such as server (for example).

So now, instead of having to memorize the ipaddress I can just navigate to server.andrewandrade.ca for example

4) Set up openssh (ssh into machines)

Lucky for me, I have an external ip address for my server.
I followed the following instructions to set up ssh server: https://help.ubuntu.com/community/SSH/OpenSSH/Configuring

I suggest you follow all the instructions for maximum security


5) Install Rstudio

I followed the instructions here:
http://www.rstudio.com/products/rstudio/download-server/


6) Upgrade the harddrives, set up RAID, LVM & rsync over ssh

I installed a fusion io card I won at a hackathon with a solid 1.7 TB of solidstate goodness and upgraded the hard drives to 4x 2TB SATA drives in a RAID array instead of the 500 GB which came with it.

I also have 2x 74 gb SAS drives for any writing intensive operation (so I do not burn the SSD's out, and get better performance than the SATA drives)

I am currently running ubunutu server with shared user access, I decided to store files using LVM and then change permissions so only I had accress to the personal files, but allow other uers to have access to a storage block (minize the write to the SSD)

Here are a couple of tutorials which go over LVM
http://www.howtoforge.com/linux_lvm
http://www.linuxdevcenter.com/pub/a/linux/2006/04/27/managing-disk-space-with-lvm.html
http://www.linuxdevcenter.com/pub/a/linux/2006/04/27/managing-disk-space-with-lvm.html
http://tldp.org/HOWTO/LVM-HOWTO/index.html

Step 1: Partition the disk

Determine the path to the drive:

	sudo lshw -C disk

List of drives and information:

	sudo fdisk -l

fdisk is only useful if your partition is under 2TB.  MBR partition only supports 4 primary partitions per hard drive, and a maximum partition size of 2TB. To solve this we use parted and use gpt.

For this example I am going to use /dev/sda as the mount point

	sudo parted /dev/sda

Step 2: We are now going to make the partitions:

	mkpart ext4 1MiB 100%
Since the partition is on the first slot:
	set 1 lvm on
Now we prepare our new partitions (physical volume) for LVM:

	pvcreate /dev/sda1

To display what we just did:

	pvdisplay

To delete a pysical volume

	pvremove /dev/sda1

Step 3: create a volume group

vgcreate name /dev/sda1

to display volume groups:
	vgdisplay

to scan volumes
	vgscan

to rename
	vgrename fileserver data

to delete

	vgremove data

Step 4: create a logical group

	lvcreate --name share --size 40G fileserver

	lvcreate --name media --size 5G fileserver

display logical volume
	lvdisplay

scan logical volumes
	lvscan

rename

	lvrename fileserver media films


Delete lv

	lvremove /dev/fileserver/films

extend logical volumes
	lvextend -L40.5G /dev/fileserver/share

shrink the volume
	lvreduce -L40G /dev/fileserver/share


Step 5: create a file system
	mkfs.ext3 /dev/fileserver/share


Step 6: Mount the volumes
	mkdir /var/share /var/backup /var/share

Step 7: View logial volumes

df -h

Step 8: Mount when system boots:

backup fstab

	cp /etc/fstab /etc/fstab_orig
	cat /dev/null > /etc/fstab

Edit the file:

	vi /etc/fstab

add this:
	/dev/fileserver/share   /var/share     ext3       rw,noatime    0 0
	/dev/fileserver/backup    /var/backup      xfs        rw,noatime    0 0
	/dev/fileserver/media    /var/media      reiserfs   rw,noatime    0 0


Step 9: Reset system and enjoy


7) SSH from linux:

Generate your SSH key and share the public key, and add to the authorized_keys in the .ssh folder

SSH from a non standard port
	ssh -p 543 user@example.com

8) Rsync and transfer files
rsync -av --progress --rsh 'ssh -543' user@example.com:/source /var/destination 

9) Now that I have the files uploaded and everything set up, I wanted to secure the filesystem so only my user has access.

I want to remove read and write access to everyone except me, so I an the follow command:

sudo chmod -r o-rwx foldername

This changes the permisisons recurssively (all files and folders) and removes (-) Read Write and eXicute access to folder from others (so only my user and group has access)

10) Adding alias
To create an alias permanently add the alias to your .bashrc file

Now execute . ~/.bashrc in your terminal (there should be a gap between the . and ~/.bashrc.

11) LXC
LinuX Containers - lightweight virtualization isolate processes and resources

Guide:
help.ubuntu.com/community/LXC
One of the main focus for Ubuntu LTS was to make LXC dead easy to use, to achieve this. Creating a basic container and starting it on Ubuntu

	sudo apt-get install lxc

Check Kernel  configuration:
	lxc-checkconfig
Create a container
	sudo lxc-create -t ubuntu -n my-containeri
Check container:
	ls --fancy
Start container
	sudo lxc-start -n my-container
Login into container:
	sudo lxc-console -n my-container -t 1
Exit to host:
	Type ctr-A followed by Q
Note you want to change the default username and password

### LXC Web Panel

	sudo apt-get install lxc debootstrap bridge-utils -y
	sudo su
	wget http://lxc-webpanel.github.com/tools/install.sh -O - | bash

Now that you played with it via commandline and you know how, you can now 
Installing services is the same as usual



https://www.digitalocean.com/community/tutorials/getting-started-with-lxc-on-an-ubuntu-13-04-vps

### Creditials on the csclub
kinit -p

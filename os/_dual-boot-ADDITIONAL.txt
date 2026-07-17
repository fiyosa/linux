=============================================
# fix dual boot where boot windows not found

vim /etc/default/grub
GRUB_DISABLE_OS_PROBER=false  # uncomment then exit
os-prober
pacman -S fuse3 # if os-prober not detected boot windows, retry os-prober
grub-mkconfig -o /boot/grub/grub.cfg

# optional 
vim /etc/default/grub
GRUB_DEFAULT=2 # boot priority to windows
GRUB_TIMEOUT=10

=============================================
# (MBR) remove dual boot, just windows!

1) delete partition
2) delete grub

# mbr (bios)
# delete partition linux on disk management # "REQUIRED"
# open cmd (admin)
bootsect /nt60 C: /mbr  # bootsect /nt60 <drive name> /mbr

# check (REQUIRED)
diskpart
list disk
select disk X # change 'X' with disk boot
list partition

# lakukan di setiap partisi cuma hanya boleh windows saja yg "Active: Yes"
select partition X # change 'X' with partition windows
detail partition

# Example from "detail partition"
----------------------↓ Start ↓----------------------

DISKPART> detail partition

Partition 1
Type  : 07
Hidden: No
Active: Yes
Offset in Bytes: 1048576

  Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
  ----------  ---  -----------  -----  ----------  -------  ---------  --------
* Volume 4     C   windows ssd  NTFS   Partition    238 GB  Healthy    System

----------------------↑ End ↑----------------------

----------------------↓ Start ↓----------------------
# OPTIONAL

# jika ada lebih "Active: Yes" dan bukan dari parition windows
select partition 2  (Pilih partisi non-Windows yang Active)
inactive           (Matikan status Active)
# try again check detail partition
----------------------↑ End ↑----------------------

# last check (REQUIRED)
dir C:\bootmgr
dir C:\Windows\System32\winload.exe
bcdedit /enum # Pastikan hanya ada entri Windows Boot Manager. 
bcdedit /v # Pastikan hanya ada entri Windows Boot Manager. 

=============================================
# (GPT) remove dual boot, just windows!

1) delete partition
2) delete grub

# gpt (UEFI)
# delete partition linux on disk management # "REQUIRED"
# open cmd (admin)
diskpart
list disk
sel disk X # change X with where drive boot
list vol # see all partition (volumes) on disk
sel vol X # change X with EFI volume (FAT32)
assign letter=Z:
exit
Z:
dir
cd EFI
ls
rmdir /S ubuntu # change 'ubuntu' with os that you want to delete
# type "y" if confirm delete
remove letter=Z

# last action
bcdedit /enum firmware
bcdedit /delete {identifier} # ganti "{identifier}" dan cari entri "Arch Linux" atau "GRUB", lalu hapus

# last check (REQUIRED)
bcdedit /enum # Pastikan hanya ada entri Windows Boot Manager.

=============================================
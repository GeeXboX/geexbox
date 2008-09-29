#!/bin/sh

# Enable debug log based on linuxrc's DEBUG variable.
if [ $DEBUG = "yes" ]; then
  LOGFILE=/tmp/install.log
else
  LOGFILE=/dev/null
fi

# Acts just like echo cmd, with automatic redirection
dbglg () {
  echo "$@" >> $LOGFILE
}

# Detect whether partition ($1) mounted at ($2) with type ($3) is microsoft.
detect_os_microsoft () {
  local LONGNAME

  if [ "$3" != ntfs -a "$3" != vfat -a "$3" != msdos ]; then
    return
  fi

  if [ -e "$2/ntldr" -a -e "$2/NTDETECT.COM" ]; then
    LONGNAME="Windows NT/2000/XP/Vista"
  elif [ -e "$2/windows/win.com" ]; then
    LONGNAME="Windows 95/98/Me"
  elif [ -d "$2/dos" ]; then
    LONGNAME="MS-DOS 5.x/6.x/Win3.1"
  else
    return
  fi

  echo "$1:$LONGNAME:chain"
}

detect_os () {
  local PARTNAME PARTITION TYPE MPOINT

  mkdir -p tmpmnt

  for PARTNAME in `sed -n "s/\ *[0-9][0-9]*\ *[0-9][0-9]*\ *[0-9][0-9][0-9]*\ \([a-z]*[0-9][0-9]*\)/\1/p" /proc/partitions`; do
    PARTITION="/dev/$PARTNAME"

    if ! grep -q "^$PARTITION " /proc/mounts; then
      if mount -o ro $PARTITION tmpmnt >/dev/null 2>&1; then
        TYPE=$(grep "^$PARTITION " /proc/mounts | cut -d " " -f 3)
        detect_os_microsoft $PARTITION tmpmnt $TYPE

        umount tmpmnt >/dev/null || return
      fi
    else
      MPOINT=$(grep "^$PARTITION " /proc/mounts | cut -d " " -f 2)
      TYPE=$(grep "^$PARTITION " /proc/mounts | cut -d " " -f 3)

      detect_os_microsoft $PARTITION $MPOINT $TYPE
    fi
  done

  rmdir tmpmnt
}

# Usage: convert os_device
# Convert an OS device to the corresponding GRUB drive.
# This part is OS-specific.
# -- taken from `grub-install`
# $1 is DEV
# $2 is DEVICE_MAP
convert () {
  local TMP_DRIVE TMP_DISK TMP_PART

  if test ! -e "$1"; then
    echo "$1: $MSG_DEV_NO_BLOCK" 1>&2
    exit 1
  fi

  TMP_DISK=`echo "$1" | sed -e 's%\([sh]d[a-z]\)[0-9]*$%\1%'`
  TMP_PART=`echo "$1" | sed -e 's%.*/[sh]d[a-z]\([0-9]*\)$%\1%'`

  TMP_DRIVE=`grep -v '^#' $2 | grep "$TMP_DISK *$" \
			| sed 's%.*\(([hf]d[0-9][a-g0-9,]*)\).*%\1%'`

  if [ -z "$TMP_DRIVE" ]; then
    echo "$1 $MSG_BIOS_NO_DRIVE" 1>&2
    exit 1
  fi

  if [ -n "$TMP_PART" ]; then
    # If a partition is specified, we need to translate it into the
    # GRUB's syntax.
    echo "$TMP_DRIVE" | sed "s%)$%,$(($TMP_PART-1)))%"
  else
    # If no partition is specified, just print the drive name.
    echo "$TMP_DRIVE"
  fi
}

# Create grub.conf file helper functions

# Replace original value ($2) with new value ($3) in GRUB config file ($1)
update_grub_conf_bootargs () {
  # don't try to set an item with a non-existing value
  test -z "$3" && return;
  sed -i "s/$2=[^ ]*/$2=$3/g" "$1"
}

# Use the replacement values ($2-$5) in GRUB config file ($1)
append_grub_conf () {
  local TMP_GRUB_CONF=/tmp/grub.conf
  cp /etc/grub/grub.conf $TMP_GRUB_CONF

  sed -i "s/_TITLE_/$2/" $TMP_GRUB_CONF
  sed -i "s/_HDTV_/$3/" $TMP_GRUB_CONF
  sed -i "s/_DEBUG_/$4/" $TMP_GRUB_CONF
  sed -i "s/_CONFIG_/$5/" $TMP_GRUB_CONF

  cat $TMP_GRUB_CONF >> $1
  echo "" >> $1
}

# Setup of GRUB config file using initial base config file ($1) and the
# boot device UUID ($2) and boot device GRUB descriptor (ROOTDEV as $3)
# with additional entries for Xorg if appropriate (USE_XORG as $4)
setup_grub () {
  # conditional HDTV menu entry if X.org is found
  if [ "$4" = yes ]; then
    append_grub_conf $1 "GeeXboX HDTV" hdtv "" ""
    append_grub_conf $1 "GeeXboX HDTV (debug)" hdtv debugging ""
    append_grub_conf $1 "GeeXboX HDTV (reconfigure)" hdtv "" configure
  fi

  # add console mode menu
  append_grub_conf $1 "GeeXboX" "" "" ""
  append_grub_conf $1 "GeeXboX (debug)" "" debugging ""
  append_grub_conf $1 "GeeXboX (reconfigure)" "" "" configure

  # put default options
  update_grub_conf_bootargs $1 lang `cmdline_default lang en`
  update_grub_conf_bootargs $1 remote `cmdline_default remote atiusb`
  update_grub_conf_bootargs $1 receiver `cmdline_default receiver atiusb`
  update_grub_conf_bootargs $1 keymap `cmdline_default keymap qwerty`

  # now setup installation specific options
  sed -i "s/_ROOTDEV_/$3/g" $1
  sed -i "s/_DEVNAME_/UUID=${2}/g" $1
}

# Returns the value to use for a given variable ($1) as was found
# in the boot arguments, otherwise returns a default value ($2)
cmdline_default () {
  local RET=`sed -n "s/.*$1=\([^ ]*\).*/\1/p" /proc/cmdline`
  test -z $RET && RET=$2
  echo $RET
}

# Select language definitions
setup_lang () {
  LANG=`cmdline_default lang en`
  . /etc/installator/en.install # default language file, always present
  [ -f /etc/installator/${LANG}.install ] && . /etc/installator/${LANG}.install
}

# Select keymap: Prompts users for available keymaps, and loads the selected one
setup_keymap () {
  local i 
  local KEYMAP_OLD=`cmdline_default keymap qwerty`
  local KEYMAPS="qwerty qwerty"
  for i in `ls /etc/keymaps`; do
    KEYMAPS="$KEYMAPS $i $i"
  done

  KEYMAP=`dialog --no-cancel --stdout \
    --backtitle "$BACKTITLE : $MSG_KEYMAP_CONFIG" --title "$MSG_KEYMAP" \
    --default-item $KEYMAP_OLD --menu "$MSG_KEYMAP_DESC" 0 0 0 $KEYMAPS ` \
    || exit 1

  test -f "/etc/keymaps/$KEYMAP" && loadkmap < "/etc/keymaps/$KEYMAP"
}

# Offer a list of possible disks on which to install to the user,
# and return with the selected disk name
choose_disk () {
  local DISK_LIST SELECTED_DISK SIZE VENDOR MODEL DISKNAME i
  while true; do
    DISK_LIST=""
    for i in `cat /proc/partitions | sed -n "s/\ *[0-9][0-9]*\ *[0-9][0-9]*\ *[0-9][0-9]*\ \([a-z]*\)$/\1/p"`; do
      SIZE=`sfdisk -s /dev/$i | sed 's/\([0-9]*\)[0-9]\{3\}/\1/'`
      VENDOR=`[ -f /sys/block/$i/device/vendor ] \
              && cat /sys/block/$i/device/vendor`
      MODEL=`[ -f /sys/block/$i/device/model ] \
             && cat /sys/block/$i/device/model`
      DISKNAME=`echo $VENDOR $MODEL ${SIZE}MB | sed 's/ /_/g'`
      DISK_LIST="$DISK_LIST $i $DISKNAME"
    done

    if [ -z "$DISK_LIST" ]; then
      dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
        --yesno "\n${MSG_DISK_NOT_FOUND}" 0 0 1>&2 || exit 1
    else
      DISK_LIST="$DISK_LIST $MSG_DISK_REFRESH"
      SELECTED_DISK=`dialog --stdout --backtitle "$BACKTITLE" \
                       --title "$MSG_DISK_DEVICE" \
                       --menu "\n${MSG_DISK_DEVICE_DESC}" 0 0 0 $DISK_LIST ` \
                       || exit 1
      [ $SELECTED_DISK != refresh ] && break
    fi
  done
  dbglg "choose_disk() returned \"$SELECTED_DISK\""
  echo $SELECTED_DISK
}

# Prompt and get the desired partition name from the selected disk ($1),
# and returns the device name of that partition
choose_partition_dev () {
  local DEV_SEL DEV_LIST SIZE VENDOR MODEL DEVNAME i
  dbglg "Input arg for DISK is $1"
  while [ ! -b "$DEV_SEL" ]; do
    DEV_LIST=""
    for i in `sfdisk -lq /dev/$1 2>/dev/null | grep ${1%disc} | \
              cut -f1 -d' ' | grep dev`; do
      case `sfdisk --print-id ${i%%[0-9]*} ${i#${i%%[0-9]*}}` in
        1|11|6|e|16|1e|b|c|1b|1c) #FAT12/16/32 are supported syslinux
          if [ $BOOTLOADER = syslinux ]; then
            SIZE=`sfdisk -s "$i" | sed 's/\([0-9]*\)[0-9]\{3\}/\1/'`
            VENDOR=`cat /sys/block/$1/device/vendor`
            MODEL=`cat /sys/block/$1/device/model`
            DEVNAME=`echo $VENDOR $MODEL ${SIZE}MB | sed 's/ /_/g'`
            DEV_LIST="$DEV_LIST $i $DEVNAME"
          fi
          ;;
        83) #Linux is supported only in grub.
          if [ $BOOTLOADER = grub ]; then
            SIZE=`sfdisk -s "$i" | sed 's/\([0-9]*\)[0-9]\{3\}/\1/'`
            VENDOR=`cat /sys/block/$1/device/vendor`
            MODEL=`cat /sys/block/$1/device/model`
            DEVNAME=`echo $VENDOR $MODEL ${SIZE}MB | sed 's/ /_/g'`
            DEV_LIST="$DEV_LIST $i $DEVNAME"
          fi
          ;;
      esac
    done
    if [ -z "$DEV_LIST" ]; then
      dbglg "DEV_LIST var empty!"
      dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
        --msgbox "\n$MSG_INSTALL_DEV_NOPART_BEGIN $PART_MSG $MSG_INSTALL_DEV_NOPART_END\n" 0 0 1>&2
      exit 1
    else
      DEV_SEL=`dialog --stdout --aspect 15 --backtitle "$BACKTITLE" \
        --title "$MSG_INSTALL_DEV_CONFIG" --menu "$MSG_INSTALL_DEV_DESC" \
        0 0 0 $DEV_LIST ` \
        || exit 1
    fi
    if [ ! -b "$DEV_SEL" ]; then
      dbglg "DEV_SEL $DEV_SEL is not a block device!"
      dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
        --msgbox "\n'$DEV_SEL' $MSG_INSTALL_DEV_BAD_BLOCK\n" 0 0 1>&2 \
        || exit 1
    fi
  done
  dbglg "choose_dev() returned \"$DEV_SEL\""
  echo "$DEV_SEL"
}

# Runs configurator on device to configure ($1)
configure () {
  local IDISK=/mnt/install_disk
  mkdir -p $IDISK
  mount $1 $IDISK
  configurator
  umount $IDISK
}

# Try to guess current partition fs type of dev ($1).
guess_partition_type () {
  local type FS_TYPE=""
  for type in vfat ext3 ext2 auto; do
    if mount -o ro -t $type "$1" di 2>/dev/null; then
      FS_TYPE=`grep "^$1 " /proc/mounts | cut -d " " -f 3`
      umount di
      break
    fi
  done
  dbglg "guess_partition_type() returned \"$FS_TYPE\""
  echo $FS_TYPE
}

# Decides if a format is needed (or desired) and manages the process
# $1 is global MKFS_TYPE, and also updates MKFS_TYPE variable
# $2 is DEV
# $? is the list of SUPPORTED_TYPES
format_if_needed () {
  local NEED_FORMAT=yes
  local FORMAT_DEFAULT="--defaultno"
  local LOC_MKFS_TYPE="$1"
  local LOC_DEV="$2"
  local FORMAT_MSG FORMAT_DEFAULT FORMAT MKFS MKFS_OPT MKFS_TYPENAME FORMAT
  shift 2
  local LOC_SUPPORTED_TYPES="$@"

  dbglg "LOC_MKFS_TYPE \"$LOC_FS_TYPE\" LOC_DEV \"$LOC_DEV\""
  dbglg "LOC_SUPPORTED_TYPES \"$LOC_SUPPORTED_TYPES\""
  if [ -z "$LOC_MKFS_TYPE" ]; then
    FORMAT_MSG="$MSG_INSTALL_DEV_NO_FORMAT"
    FORMAT_DEFAULT=""
  else
    for type in $LOC_SUPPORTED_TYPES; do
      [ $type = $LOC_MKFS_TYPE ] && NEED_FORMAT=no
    done

    if [ "$NEED_FORMAT" = yes ]; then
      FORMAT_MSG="$MSG_INSTALL_DEV_FORMAT_BEGIN ($LOC_MKFS_TYPE) $MSG_INSTALL_DEV_FORMAT_END ($PART_TYPE)."
    else
      FORMAT_MSG="$MSG_INSTALL_DEV_FORMATED"
    fi
  fi

  dialog --aspect 15 --backtitle "$BACKTITLE" \
    --title "$MSG_INSTALL_DEV_FORMAT" $FORMAT_DEFAULT \
    --yesno "${FORMAT_MSG}\n${MSG_INSTALL_DEV_FORMAT_DESC} '$LOC_DEV' ?\n" \
    0 0 1>&2 \
    && FORMAT=yes

  if [ "$FORMAT" = yes ]; then
    case `sfdisk --print-id ${LOC_DEV%%[0-9]*} ${LOC_DEV#${LOC_DEV%%[0-9]*}}` in
      1|11|6|e|16|1e|14) # FAT12 and FAT16
        MKFS=mkdosfs
        MKFS_OPT="-n GEEXBOX"
        LOC_MKFS_TYPE=vfat
        MKFS_TYPENAME="FAT"
        ;;
      b|c|1b|1c) # FAT32
        MKFS=mkdosfs
        MKFS_OPT="-n GEEXBOX -F 32"
        LOC_MKFS_TYPE=vfat
        MKFS_TYPENAME="FAT"
        ;;
      83) # Linux
        LOC_MKFS_TYPE=`dialog --stdout --aspect 15 --backtitle "$BACKTITLE" \
          --title "$MSG_INSTALL_PART_TYPE" --menu "$MSG_INSTALL_PART_TYPE_DESC"\
          0 0 0 ext2 "Linux ext2" ext3 "Linux ext3" ` \
          || exit 1

        case $LOC_MKFS_TYPE in
          ext2)
            MKFS=mke2fs
            MKFS_OPT="-L GEEXBOX"
            MKFS_TYPENAME="Linux ext2"
            ;;
          ext3)
            MKFS=mke2fs
            MKFS_OPT="-L GEEXBOX -j"
            MKFS_TYPENAME="Linux ext3"
            ;;
        esac
        ;;
    esac

    if [ -z "$MKFS" ]; then
      if [ "$NEED_FORMAT" = yes ]; then
        dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
          --msgbox "\n${MSG_INSTALL_DEV_NO_FORMAT} ('$LOC_DEV'). ${MSG_INSTALL_FORMAT_NO_TOOLS}\n" 0 0 1>&2
        rmdir di
        exit 1
      else
        dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_WARNING"\
          --msgbox "\n'$LOC_DEV' $MSG_INSTALL_FORMAT_BAD_TYPE $MKFS_TYPENAME. ${MSG_INSTALL_FORMAT_NO_TOOLS}. ${MSG_INSTALL_FORMAT_ALREADY}\n" 0 0 1>&2 \
          || exit 1
      fi
    else
      dbglg "$MKFS $MKFS_OPT \"$LOC_DEV\""
      $MKFS $MKFS_OPT "$LOC_DEV" >> $LOGFILE 2>&1
    fi

  elif [ "$NEED_FORMAT" = yes ]; then
    dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
      --msgbox "\n${MSG_INSTALL_DEV_NO_FORMAT} ('$LOC_DEV')\n" 0 0 1>&2
    rmdir di
    exit 1
  fi

  dbglg "format_if_needed() returned \"$LOC_MKFS_TYPE\""
  # Update the global variable
  MKFS_TYPE="$LOC_MKFS_TYPE"
}

# Get the uuid of the device given by input $1
get_uuid () {
  local DEV_REALNAME NAME LOC_DEV LOC_UUID

  # restart UDEV scan to get device UUID if
  # user just created/formatted a new disk/partition
  udevadm trigger
  udevadm settle --timeout=180

  DEV_REALNAME=`ls -l $1 | sed "s/.*-> \(.*\)/\1/"`
  for LOC_DEV in `ls /dev/storage/by-uuid/*`; do
    NAME=`ls -l "$LOC_DEV" | sed "s/.*-> \(.*\)/\1/" | sed 's%../../%%'`
    if [ "$NAME" = "$DEV_REALNAME" ]; then
      LOC_UUID="`echo $LOC_DEV | sed 's%/dev/storage/by-uuid/%%'`"
      dbglg "get_uuid() returned \"$LOC_UUID\""
      echo $LOC_UUID
      break
    fi
  done

  # ensure UDEV hasn't remounted the install partition
  umount /dev/$NAME > /dev/null 2>&1
}

# Configure if fast boot methods are to be used (only for Linux partitions)
config_fastboot () {
  local FASTBOOT="no" LOC_UNCOMPRESS_INSTALL="no"

  dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_BOOT_SLEEPLESS" \
    --defaultno --yesno "\n${MSG_BOOT_SLEEPLESS_DESC}\n" 0 0 1>&2 \
    && FASTBOOT=yes \
    || exit 1


  if [ "$FASTBOOT" = "yes" ]; then
    echo "" > "di/GEEXBOX/var/fastboot"
    dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_BOOT_LARGE_HDD" \
      --defaultno --yesno "\n${MSG_BOOT_LARGE_HDD_DESC}\n" 0 0 1>&2 \
      && LOC_UNCOMPRESS_INSTALL=yes \
      || exit 1
  fi 

  if [ "$LOC_UNCOMPRESS_INSTALL" = "yes" -a -f "$GEEXBOX/bin.tar.lzma" ]; then
    rm di/GEEXBOX/bin.tar.lzma
    tar xaf "$GEEXBOX/bin.tar.lzma" -C di/GEEXBOX >> $LOGFILE 2>&1
  fi
  dbglg "config_fastboot returned \"$LOC_UNCOMPRESS_INSTALL\""
  echo "$LOC_UNCOMPRESS_INSTALL"
}

# Setup syslinux.cfg file in the /tmp dir
# $1 is the UUID of device
# $2 is GEEXBOX dir
setup_syslinux () {
  # Setup syslinux.cfg file
  sed -e "s/boot=cdrom/boot=UUID=${1}/" -e "s%^#CFG#%%" \
    "$2/boot/isolinux.cfg" > /tmp/syslinux.cfg

  dbglg "*** Start Syslinux.cfg ***"
  cat /tmp/syslinux.cfg >> $LOGFILE
  dbglg "*** End Syslinux.cfg ***"
}

# Installs syslinux- takes parameters:
# $1 is the UUID of device
# $2 is the DEV
# $3 is the DISK
# $4 is GEEXBOX dir
# $5 is the FSTYPE
# $6 is the boot type, USB-FDD or USB-HDD
install_syslinux () {

  # Setup syslinux.cfg file
  setup_syslinux "$1" "$4"

  # Copy files across and setup file hierarchy
  cp -R "$4" di/
  cd di/geexbox/boot
  mv vmlinuz initrd.gz vesamenu.c32 help.msg splash.png ../..
  cd ../../..
  mv di/geexbox/usr/share/ldlinux.sys di/
  cp /tmp/syslinux.cfg di/
  # Clean up unnecessary dir
  rm -fr di/geexbox/boot
  # Prepare for setting up the MBR
  cp di/geexbox/usr/share/mbr.bin /tmp/

  # Unmount prior to running syslinux
  umount di

  # Setup bootloader
  syslinux -s $2

  if [ "USB-HDD" = $6 ]; then
    # Setup MBR
    dd if=/tmp/mbr.bin of="$3" 2>&1 >> $LOGFILE
  elif [ "USB-FDD" = $6 ]; then
    # Blank the MBR
    dd if=/dev/zero of="$3" bs=512 count=1 2>&1 >> $LOGFILE
  fi

  # Remount
  mount -t $5 "$2" di 2>&1 >> $LOGFILE
}

# Installs makebootfat- takes parameters:
# $1 is the UUID of device
# $2 is the DEV
# $3 is the DISK
# $4 is GEEXBOX dir
# $5 is the FSTYPE
# $6 is the boot type, USB-FDD or USB-HDD USB-FDD-HDD
install_makebootfat () {
  # Setup syslinux.cfg file
  setup_syslinux "$1" "$4"

  # Unmount prior to running makebootdisk
  umount di

  # Copy files to disk in correct places and install boot loader
  # Use -x/-c to copy those files to the root dir of the FS instead
  # of the original boot directory
  makebootfat -o $3 -v -b "$4/usr/share/ldlinux.bss" \
    -m "$4/usr/share/mbrfat.bin" --mbrfat -Y \
    -c /tmp/syslinux.cfg \
    -x "$4/boot" \ 
    -c "$4/boot/vmlinuz" \
    -c "$4/boot/initrd.gz" \
    -c "$4/boot/vesamenu.c32" \
    -c "$4/boot/help.msg" \
    -c "$4/boot/splash.png" \
    -c "$4/usr/share/ldlinux.sys" \
    "${4%GEEXBOX}" 2>&1 >> $LOGFILE

  # Remount
  mount -t $5 "$2" di 2>&1 >> $LOGFILE
}

# Installs and configures the GRUB bootloader
# $1 is DEV_UUID
# $2 is DEV
# $3 is TYPE
# $4 is USE_XORG
install_grub (){
  local ROOTDEV
  local GRUBPREFIX=/boot/grub
  local GRUBDIR=di$GRUBPREFIX
  local DEVICE_MAP=$GRUBDIR/device.map
  local SPLASHIMAGE="$GRUBPREFIX/grub-splash.xpm.gz"
  local LOC_DEV_UUID=$1
  local LOC_DEV=$2
  local LOC_TYPE=$3
  local LOC_USE_XORG=$4

  rm -rf $GRUBDIR
  mkdir -p $GRUBDIR

  [ -f "di/GEEXBOX/usr/share/grub-i386-pc.tar.lzma" ] \
    && tar xaf "di/GEEXBOX/usr/share/grub-i386-pc.tar.lzma" -C $GRUBDIR \
    >> $LOGFILE 2>&1

  if [ -f "di/GEEXBOX/usr/share/grub-splash.xpm.gz" ]; then
    DISABLE_SPLASHIMAGE=
    cp -f "di/GEEXBOX/usr/share/grub-splash.xpm.gz" $GRUBDIR \
      || DISABLE_SPLASHIMAGE="#"
  else
    DISABLE_SPLASHIMAGE="#"
  fi

  cp $GRUBDIR/stage2 $GRUBDIR/stage2_single

  if [ $LOC_TYPE = HDD ]; then
    echo "quit" | grub --batch --no-floppy --device-map=$DEVICE_MAP \
      >> $LOGFILE 2>&1
    ROOTDEV=$(convert $LOC_DEV $DEVICE_MAP)
  elif [ $LOC_TYPE = REMOVABLE ]; then
    exit 1
  fi


  dbglg "ROOTDEV \"$ROOTDEV\" DEV_UUID \"$LOC_DEV_UUID\" DEV \"$LOC_DEV\""
  dbglg "TYPE \"$LOC_TYPE\" XORG \"$LOC_USE_XORG\""

  if [ -z "$ROOTDEV" ]; then
    dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
      --msgbox "\n${MSG_GRUB_NO_ROOTDEV}\n" 0 0 1>&2
    umount di
    rmdir di
    exit 1
  fi

  dbglg "GRUB setup is: grub --batch --no-floppy --device-map=$DEVICE_MAP"
  dbglg "root $ROOTDEV"
  dbglg "install --stage2=$GRUBDIR/stage2_single $GRUBPREFIX/stage1 $ROOTDEV" \ 
    "$GRUBPREFIX/stage2_single p $GRUBPREFIX/single.lst"

  grub --batch --no-floppy --device-map=$DEVICE_MAP <<EOF
root $ROOTDEV
install --stage2=$GRUBDIR/stage2_single $GRUBPREFIX/stage1 $ROOTDEV $GRUBPREFIX/stage2_single p $GRUBPREFIX/single.lst
EOF

  cat > $GRUBDIR/single.lst <<EOF
default  0
timeout  2
color cyan/blue white/blue
${DISABLE_SPLASHIMAGE}splashimage=$ROOTDEV$SPLASHIMAGE
EOF

  setup_grub $GRUBDIR/single.lst $LOC_DEV_UUID $ROOTDEV $LOC_USE_XORG

  dbglg "*** Start GRUB Single.lst ***"
  cat $GRUBDIR/single.lst >> $LOGFILE
  dbglg "*** End GRUB Single.lst ***"

  if [ $LOC_TYPE = HDD ]; then
    oslist=$(detect_os)

    supported_os_list=""
    saveifs=$IFS
    IFS='
'
    for os in $oslist; do
      title=$(echo "$os" | cut -d: -f2)
      if [ -n "$supported_os_list" ]; then
        supported_os_list="$supported_os_list, $title"
      else
        supported_os_list="$title"
      fi
    done
    IFS=$saveifs

    if [ -n "$supported_os_list" ]; then
      dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_BOOTLOADER" \
        --defaultno --yesno "\n'$LOC_DEV' $MSG_LOADER_MULTIBOOT_BEGIN $supported_os_list\n${MSG_LOADER_MULTIBOOT_END}\n" 0 0 1>&2 \
        && MBR=yes
    else
      dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_BOOTLOADER" \
        --yesno "\n'$LOC_DEV' ${MSG_LOADER_NONE}\n" 0 0 1>&2 \
        && MBR=yes
    fi
  fi

  if [ "$MBR" = "yes" ]; then

    dbglg "grub --batch --no-floppy --device-map=$DEVICE_MAP"
    dbglg "root $ROOTDEV"
    dbglg "setup --stage2=$GRUBDIR/stage2 --prefix=$GRUBPREFIX (hd0)"

    grub --batch --no-floppy --device-map=$DEVICE_MAP <<EOF
root $ROOTDEV
setup --stage2=$GRUBDIR/stage2 --prefix=$GRUBPREFIX (hd0)
EOF

    cat > $GRUBDIR/menu.lst <<EOF
default  0
timeout  5
color cyan/blue white/blue
${DISABLE_SPLASHIMAGE}splashimage=$ROOTDEV$SPLASHIMAGE
EOF

    saveifs=$IFS
    IFS='
'
    for os in $oslist; do
      partition=$(echo "$os" | cut -d: -f1)
      grubpartition=$(convert $partition $DEVICE_MAP)

      [ -z "$grubpartition" ] && continue

      grubdisk=${grubpartition%,*}
      grubdisk="(${grubdisk#(})"
      title=$(echo "$os" | cut -d: -f2)
      type=$(echo "$os" | cut -d: -f3)

      if [ "$type" = chain ]; then
        cat >> $GRUBDIR/menu.lst <<EOF
title	$title
EOF
        if [ $grubdisk != "(hd0)" ]; then
          cat >> $GRUBDIR/menu.lst <<EOF
map (hd0) $grubdisk
map $grubdisk (hd0)
EOF
        fi

        cat >> $GRUBDIR/menu.lst <<EOF
rootnoverify $grubpartition
makeactive
chainloader +1
boot
EOF
      fi
    done
    IFS=$saveifs

    setup_grub $GRUBDIR/menu.lst $LOC_DEV_UUID $ROOTDEV $LOC_USE_XORG

    dbglg "*** Start GRUB menu.lst ***"
    cat $GRUBDIR/menu.lst >> $LOGFILE
    dbglg "*** End GRUB menu.lst ***"
  else
    dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_BOOTLOADER" \
      --msgbox "\n${MSG_LOADER_ERROR}\n" 0 0 1>&2
  fi
}

VERSION=`cat VERSION`
BACKTITLE="GeeXboX $VERSION installator"

setup_lang

# disable kernel messages to avoid screen corruption
echo 0 > /proc/sys/kernel/printk

setup_keymap

DISK="`choose_disk`"

# Exit with error if no disk selected
[ -z "$DISK" ] && exit 1

if [ "`cat /sys/block/$DISK/removable`" = 1 ]; then
  TYPE=REMOVABLE
  BOOTLOADER=syslinux
  PART_MSG="$MSG_DISK_PART_FAT"
else
  TYPE=HDD
  BOOTLOADER=grub
  PART_MSG="$MSG_DISK_PART_EXT"
fi

dbglg "TYPE $TYPE BOOTLOADER $BOOTLOADER"

CFDISK_MSG="$MSG_CFDISK_BEGIN $PART_MSG $MSG_CFDISK_END"

# Guide user on how to setup with cfdisk tool in the next step
dialog --stdout --backtitle "$BACKTITLE" --title "$MSG_INSTALL_DEV_CONFIG" \
  --msgbox "$CFDISK_MSG" 0 0 \
  || exit 1

# Make sure disk partitions are not already mounted before running cfdisk
umount /dev/${DISK}* 2>/dev/null
cfdisk /dev/$DISK

DEV="`choose_partition_dev $DISK`"

# Exit with error if no partition selected
[ -z "$DEV" ] && exit 1

# Set valid FS types based on selected install partition
case `sfdisk --print-id ${DEV%%[0-9]*} ${DEV#${DEV%%[0-9]*}}` in
  1|11|6|e|16|1e|14|b|c|1b|1c)
    SUPPORTED_TYPES="vfat"
    PART_TYPE="FAT"
    ;;
  83) # Linux
    SUPPORTED_TYPES="ext3 ext2"
    PART_TYPE="Linux"
    ;;
esac

dbglg "SUPPORTED_TYPES $SUPPORTED_TYPES PART_TYPE $PART_TYPE"

# Create directory for the selected partition to be mounted
mkdir di

MKFS_TYPE="`guess_partition_type $DEV`"

format_if_needed "$MKFS_TYPE" "$DEV" "$SUPPORTED_TYPES"

DEV_UUID=`get_uuid $DEV`

# Attempt to mount the prepared partition using the given partition fs type
dbglg "mount -t $MKFS_TYPE $DEV di"
mount -t $MKFS_TYPE "$DEV" di
ret=$?
if [ $ret -ne 0 ]; then
  # FS is not mountable! Return an error msg and exit
  dbglg "mount returned $ret"
  dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_DISK_ERROR" \
    --msgbox "\n${MSG_INSTALL_MOUNT_FAILED} '$DEV' ($MKFS_TYPENAME).\n" 0 0
  rmdir di
  exit 1
fi

if [ -n "$NET" ]; then
  GEEXBOX="$NET"
else
  GEEXBOX="$CDROM/GEEXBOX"
fi

# Cleanup if was left in a messy state previously- remove previous installs
rm -rf di/GEEXBOX 2>&1 >> $LOGFILE

# Configure X.Org
if [ -f /etc/X11/X.cfg.sample -o -f /etc/X11/X.cfg ]; then
  USE_XORG=yes # default is to use X if present
  dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_CFG_HDTV" \
    --yesno "\n${MSG_CFG_HDTV_DESC}\n" 0 0 \
    || USE_XORG=no
else
  USE_XORG=no
fi

# Install bootloader and copy files across
if [ $BOOTLOADER = syslinux ]; then

  if [ $BTYPE = "USB-FDD" -o $BTYPE = "USB-HDD" ]; then
    # install_syslinux copies all files across
    install_syslinux "$DEV_UUID" "$DEV" "$DISK" "$GEEXBOX" "$MKFS_TYPE" "$BTYPE"
  else
    install_makebootfat "$DEV_UUID" "$DEV" "$DISK" "$GEEXBOX" "$MKFS_TYPE"
  fi

elif [ $BOOTLOADER = grub ]; then

  # Copy the main files to the install partition
  cp -a "$GEEXBOX" di/GEEXBOX >> $LOGFILE 2>&1 

  # Adjust the location of core boot files to suit non-CDROM install
  mv di/GEEXBOX/boot/vmlinuz di/GEEXBOX/boot/initrd.gz di/

  # Fast booting methods only for Linux partitions currently (symlink issues)
  UNCOMPRESS_INSTALL="`config_fastboot`"

  install_grub "$DEV_UUID" "$DEV" "$TYPE" "$USE_XORG"

  rm -rf di/GEEXBOX/boot

fi

if [ "$USE_XORG" = yes ]; then
  [ "$UNCOMPRESS_INSTALL" = "yes" -a -f "$GEEXBOX/X.tar.lzma" ] \
    && rm di/GEEXBOX/X.tar.lzma && tar xaf "$GEEXBOX/X.tar.lzma" -C di/GEEXBOX
else
  # Since X is disabled, remove the files from HDD install to speed up boot
  rm -f di/GEEXBOX/X.tar.lzma
fi

# Cleanup
umount di
rmdir di

# Eject CD if it was the boot media
[ -n "$CDROM" ] && eject -s &

# Prompt to view logging file if in debugging mode
[ $DEBUG = "yes" ] && dialog --aspect 15 --backtitle "$BACKTITLE" 
                             --title "$MSG_LOG" --defaultno \
                             --yesno "$MSG_LOG_DESC" 0 0 \
                             && dialog --textbox $LOGFILE 0 0

# Prompt to run the configurator to adjust the config of the new installation
dialog --aspect 15 --backtitle "$BACKTITLE" --title "$MSG_SUCCESS" \
  --yesno "\n${MSG_SUCCESS_DESC_BEGIN} '$DEV' !! ${MSG_SUCCESS_DESC_END}\n" \
  0 0 \
  && configure $DEV

# Exit cleanly
return 0

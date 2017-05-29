#!/bin/sh

#############################################################################
# Setup default XBMC settings files                                         #
# See http://wiki.kodi.org/index.php?title=Advancedsettings.xml for details #
#############################################################################

USERDATA="/root/.kodi/userdata"
ADV_SETTINGS="$USERDATA/advancedsettings.xml"
GUI_SETTINGS="$USERDATA/guisettings.xml"
CORE_FACTORY="$USERDATA/playercorefactory.xml"
SOURCES="$USERDATA/sources.xml"
KEY_MAP="$USERDATA/Lircmap.xml"
SYS_PREFIX=""

set_system_prefix () {
  [ ! -z $SYS_PREFIX ] && return

  if   grep -q "OMAP4 Panda board" /proc/cpuinfo; then SYS_PREFIX="panda"
  elif grep -q "Snowball" /proc/cpuinfo;          then SYS_PREFIX="snowball"
  elif grep -q "SolidRun CuBox" /proc/cpuinfo;    then SYS_PREFIX="cubox"
  elif grep -q "BCM2[7|8]" /proc/cpuinfo;         then SYS_PREFIX="rpi"
  elif grep -q "sun[4-7]i" /proc/cpuinfo;         then SYS_PREFIX="a10"
  elif grep -q "CM-FX6" /proc/cpuinfo;            then SYS_PREFIX="utilite"
  elif grep -q "i.MX6" /proc/cpuinfo;             then SYS_PREFIX="cuboxi"
  else                                            SYS_PREFIX="generic"     
  fi
}

copy_if_present () {
  [ -f $1 ] && cp $1 $2
}

copy_if_missing () {
  [ ! -f $2 ] && cp $1 $2
}


# create profile directory
mkdir -p "$USERDATA"

# set default advancedsettings.xml
if [ ! -f "$ADV_SETTINGS" ] ; then
  set_system_prefix
  copy_if_present /etc/kodi/$SYS_PREFIX-playercorefactory.xml $CORE_FACTORY
  copy_if_present /etc/kodi/$SYS_PREFIX-advancedsettings.xml $ADV_SETTINGS
  copy_if_missing /etc/kodi/generic-advancedsettings.xml $ADV_SETTINGS
fi

# set default guisettings.xml
if [ ! -f "$GUI_SETTINGS" ] ; then
  set_system_prefix
  copy_if_present /etc/kodi/$SYS_PREFIX-guisettings.xml $GUI_SETTINGS
  copy_if_missing /etc/kodi/generic-guisettings.xml $GUI_SETTINGS

  ZONEINFO="/usr/share/zoneinfo/"
  if [ -z "$TZ" ] && [ -h /etc/localtime ] ; then
    TZ=`readlink /etc/localtime`
    TZ=${TZ#${ZONEINFO}}
  fi
  [ -n "$TZ" ] && \
    TZ_COUNTRY_CODE=`grep $TZ ${ZONEINFO}zone.tab | cut -f1 | head -1`
  [ -n "$TZ_COUNTRY_CODE" ] && \
    TZ_COUNTRY=`grep $TZ_COUNTRY_CODE ${ZONEINFO}iso3166.tab | cut -f2 | head -1`

  GUI_LIMIT="1080"
  if [ "$SYS_PREFIX" = "rpi" ] ; then
    MEMSIZE=`vcgencmd get_mem gpu | grep -o "[0-9]*"`
    [ $MEMSIZE -le 256 ] && GUI_LIMIT="720"
  fi
    
  sed -i $GUI_SETTINGS \
      -e "s,GUI_LIMIT,$GUI_LIMIT," \
      -e "s,TZ_COUNTRY,$TZ_COUNTRY," -e "s,TZ,$TZ,"
fi

# set default sources.xml
if [ ! -f "$SOURCES" ] ; then
  copy_if_present /etc/kodi/sources.xml $SOURCES
fi

# set default remote control key map
if [ ! -f "$KEY_MAP" ] ; then
  copy_if_present /usr/share/kodi/system/Lircmap.xml $KEY_MAP
fi

exit 0

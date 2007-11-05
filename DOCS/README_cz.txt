
         ooooo                     oo     o  o               oo     o
        M"   "Mo                    Mo  oM"  M                Mo  oM"
       M           oM""Mo  oM""Mo    "Mo"    Mo"""o  oM""Mo    "Mo"
       M    """M   MooooMM MooooMM   oMMo    M    "M M    M    oMMo
       "o     oM   M    o  M    o   oM  Mo   M    oM M    M   oM  Mo
        "MoooM"M   "MooM"  "MooM"  M"    "M  M"ooo"  "MooM"  M"    "M



| O produktu
| ~~~~~
GeeXboX je druh "divx box" softwaru. Jedn� se o bootovac� CD umo��uj�c�
sledov�n� film� nebo poslouch�n� hudby. Podporuje celou �adu form�t� jako
avi, mpeg, divx, ogm, rm, mp3, ogg, dvd, vcd , cdda. Obsahuje tak� podporu
IR d�lkov�ch ovlada�� a TV v�stup na ur�it�ch typech grafick�ch karet.
Tato distribuce obsahuje n�stroje pot�ebn� k  vytvo�en� vlastn�ho GeexboX iso souboru.



GeeXboX is a kind of "divx box" software. In fact, it is a stand-alone boot
CD which allows you to watch movies or listen to music. It supports many
formats, such as avi, mpeg, divx, ogm, rm, mp3, ogg, dvd, vcd and cdda.
It also supports some IR remote controllers and TV-Out for some graphic cards.
This archive contain the needed scripts to rebuild an iso image of the GeeXboX.


| Po�adavky na syst�m
| ~~~~~~~~~~~~
Pro vytvo�en� GeeXboX iso souboru pot�ebujete jedno z n�sleduj�c�ch:
  - GNU/Linux syst�m s  mkisofs a mkzftree.
  - MAC OS X syst�m s  mkisofs a mkzftree.
  - MS Windows syst�m.

K instalaci GeeXboX pot�ebujete:
  - GNU/Linux syst�m s syslinux.

Pro vytvo�en� GeeXboXu jsou zapot�eb� n�sleduj�c� standardn� n�stroje:
  - funk�n� GNU/Linux syst�m.
  - gcc C compiler.
  - GNU make
  - patch command.
  - nasm assembler.
  - bzip2 a gzip.
  - mkfs.ext2 a mkfs.vfat
  - wget download tool (nen� zapot�eb� pokud m�te plnou verzi GeeXboX bal��ku).
  - mkisofs a mkzftree pro vytvo�en� iso souboru.
  - mkzftree pro komprimaci soubor� v  iso souboru.
  - cdrecord (pro vyp�len� iso souboru).

A tak� p�ibli�n� 500 MB voln�ho diskov�ho prosoru.


| Vlastn� nastaven�
| ~~~~~~~~~~~~~~~

Pokud je GeeXboX nainstalov�n na pevn� disk nebo generov�n
je velice jednoduch� vytvo�it osobn� nastaven�.


M��ete p�idat dal�� kodeky jako nap��klad rv9 nebo wmv9 pouh�m nakop�rov�n�m
do adres��e GEEXBOX/codecs. Tyto kodeky m��ete nal�zt v bal��c�ch na
http://www.geexbox.org/releases/geexbox-extra-codecs-nonfree.tar.gz

D�le upravit velk� mno�stv� nastaven� editac� textov�ch konfigura�n�ch  soubor�.


* Jazyky:
    M��ete zvolit preferovan� jazyk nab�dky n�sleduj�c�mi zp�soby:


    - u�ivatel� GNU/Linux:
    P�ed spu�t�n�m editujte ��dek "MENU_LANG=en" skriptu generator.sh
    na v� preferovan� jazyk nap� "MENU_LANG=cz"


    - U�ivatel� Microsoft Windows :
    P�i spu�t�n� gener�toru vyberte v rozbalovac� nab�dce po�adovan� jazyk.


    Pozn�mka : Toto nem� vliv na volbu jazyka v DVD (v�ce v sekci o MPlayeru ).

    Pro seznam podporovan�ch jazyk� nahl�dn�te do adres��e "language".
    Pokud nen� V� jazyk v nab�dce m��ete jej vytvo�it p�elo�en�m ji� existuj�c�ch soubor� menu
    language/menu_LANG.conf a language/help_LANG.txt,
    a p�id�n�m LANG do language/lang.conf.

* MPlayer :
    Zde m��ete prov�d�t nejv�ce nastaven� a customizac�.
    Nastaven� se prov�d�j� pomoc� souboru packages/MPlayer/mplayer.conf.
    Pravd�podobn� budete cht�t zm�nit hodnoty jako nap�. velikost OSD fontu.
    M��ete p�idat dal�� parametry jako nap�. v�choz� jazyk pro DVD (eg: alang=cz,en).
    Nejlep��m m�stem pro z�sk�n� parametr� je manu�l MPlayeru.
    U�ivatel� linuxu (man -l build/MPlayer-*/DOCS/mplayer.1). M��ete tak� nahl�dnout na dokumentaci
    ( build/MPlayer-*/DOCS nebo na    http://mplayerhq.hu/DOCS/).
    Dal��m souborem kde je dobr� prov�d�t �pravy je packages/MPlayer/menu.conf.
    M��ete odebrat volby, kter� nepot�ebujete nebo jej p�elo�it do va�eho jazyka.
    Posledn�m souborem doporu�en�m k editaci je  packages/MPlayer/build kter� obsahuje
    v�b�r mo�nost� MPlayeru.

* tv v�stup :
    TV v�stu je dosa�en s pomoc� drobn�ch aplikac� ur�en�ch pro dan� typy grafick�ch karet
    V sou�asn� dob� pou��v�me  atitvout pro karty ATI, s3switch pro  karty S3  a nvtv pro karty nVidia
    (mo�n� i karty intel i810 a karty 3dfx cards). Nastaven� t�chto pomocn�ch program� je provedeno
    v config/tvout. Tam m��ete nastavi V� TV standard (pal, ntsc...) a nastavit specieln� volby pro nvtv.


    Zde m��ete tak� definovat pom�r stran  (nap�. 4:3 nebo 16:9) toho doc�l�te parametrem:

    TVOUT_ASPECT="4:3"

    Tento parametr bude pou�it pro oba (TVOut i klasick�  (CRT/TFT)) v�stupy.
    V p��pad� �e m�te nestandardn� monitor (Wide screen nebo videoprojektor) ��ete nastavit
    po�adovanou v��ku/���ku stejn� jako obnovovac� frekvenci.
    Parametry nastavujeme v souboru     /etc/mplayer/mplayer.conf .
    V�choz� hodnoty jsou uvedeny n�e (odkomentujte ��dky u frekvenc� pokud je chcete pou��t) :

    screenw=800
    screenh=600
    #monitor-hfreq=31.5k-50k
    #monitor-vfreq=50-90

* Lirc :
     M��ete vybrat jeden z podporovan�ch typ� d�lkov�ch ovlada��  editac� souboru
    GEEXBOX/etc/remote. Dbejte na spr�vn� v�b�r p�ij�mac�ho za��zen� v tomt� souboru
    Pokud chcete zb�nit p�i�azen� tla��tek Va�eho ovlada�e pod�vejte se do souboru
    GEEXBOX/etc/lirc/lircrc_REMOTE.

* S� :
    Nastaven� s�t� se prov�d� v souboru GEEXBOX/etc/network.
    Zde m��ete nastavit IP adresu pro GeeXboX (v�choz� nastaven� je pou��t DHCP
    a pohud proces sel�e, je nastavena adresa 192.168.0.54.
    Lze zde tak� nastavit u�ivatelsk� jm�no a heslo pro p��stup ke sd�len�m slo�k�m
    syst�mu windows (v�choz� nastaven� se p�ipoj� pouze k anonymn�m sd�len�m).
    Parametry pro NFS se nastavuj� v souboru GEEXBOX/etc/nfs.

* wifi :
    GeeXboX se pokus� automaticky zjistit s�ov� nastaven�.
    Pokud m�te v syst�mu klasickou NIC a WiFi kartu pouze  posledn� v �ad� bude nastavena.
    Pro p�esn� nastaven� vyhovuj�c� Va�emu prost�ed� mus�te upravit soubor  /etc/network.


    N�sleduj�c� ��dky se t�kaj� konfigurace WiFi :
    * PHY_TYPE="auto"      # Network physical type (auto|ethernet|wifi)
    * WIFI_MODE="managed"  # Wifi working mode (managed|ad-hoc)
    * WIFI_WEP=""          # Wifi WEP key
    * WIFI_ESSID="any"     # Wifi SSID

    Toto by m�lo posta�ovat pro nastaven�. M��ete zvolit autodetekci nebo dokonce zvolit pou��v�n�
    pouze WiFi nebo ethernetu.
    Stejn�m zp�sobem lze vybrat typ WiFi m�du mezi  managed a  ad-hocv�etn� nastaven� WEP kl��e a SSID.

* gateway :
    GeeXboX podporuje p��stup na s� internet. Pokud m�te na s�ti dostupn� internetov� p�ipojen�
    m��ete ho sd�let pro GeeXBox pou�it�m routeru nebo br�ny. Pro tuto mo�nost editujte IP adresu br�ny
    v souboru /etc/network file.

    * GATEWAY=""     # IP adresa br�ny ("" pro  DHCP nebo ��dn� p��stup na internet)

* nastaven� TV :
    GeeXboX umo��uje pou�it� TV tuner�. Syst�m se sna�� rozpoznat jak� televizn� tuner m�te.
    M��ete p�esko�it autodetekci veps�n�m parametr� Va�eho tuneru v  /etc/tvcard
    n�sleduj�c�m zp�sobem :

 #TV CARD/TUNER Model (AUTO pro autodetekci nebo zadejte hodnoty z n�sleduj�c�ch odkaz�)
 #http://www.linuxhq.com/kernel/v2.6/2/Documentation/video4linux/CARDLIST.bttv
 #http://www.linuxhq.com/kernel/v2.6/2/Documentation/video4linux/CARDLIST.tuner

    TV_CARD=AUTO
    TV_TUNER=AUTO
    TVIN_STANDARD=pal


    Nechte parametr AUTO pokud si p�ejete aby se syst�m pokusil rozpoznat Va�i kartu,
    nebo jej nahra�te ��slem Va�� karty v souladu z odkaz uveden�mi v��e.
    Pozor v p��pad� �e nepou�ijete parametr AUTO mus�te zn�t p�esn� typ Va�� karty!.

    Pokud m�te nastaveno m�li by jste b�t schopni p�ij�mat TV sign�ls (Composite a S-VHS)
    na va��  TV kart�. Stejn� jako sledovat televizn� vys�l�n�.
    Pro nalazen� program� muz�te zadat region a frekvenci kan�lu, kter� chcete sledovat.
    To lze prov�st v souboru  /etc/tvcard  :

    # TV programy
    # Syntaxe : CHAN="Frekvence:N�zev programu"
    # Uk�zka :
    # CHAN="29:France 2"
    # CHAN="K08:Canal +"
    # TV Channels List
    # Available : france, europe-east, europe-west, us-bcast, us-cable
    CHANLIST=france

    Jednotliv� programy by se m�li objevit v z�kladn� nab�dce.

* audio nastaven� :
    GeeXboX podporuje analogov�  i  digit�ln�  audio v�stup p�es klasick� JACK
    nebo   RCA SPDIF.  V�choz� v�stup je nastaven� analogov�. Tuto hodnotu m��ete zm�nit editac�
    souboru /etc/audio :

    # Output using SPDIF (yes/no), otherwise ANALOG output
    SPDIF=no

    Pamatujte, �e mus�te nastavit SPDIF pokud chcete zvukovou kartu p�ipojit
    k extern�mu zesilova�i pro dek�dov�n� AC3/DTS stop.


* DXR3/Hollywood+ karty :
    U�ivatel� s t�mto druhem hardware ani nemus� m�t video a zvukovou kartu k pou��v�n� GeeXboXu.
    Ve re�lu lze pou��t pouze TV out s t�mito kartami.
    Mo�n� bude zapot�eb� nastavit po�adovanou normu  (PAL/NTSC) v souboru  /etc/tvout
    fstejn� jako audio v�stup  (Analog nebo SPDIF) v  /etc/audio.

| Generov�n�
| ~~~~~~~~~~
Nejprve si pros�m p�e�t�te sekci o nastaven� viz v��e.

Potom jednodu�e vygenerujte iso soubor v Linuxu spu�t�n�m skriptu
  ./generator.sh
nebo ve windows aplikac�
  generator.exe


| Instalace
| ~~~~~~~~~~~~

K instalaci je zapot�eb� vytvo�it diskov� odd�l FAT16 s alespo� 16MB voln�ho m�sta.

Pak je mo�n� nainstalovat GeeXboX pod linuxem spu�t�n�m skriptu
  ./installator.sh
S n�sledn�m zodpov�zen�m v�ech nastavuj�c�ch dotaz�. Dbejte zv��en� opatrnosti v pr�b�hu instalace,
rad�ji p�eru�te instalaci pokud si nejste jisti co d�l�te.


| PXE Bootov�n�
| ~~~~~~~~
GeeXboX je schopn� bootovat ze s�t� na bezdiskov� stanici.
K dosa�en� tohoto stavu budete pot�ebovat:

 -  DHCP server
 -  TFTP server
 -  NFS server
 -  PXE kompatibiln� stanici :-)
Nejprve je nutn� nakonfigurovat V� DHCP server pro zas�l�n� PXE bootovac�ch informac�
Zde je uk�zka s isc dhcp:


allow booting;
allow bootp;

subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.128 192.168.0.192;
  option subnet-mask 255.255.255.0;
  option broadcast-address 192.168.0.255;
  next-server 192.168.0.1;
  filename "/tftpboot/GEEXBOX/boot/pxelinux.0";
}
Dal�� nastaven� je adresa TFTP serveru.
Nakonfigurujte TFTP server na adres�� /tftpboot a nakop�rujte v�echny GeeXboX
soubory do tohoto adres��e.
Nap��klad m��ete nakop�rovat obsah GeeXboX CD z linuxu  v m�du TRANSPARENT DECOMPRESSION !
pro ov��en� nahl�dn�te do souboru sbin/init a zkontrolujte �e je struktura norm�ln�.
Pokud jste vytvo�ili GeeXboX ze zrdrojov�ch soubor� m��ete strukturu GeeXboXu vygenerovat pomoc�
If you've built the GeeXboX yourself from sources, you can also generate
make pxe.

Pot� m��ete editovat soubor /tftpboot/GEEXBOX/boot/pxelinux.cfg/default
pro nastaven� nfsroot na spr�vnou  NFS cestu pro  GEEXBOX strukturu.

Nakonec nastavte NFS pro export GEEXBOX struktury v /etc/exports
zhruba t�mto zp�sobem :

/tftpboot/GEEXBOX (ro)

 a /etc/hosts.allow asi takhle:

ALL: ALL

To by m�lo b�t v�e nyn� m��ete zkusit nabootovat a uvid�te co se stane.


| Vytv��en� ISO
| ~~~~~~~~

Nejprve pros�m pro�t�te ��st o nastaven�.

Potom vytvo�te iso pomoc�:
  make
Nebo soubor rovnou vypalte  :
  make burn

Kdy� jste hotovi m��ete GeeXboX stukturu smazat pro �sporu m�sta na disku:

  make clean
Nebo smazat v�echny soubory a zdroje:

  make distclean

Existuje v�ce nastavuj�c�ch p��kaz� pokud se chcete v GeeXboXu troch vrtat:

  scripts/get package        # st�hnout bal��ek
  scripts/unpack package     # rozbalit a p�ipravit bal��ek
  scripts/build package      # vytvo�� bal��ek
  scripts/install package    # instalovat bal��ek s $INSTALL prefix
  scripts/clean package      # vymazat adres��ovou strukturu bal��ku

Pokud jste vytvo�ili upravenou verzi GeeXboXu m��ete vytvo�it tar.bz2 pomoc� :
  make dist
nebo pln�  tar (se v�emi zdrojov�mi soubory) pomoc� :
  make fulldist
nebo geexbox gener�tor pomoc� :
  make generator
nebo  geexbox instal�tor pomoc� :
  make installator
nebo   pxe strukturu pomoc� :
  make pxe


| Konfigurace
| ~~~~~~~~~~~~~

* Glob�ln� nastaven� :

    Je nejd�le�it�j��m krokem p�ed samotn�m vytv��en�m GeeXboXu.
    Je ulo�eno v souboru  config/options, a jeho syntaxe je srozumiteln�.
    M��ete zvolit typ Va�eho procesoru, t�ma, a zda chcete pou��vat True Type fonty nebo ne.
    Tak� m��ete upravit nastaven� Va�� vypalova�ky aby bylo mo�n� iso rovnou vyp�lit.

* Linux :
    Tohle je klasick� nastaven� Linuxu (packages/linux/linux.conf).
    Lze je editovat ru�n� nebo spustit skript scripts/unpack linux
    a pot�  make menuconfig -C build/linux-* (p��padn� pou��t V�mi preferovanou metodu nam�sto menuconfig).
    Zaz�lohujte /linux-*/.config do packages/linux/linux.conf.

* Lirc :
    Lirc umo��uje  ovl�d�n� GeeXboXu pomoc� d�lkov�ho ovlada�e. Nejprve se pokuste nal�zt
    soubor s va��m typem ovlada�e v  build/lirc-*/remotes (po proveden�  scripts/unpack lirc) a
    p�idejte jej do packages/lirc/install. Potom vyberte za��zen� (v�choz� je  /dev/ttyS0 (COM1))
    a ovlada� lirc a ulo�te jej do souboru packages/lirc/lircd_$REMOTE. Pot� zvolte nastaven� tla��tek
    v souboru packages/lirc/lircrc_$REMOTE. Pro ka�d� p�i�azen� tla��tka mus�te vybrat jeho jm�no ze souboru
    a zasociovat ho k ur�it� akci. Tou m��e b�t n�kter� z akc� MPlayeru (ty naleznete v souboru
    build/MPlayer-*/DOCS/documentation.html#commands).


| �pravy
| ~~~~~~~

Jako prvn� je dobr� pod�vat se na inicializa�n� skript.
Ve skute�nosti se jedn� o skripty dva. Prvn� je v packages/initrd/linuxrc
ale ten pravd�podobn� nebudete cht�t upravovat. Druh� je  config/init a v n�m se d�
upravit n�kolik mo�nost� nastaven�.

Dal�� co by V�s mohlo zaj�mat je vytvo�en� nov�ho bal��ku.
To nen� nic jin�ho ne� spousta skript� kter� sleduj� ur�it� pravidla.
V�echny skripty musej� b�t ve stejn�m adres��i jako je program kter� chcete "p�ibalit"

Zde je seznam skript� kter� m��ete vytvo�it :
 - url : seznam adres kde lze st�hnout zdrojov� soubory program�.
 - unpack : co se provede po rozbalen� zdroj�, ��ete nap��klad upravit konfigura�n� soubory,
            net�k� se aplikac� z�plat.
 - need_build : pou�it� pokud bal��ek ji� byl sestaven, a pro uji�t�n� �e nepot�ebuje reebuilt.
                Dojde k odstran�n� souboru .stamps/"package name"/build v p��pad� �e rebuild nen� nutn�.

 - build :   v�echny nezbytn� kroky k vytvo�en� programu.
 - install : v�echny nezbytn� kroky k instalaci  programu. Za��tek instalace by m�l b�t $INSTALL.

Kdy� je soubor z url adresy pojmenov�n z�plata-program_name-...je automaticky z�plata aplikov�na
na rozbalen� zdrojov� soubory programu.

M�li by jste pamatovat �e software na kter�m GeeXboX b�� mus� b�t zkompilov�n s
uClibc gcc wrapper.

Nakonec, nejlep�� cesta k vytvo�en� bal��ku je pod�vat s edo ji� hotov�ch.



| Licen�n� podm�nky
| ~~~~~~~

V�echny programy pou�it� v GeeXboXu jsou chr�n�ny jejich licenc�.
V�echny jsou voln� �i�iteln� a v�t�ina z nich podl�h� GNU licencov�n�.
GeeXboX jako takov�. my�leno skripty pou�it� pro jeho vytvo�en� spadaj� pod GNU.

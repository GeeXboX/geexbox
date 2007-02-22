
         ooooo                     oo     o  o               oo     o
        M"   "Mo                    Mo  oM"  M                Mo  oM"
       M           oM""Mo  oM""Mo    "Mo"    Mo"""o  oM""Mo    "Mo"
       M    """M   MooooMM MooooMM   oMMo    M    "M M    M    oMMo
       "o     oM   M    o  M    o   oM  Mo   M    oM M    M   oM  Mo
        "MoooM"M   "MooM"  "MooM"  M"    "M  M"ooo"  "MooM"  M"    "M




| AVANT PROPOS
| ~~~~~~~~~~~~

La GeeXboX est une distribution Linux de type Media Center. Il s'agit d'un CD
bootable qui vous permet de regarder des films ou d'�couter de la musique.
Il supporte de nombreux formats tels que avi, mpeg, divx, ogm, rm, mp3, ogg,
dvd, vcd et cdda. GeeXboX supporte aussi certains types de t�l�commandes
infra-rouge et les sorties TV de certaines cartes graphiques.
Cette archive contient tous les fichiers n�cessaires pour g�n�rer une image
iso personnalis�e de la GeeXboX


| PREREQUIS
| ~~~~~~~~~

Pour g�n�rer une iso GeeXboX vous devez poss�der l'un des syt�mes suivants:
  - GNU/Linux avec mkisofs et mkzftree.
  - MAC OS X avec mkisofs et mkzftree.
  - Windows.

Pour construire votre propre GeeXboX, vous n�cessiterez les outils
classiques :
  - un syst�me GNU/Linux op�rationnel.
  - Le compilateur C GCC.
  - GNU make
  - La commande patch.
  - L'assembleur nasm.
  - bzip2 et gzip.
  - L'outil de t�l�chargement wget (non n�cessaire pour le paquetage
    GeeXboX complet).
  - mkisofs et mkzftree pour construire l'image ISO.
  - mkzftree pour compresser les fichiers de l'image ISO.
  - cdrecord (pour graver l'image).

Et environ 2 Go d'espace disque disponible.


| PERSONALISATION
| ~~~~~~~~~~~~~~~

Le but du g�n�rateur est de personnaliser facilement sa GeeXboX.

La chose la plus interessante que vous puissiez faire et de g�n�rer une image
comportant une vid�o compl�te qui sera lu automatiquement au boot. Vous avez
juste � copier vos vid�os (ou vos fichiers sons) et vos playlists dans le
repertoire iso.

Vous pouvez aussi ajouter des codecs propri�taires comme le rv9 ou le wmv9, en
les copiant simplement dans le r�pertoire iso/GEEXBOX/codecs. Ces codecs se
trouvent ici :
http://www.geexbox.org/releases/geexbox-extra-codecs-nonfree.tar.gz

Vous pouvez modifier d'autres options en �ditant simplement des fichiers
textes.

* Chargement des firmwares :

    La GeeXboX supporte de nombreux pilotes de p�riph�riques mais
    malheureusement, certains d'entre eux requierent un firmware binaire
    additionnel propri�taire (i.e. non-libre et donc non-inclus dans la
    GeeXboX). Le firmware est un fichier binaire qui est envoy� au
    p�riph�rique (PCI ou USB) lorsque le pilote se charge. Pour chaque pilote,
    le firmware se doit d'�tre un fichier sp�cifique avec un nom
    pr�-d�termin�.

    Si vous disposez de mat�riel � probl�me qui peut n�cessiter la pr�sence
    d'un firmware additionnel (dans la plupart des cas, il s'agit de cartes
    WiFi ou DVB), vous devrez chercher sur Internet une page concernant le
    support de p�riph�rique sous Linux et l'utilisation du firmware.
    La plupart du temps, vous tomberez sur un lien de t�l�chargement direct.
    Des fois, il vous sera n�cessaire d'extraire ce firmware depuis une
    archive de pilotes pour Windows qui ont �t� fourni par le fabricant du
    p�riph�rique.

    Une fois que vous disposerez du fichier de firmware pour votre carte,
    d�posez le simplement dans le r�pertoire /firmwares. Vous pouvez y stocker
    autant de firmwares que vous voudrez, la GeeXboX essaiera d'elle m�me de
    les charger lorsqu'un pilote en aura besoin. La seule chose dont vous ayez
    � vous soucier et de disposer des bons fichiers de firmwares avec les bons
    noms avant de reg�n�rer une nouvelle ISO.

    Veuillez noter que vous pouvez �galement utiliser le g�n�rateur d'ISO de
    la GeeXboX qui vous permettra de r�cup�rer les firmwares pour vous.
    Vous pouvez l'utiliser pour s�lectionner tous les fichiers de firmware que
    vous souhaiter et le g�n�rateur les t�l�chargera et ajoutera pour vous.
    Assurez vous juste de disposer d'une connexion � Internet lors de
    l'utilisation du g�n�rateur.

* MPlayer :

    C'est ici que se font la plupart des configurations et modifications.
    Les options se situent dans le fichier packages/MPlayer/mplayer.conf
    Il est possible de changer des options comme la taille des police de l'OSD
    (subfont-text-scale) et beaucoup d'autres choses telles que la langue par
    d�faut de lecture des DVD (ex: alang=fr,en). La meilleur fa�on de
    comprendre ces options est, pour les utilisateurs de Linux, de se r�f�rer
    au MAN de MPlayer (man -l build/MPlayer-*/DOCS/mplayer.1). D'autres
    informations sont aussi disponibles sur la documentation officielle
    (http://mplayerhq.hu/DOCS/).
    Il peut �galement �tre int�ressant de modifier le fichier
    packages/MPlayer/menu.conf. Vous pouvez les menus qui vous semblent
    inutiles, ou les traduire dans d'autres langues par exemple. Enfin, le
    dernier int�ressant est packages/MPlayer/build, qui contient la s�lection
    d'options de compilation de MPlayer.

* Sortie TV :

    Activer la sortie TV se fait au moyen de nombreux petits utilitaires
    d�di�s chacun � une marque carte graphique. Nous utilisons actuellement
    atitvout pour les cartes ATI, s3switch pour les cartes S3 et nvtv pour les
    cartes nVidia (ce qui peut aussi marcher abec les cartes i810 et 3dfx). La
    configuration de ces programmes se fait dans iso/GEEXBOX/etc/tvout.
    Vous pouvez y choisir le standard que vous utilisez (pal, secam...) et y
    modifier les options sp�cifiques de nvtv.

    # TV Output Standard (ntsc/pal/secam)
    TVOUT_STANDARD=pal

    Vous pouvez �galement d�finir le rapport d'image de sortie (mode 4:3 ou
    16:9) via la ligne :

    TVOUT_ASPECT="4:3"

    Ce param�tre est utilis� � la fois pour la sortie TV et pour l'affichage
    classique sur moniteurs CRT ou TFT. Vous pouvez �galement d�finir les
    valeurs de hauteur et largeur (en pixels) pour l'affichage, ainsi que les
    fr�quences de rafraichissement horizontal et vertical, dans le cas o� vous
    utiliseriez un �cran panoramique ou encore un r�tro-projecteur. Ceci peut
    etre fait en modifiant le contenu du fichier /etc/mplayer/mplayer.conf.
    Les param�tres suivants sont donn�s par d�faut (veuillez d�commenter les
    lignes li�es � la fr�quence de refraichissement si vous souhaiter les
    utiliser ) :

    screenw=800
    screenh=600
    #monitor-hfreq=31.5k-50k
    #monitor-vfreq=50-90

* Lirc :

    Choisissez la t�l�commande support� en �ditant le fichier generator.sh ou
    generator.bat (en fonction de votre OS). Faite �galement attention �
    bien choisir le r�cepteur infrarouge correspondant dans le m�me fichier.
    Si vous d�sirez modifier le mappage des touches reportez vous au fichier
    lirc/lircrc_REMOTE.

* R�seau :

    Le r�seau est configurable au niveau du fichier iso/GEEXBOX/etc/network.
    Ici vous reglerez l'adresse IP de la GeeXboX (qui par d�faut cherche un
    serveur DCHP ou prend l'IP 192.168.0.54 si elle n'en trouve pas). Il est
    aussi possible de lui assigner un login est un mot de passe (par d�faut,
    la GeeXboX ne peut se connecter que sur des partages anonymes).
    Vous pouvez aussi d�clarer des montages NFS dans GEEXBOX/etc/nfs.

* WiFi :

    Par defaut, le syst�me tente de d�tecter automatiquement votre
    configuration r�seau. Si vous disposez � la fois d'une carte r�seau
    Ethernet classique et d'une carte WiFi, seule cette derni�re sera
    configur�e. Vous pourrez avoir � modifier le fichier /etc/network afin
    d'y configurer vos param�tres r�seaux. Dans ce dernier, 4 lignes sont
    relatives aux cartes sans-fils :

    PHY_TYPE="auto"      # Network physical type (auto|ethernet|wifi)
    WIFI_MODE="managed"  # Wifi working mode (managed|ad-hoc)
    WIFI_WEP=""          # Wifi WEP key
    WIFI_ESSID="any"     # Wifi SSID

    Vous pouvez soit conserver la d�tection automatique, soit forcer
    l'activation du controleur Ethernet ou WiFi. De la m�me fa�on, ceci vous
    permettra de choisir entre le mode managed et le mode de communication dit
    ad-hoc et de d�finir � la fois votre cl� WEP et le SSID de votre r�seau.

* Passerelle :

    La GeeXboX supporte l'acc�s � Internet. D�finissez simplement l'adresse IP
    de la passerelle dans le fichier /etc/network

    GATEWAY=""     # Gateway IP ("" for DHCP or no internet connection)

* Configuration TV :

    La GeeXboX supporte les entr�es et tuners de cartes TV. Le syst�me essaie
    avec peine de d�tecter automatiquement le type de carte et de tuners
    utilis�s. Vous pouvez forcer les param�tres et ainsi �viter la tentative
    de d�tection automatique. Veuillez modifier le fichier /etc/tvcard
    tel qu'il suit :

    # TV CARD/TUNER Model (AUTO for autodetection or look at the following urls)
    # http://www.linuxhq.com/kernel/v2.6/2/Documentation/video4linux/CARDLIST.bttv
    # http://www.linuxhq.com/kernel/v2.6/2/Documentation/video4linux/CARDLIST.tuner
    TV_CARD=AUTO
    TV_TUNER=AUTO

    Laissez le param�tre AUTO si vous souahitez conserver la d�tection
    automatique, ou remplacez le par le num�ro de la carte et du tuner,
    comme d�crit dans les URL pr�c�dentes. Soyez attentifs : pour forcer les
    types de cartes et de tuners, vous devez conna�tre les REFERENCES EXACTES
    de votre mat�riel.

    Une fois cela fait, vous devriez �tre en mesure d'utiliser les entr�es TV
    (Composite et S-VHS) de votre carte TV. De la m�me mani�re, vous pouvez
    utiliser le tuner pour regarder la TV. Pour cela, vous devrez d�finir
    votre r�gion ainsi que les fr�quences des cha�nes que vous souhaitez
    visionner. Editez simplement le fichier /etc/tvcard :

    # TV Channels
    # Syntax : CHAN="Channel Frequency:Channel Title"
    # Example :
    # CHAN="29:France 2"
    # CHAN="K08:Canal +"
    # TV Channels List
    # Available : france, europe-east, europe-west, us-bcast, us-cable
    CHANLIST=france

    Faites attention lors de l'�dition des canaux TV et veillez � utiliser
    la m�me syntaxe que d�crit ci-dessus et les canaux TV devraient
    appara�tre dans le menu principal.

* Configuration Audio :

    La GeeXboX supporte � la fois la restitution audio via la sortie
    analogique ou num�rique, en utilisant les connecteurs classiques JACK
    ou RCA SPDIF.
    Par d�faut, la sortie est g�r�e de mani�re analogique. Ceci peut etre
    chang� en modifiant le fichier /etc/audio :

    # Output using SPDIF (yes/no), otherwise ANALOG output
    SPDIF=no

    Souvenez vous qu'il est n�cessaire de r�gler la sortie en mode num�rique
    (SPDIF), si vous souhaitez relier votre carte son � un amplificateur hifi
    externe pour d�coder des flux AC3/DTS (en utilisant le mode passthrough).

* Post-Processing vid�o :

    Le Post-Processing est un moyen logiciel pour affiner une image, en la
    rendant plus nette et plus pr�cise. Cela a par contre l'inconv�nient de
    consommer une partie du temps processeur afin de rendre l'image plus
    belle. Via l'utilisation des filtres internes � MPlayer, la GeeXboX vous
    permet de minimiser les effets de blocs horizontaux et verticaux, les
    effets d'anneaux de d�grad�s et de corriger automatiquement la luminosit�
    de votre film. Par d�faut, le Post-Processing est d�sactiv�, pour �viter
    de saccader sur de petites configurations mat�rielles. Il vous est
    possible de l'activer tr�s simplement en �ditant le fichier
    /etc/mplayer/mplayer.conf :

    # Set Post Processing (h deblock, v deblock, dering, auto luminance)
    # Consumes CPU power, disabled for low configs, uncomment to enable it.
    #vf=pp=hb:a/vb:a/dr:a/al:a

* DXR3/Hollywood+ cards :

    Les utilisateurs de ce type de cartes de d�compression n'ont pas besoin
    d'avoir une carte vid�o ou une carte son dans leur ordinateur. Parmi les
    inconv�nients, on notera n�anmoins que seule la sortie TV peut etre
    utilis�e avec ce type de carte (pas d'affichage sur moniteur).
    Vous pouvez etre amen� � d�finir la norme d'image souhait�e (PAL/NTSC)
    via le fichier /etc/tvout ainsi que le type de sortie audio � utiliser
    (Analogique ou SPDIF) via le fichier /etc/audio.

* Configuration de la radio :

    Si v�tre carte TV dispose d'un tuner radio FM int�gr�, la GeeXboX vous
    permet d'�couter la radio. Pour cela, il vous faudra modifier le fichier
    GEEXBOX/etc/radio pour mettre l'option RADIO � yes.

    Le fichier GEEXBOX/etc/radio contient aussi la d�finition des stations.
    Des exemples sont pr�sents dans le fichier. Il suffira de les d�-commenter
    et de les adapter � vos stations favorites.

    Le programme d'�coute de la radio ne faisant pas partie de MPlayer, il
    y a des contr�le de volume s�par�s pour la radio. Notez que le volume
    contr�l� est le volume principale. Il pourra donc �tre n�cessaire de le
    r�ajuster avant de lancer la TV, une vid�o ou de la musique.

* Partage de fichiers via UPnP :

    UPnP est l'acronyme de Universal Plug & Play et peut se d�crire comme un
    protocole r�seau permettant l'auto-d�couverte de p�riph�riques ainsi que
    des services qui leur sont associ�s au sein de votre r�seau domestique.
    La norme UPnP A/V (pour Audio/Video) d�finit un certains nombre de
    profiles pour des p�riph�riques permettant le partage et la lecture de
    fichiers multim�dias au sein d'un r�seau. Le profile UPnP Media Server
    permet regroupe tous les p�riph�riques capables de partager des fichiers
    � des p�riph�riques de type UPnP Media Player ou UPnP Media Renderer,
    qui sont en mesure de les restituer.

    La GeeXboX embarque un logiciel de contr�le UPnP (UPnP Control Point) qui
    permet l'auto-d�couverte de tous les p�riph�riques de type Media Server de
    votre r�seau local et qui s'occupe de monter leur contenu en toute
    transparence dans un point de montage d�di� (/mnt/UPnP).

    De cette mani�re, il vous suffit de disposer d'un PC ou autre p�riph�rique
    poss�dant un logiciel compatible avec le profile UPnP Media Server pour
    que son contenu soit accessible depuis la GeeXboX. Pour plus d'infos sur
    l'UPnP ainsi que l'utilsiation de quelques serveurs,
    veuillez vous r�f�rer � la page suivante :
    http://www.geexbox.org/wiki/index.php/Accessing_to_UPnP_Contents

* Streaming r�seau :

    GeeXboX permet de rajouter les listes de streams SHOUTcast Radio et TV
    tout autant que vos propres listes de lecture. (locales et distantes.)

    L'activation de SHOUTcast se d�clare dans le fichier de configuration
    "GEEXBOX/etc/network". SHOUTcast TV �tant succeptible de diffuser des
    streams n�cessitant une inscription particuli�re ainsi que des streams
    � caract�re pornographique, une liste noire et une liste blanche
    peuvent �tre compl�t�es afin de filtrer le contenu selon vos crit�res
    (par d�faut, les mots clefs d�finis pour la liste noire sont :
    "adult xxx porn ESS SWCTV SWPTV Subscription"). La liste noire et la
    liste blanche sont insensibles � la casse.

    Vous pouvez cr�er vos listes de lecture locales et distantes dans le
    fichier de configuration "GEEXBOX/etc/netstream" (Des exemples sont
    contenus dans ce fichier). Les listes de lecture distantes concernent
    uniquement les fichiers M3U Etendus.

    Note aux utilisateurs (Fran�ais uniquement) :
    Il est possible de receptionner un flux "FreeboxTV" gr�ce � ce fichier.
    Pour y parvenir, veuillez suivre la proc�dure suivante :
    - d�-commentez l'entr�e EXTM3U ad-hoc.
    - utilisez une version de GeeXboX compil�e avec le support de la
      librairie "LIVE555".
    (ces deux conditions �tant n�cessaires � la visualisation du flux) 

* Cartes DVB :

    La GeeXboX supporte un grand nombre de cartes DVB (Terrestre i.e. TNT,
    Cable, ATSC et Satellite) et ce, aussi bien en PCI qu'en USB. Veuillez
    cependant noter qu'il n'est pour l'instant possible d'utiliser qu'un
    unique adaptateur DVB � la fois.

    Certains p�rip�hriques DVB (particuli�rement ceux en USB) peuvent
    n�cessiter un firmware propri�taire additionnel pour fonctionner
    correctement. Il vous sera peut �tre utile de jeter un oeil au Wiki DVB de
    LinuxTV (http://linuxtv.org/wiki/index.php/Main_Page) pour vous assurer
    que votre carte n�cessite un tel firmware ou non. Dans ce cas, le
    g�n�rateur d'ISO pourra le t�l�charger pour vous.

    Certains firmwares peuvent �tre r�cup�r�s directement depuis le site Web
    de LinuxTV (http://linuxtv.org/download/firmware/), d'autres peuvent �tre
    inclus dans l'archive de drivers Windows du constructeur de la carte.
    Veuillez vous r�f�rer � la documentation sur le chargement des firmwares
    dans la GeeXboX pour de plus amples informations.

    Pour chaque carte, la liste des cha�nes disponibles est disponible au sein
    du menu de MPlayer. Il n'est cependant pas possible d'auto-d�couvrir ces
    cha�nes automatiquement.

    De ce fait, la d�claration de cha�nes accessibles par DVB dans la GeeXboX
    peut �tre fait de diff�rentes mani�res :

    - utiliser une liste de cha�ne existante : MPlayer a besoin d'un fichier
    channels.conf valide et fonctionnel pour faire fonctionner la DVB. Ce
    fichier peut �tre g�n�r� � l'aide d'utilitaire fournis par le paquetage
    dvb-apps. Utilisez simplement une distribution Linux classique o� votre
    carte DVB a d�j� �t� configur�e, t�l�chargez l'archive linuxtv-dvb-apps
    depuis le site http://www.linuxtv.org/download/dvb/, compilez le tout et
    cr�ez le fichier de configuration via l'utilitaire "scan", dans le format
    "zap" (qui est le format par d�faut).

    Par exemple, pour une carte DVB-S (Satellite) utilisant le fournisseur
    d'acc�s Astra-19.2E :

      wget http://www.linuxtv.org/download/dvb/linuxtv-dvb-apps-1.1.0.tar.bz2
      tar jxvf linuxtv-dvb-apps-1.1.0.tar.bz2
      cd linuxtv-dvb-apps-1.1.0/util/scan
      make
      ./scan -x 0 dvb-s/Astra-19.2E > channels.conf

    Le drapeau "-x 0" indique que le scan ne tentera pas de se connecter aux
    cha�nes crypt�es (g�n�ralement payantes). Veuillez tout le temps proc�der
    de la sorte, MPlayer ne g�rant de toutes fa�ons pas les cha�nes
    DVB crypt�es.

    Selon votre type de carte DVB, choisissez un fichier de transponders
    (fournisseur) depuis les r�pertoires "dvb-s", "dvb-c", "dvb-t" ou "atsc".

    Ensuite, copiez simplement le fichier channels.conf que vous venez de
    g�n�rer au sein du r�pertoire /etc/mplayer de l'arborescence GeeXboX
    du g�n�rateur and recompilez une ISO.

    - utiliser une liste de transpondeur existante : cette proc�dure est
    relativement similaire � la pr�c�dente � la diff�rence qu'il s'agit cette
    fois de la GeeXboX qui va s'occuper de scanner les cha�nes pour vous et
    ce, � chaque d�marrage. Vous n'aurez ainsi plus besoin d'une autre
    distribution Linux pour g�n�rer le fichier channels.conf.

    Pour ce faire, rendez-vous simplement sur :
      http://linuxtv.org/cgi-bin/viewcvs.cgi/dvb-apps/util/scan/

    Selon votre type de carte DVB (S/T/C/ATSC), s�lectionnez le bon r�pertoire
    et choisissez le fichier de liste de fr�quences de transpondeurs qui
    correspond � vos besoins ou votre localisation g�ographique. Renommez
    ensuite simplement ce fichier en dvb.conf et copiez le dans le r�pertoire
    /etc. Puis, reconstruisez une ISO via le g�n�rateur.

    Au d�marrage, si la GeeXboX d�tecte un fichier de transpondeur valide dans
    le fichier /etc/dvb.conf, elle l'utilisera pour scanner les cha�nes DVB
    disponibles et g�n�rera le fichier /etc/mplayer/channels.conf d'elle-m�me.

    ATTENTION : Le scan de cha�nes peut �tre relativement lent selon le type
    d'�metteur et le nombre de cha�nes � d�couvrir. Ce processus est de plus
    effectu� � chaque d�marrage de la GeeXboX si vous l'utilisez en tant que
    LiveCD. Il est alors hautement recommand� qu'une fois le scan effectu�,
    vous copiez manuellement le fichier /etc/mplayer/channels.conf qui aura
    �t� g�n�r� quelque part afin de pouvoir le r�-utiliser dans le g�n�rateur
    d'ISO en suivant la premi�re m�thode, ou de faire une installation sur
    disque dur.

    - utiliser l'installator : il s'agit probablement l� de la m�thode la plus
    simple mais recquiert une installation sur disque de la GeeXboX. Au cours
    du processus d'installation, si un p�riph�rique compatible DVB est reconnu
    sur votre syst�me, le script d'installation vous demandera de lui-m�me si
    vous souhaitez rechercher les cha�nes disponibles pour votre carte DVB.

    L'installator contient la liste compl�te des fr�quences des transpondeurs
    du site LinuxTV. De ce fait, vous n'aurez qu'� s�lectionner votre type de
    carte ainsi que le transpondeur � utiliser et la GeeXboX s'occupera de
    scanner letout et de g�n�rer le fichier /etc/mplayer/channels.conf.

* Menus de Navigation DVD :

    La GeeXboX propose 2 m�thodes de lecture des DVD :
     - Lecture directe du film (defaut).
     - Lecture avec support des menus de Navigation DVD (exp�rimental).

    La premi�re permet une lecture quasi-assur�e de la plupart des DVDs. Une
    fois ins�r�, le disque est automatiquement d�tect� et MPlayer va essayer
    de lire le chapitre qu'il jugera correspondre au film. Le principal
    avantage r�side dans le fait que toutes les sc�nes de droit d'auteur,
    publicit�s ou menus seront saut�es pour permettre une lecture instantann�e
    du film. N�anmoins, dans certaines situations (comme les DVD avec des
    menus tr�s sophistiqu�s ou encore les DVD de s�ries TV, contenant de
    multiples �pisodes et donc chapitres), cette m�thode n'est pas pr�cise
    et vous pourriez ne pas �tre en mesure de lire votre film correctement.

    La seconde, bien qu'encore exp�rimentale avec MPlayer (mais qui a
    n�anmoins de tr�s fortes chances de fonctionner), apporte le support des
    menus de navigation DVD, vous permettant donc de le lire comme vous le
    feriez avec n'importe quel lecteur DVD du commerce, avec les avantages et
    inconv�nients qui en d�coulent.

    Il vous est bien entendu possible de basculer d'un mode de lecture DVD
    � un autre au moyen du menu d'options de la GeeXboX, selon le DVD que vous
    �tes amener � visionner.

    Il vous est �galement possible de sp�cifier la m�thode de lecture par
    d�faut au moyen du g�n�rateur d'ISO de la GeeXboX.


| INSTALLATION
| ~~~~~~~~~~~~

Le plus simple est de d�marrer la GeeXboX depuis le CD est de
taper "install" au prompt de d�marrage.

R�pondez ensuite � toutes les questions. Lisez les questions avec attention
et stoppez l'installation si vous ne comprenez pas ce que vous faites.


| BOOT PXE
| ~~~~~~~~

Oui, la GeeXboX est capable de booter depuis le r�seau sur une machine
sans disque ! Pour obtenir cela il vous faudra :
 - un serveur DHCP
 - un serveur TFTP
 - un serveur NFS
 - une machine supportant le PXE :-)

* Depuis un poste GNU/Linux :
  -------------------------

Il faut tout d'abord configurer le server DHCP pour qu'il envoie les info de
boot PXE. Voil� un exemple de configuration avec isc dhcp :

allow booting;
allow bootp;

subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.128 192.168.0.192;
  option subnet-mask 255.255.255.0;
  option broadcast-address 192.168.0.255;
  next-server 192.168.0.1;
  filename "/tftpboot/GEEXBOX/boot/pxelinux.0";
}

L'option next-server est l'adresse du server TFTP.
Ensuite il faut configurer votre serveur TFTP (tel que atftpd) pour qu'il
serve le r�pertoire /tftpboot et copier une arborescence GEEXBOX compl�te
dans ce r�pertoire. Par exemple il est possible de copier le contenu d'un
CD de GeeXboX depuis un linux AVEC L'OPTION CDROM TRANSPARENT DECOMPRESSION
ACTIVE !! (pour v�rifier cela, il suffit de regarder si le fichier sbin/init
de l'arborescence GeeXboX ne contient pas de caract�res totalement
incoh�rents). Si vous avez compil� la GeeXboX vous m�me a partir des sources,
il est aussi possible de g�n�rer l'arborescence GEEXBOX avec make pxe.

Ensuite il faut �diter le fichier /tftpboot/GEEXBOX/boot/pxelinux.cfg/default
pour faire correspondre le nfsroot au bon chemin NFS vers l'arborescence
GeeXboX.

Enfin il reste a configurer NFS pour qu'il exporte l'arborescence GEEXBOX
avec un fichier /etc/exports ressemblant � ceci :

/tftpboot/GEEXBOX (ro)

et un /etc/hosts.allow ressemblant � :

ALL: ALL

Ca devrait �tre bon.
Reste a booter la machine PXE et a voir ce qu'il se passe.

* Depuis un poste Microsoft Windows :
  ---------------------------------

Pour d�marrer en mode PXE depuis un syst�me Microsoft Windows, il vous faudra
les logiciels suivants :

* Un serveur TFTP et un serveur DHCP ("tftpd32" remplira cette t�che,
  il est disponible � l'adresse http://tftpd32.jounin.net/).
* Un serveur NFS (comme par exemple "Allegro NFS server", disponible �
  l'adresse http://opensource.franz.com/nfs/).
* Une machine supportant le boot en mode PXE.

T�l�chargez et d�compressez (aucune installation n'est requise) le dossier
tftpd32 quelque part sur votre disque, par exemple C:\tftpd32

Copiez y une arborescence GEEXBOX compl�te : C:\tftpd32\GEEXBOX

Lancez tftpd32 :
- S�lectionnez le dossier C:\tftpd32 pour "current directory".
- choisissez l'interface (carte r�seau) � utiliser en haut dans
  "server interface". Ici dans l'exemple une carte avec l'IP 192.168.0.1
- Cliquez sur "setting" et v�rifiez que "DHCP server" soit bien coch�e.
- Dans l'onglet "DHCP server", remplissez les champs, en suivant cet exemple :
  (se r�f�rer � une documentation plus approfondie sur le fonctionnement
  d'un serveur DHCP pour plus de d�tails)
	* IP starting pool : 192.168.0.10
	* Size of pool  : 10
	* Boot file : ./GEEXBOX/boot/pxelinux.0
	* WINS/DNS server : 192.168.0.254
	* Default router : 192.168.0.254
	* Mask : 255.255.255.0
	* Domain name : mydomain.net
- Faites "save" pour appliquer les modifications.

La premi�re partie est termin�e, normalement en d�marrant la machine cliente
(qui doit lancer la GeeXboX), on devrait apercevoir le chargement jusqu'�
l'affichage du logo. Le syst�me se bloquera alors, car le serveur NFS
n'a pas encore �t� configur�.

Installez "Allegro NFS Server" et configurez le comme suit :

- Onglet Exports :
	* faites un "new name" : et nommez le "/tftpboot/GEEXBOX"
	* dans "path", juste en dessous : selectionnez le
          r�pertoire "C:\tftp32\GEEXBOX"
	* dans "allowed host list", selectionnez "all".
	* "Read write" , et "read only user list", selectionnez "root"
          et "everyone" (pour avoir un log, il suffit de tout cocher
          dans le dernier onglet).

Faites "Appliquer".

N'oubliez pas de modifier le fichier
C:\tftp32\GEEXBOX\boot\pxelinux.cfg\default et d'y changer l'adresse IP
"192.168.0.2" en "192.168.0.1" (ou toute adresse que vous aurez choisie).

Il suffit maintenant de d�marrer la machine cliente pour amor�er la GeeXboX
par le r�seau.


| COMPILATION
| ~~~~~~~~~~~

Tout d'abord, regardez la partie de configuration ci-dessous.

Typiquement, la compilation s'effectue simplement au moyen de :
  make
Ou vous pouvez directement compiler et graver l'ISO via :
  make burn

Une fois cela fait, vous pouvez regagner de l'espace disque en effa�ant
l'arborescence de compilation via :
  make clean
ou en effectant un nettoyage complet, �liminant m�me les
sources t�l�charg�es :

  make distclean

Il existe �galement des commandes plus avanc�es si vous d�sirez effectuer
des modifications en profondeur au niveau de la GeeXboX :
  scripts/get package          # t�l�charge le paquetage
  scripts/unpack package       # pr�pare le paquetage
  scripts/build package        # compile le paquetage
  scripts/install package      # installe le paquetage dans $INSTALL
  scripts/clean package        # nettoie l'arborescence du paquetage
  scripts/clean --full package # nettoie les sources du paquetage
  make exec                    # lance la GeeXboX dans une cellule
                               # ATTENTION: ceci est une fonction
                               # exp�rimentale.
                               # Utilisez l� � vos propres risques.

Si vous avez effectu� une version modifi�e de la GeeXboX, vous pouvez :
construire une archive r�duite tar.bz2 via :
  make dist
ou une archive compl�te (avec l'int�gralit� des sources) au moyen de :
  make fulldist
ou construire le g�n�rateur d'ISO :
  make generator
ou encore l'installateur :
  make installator
ou enfin une arborescence PXE :
  make pxe


| CONFIGURATION
| ~~~~~~~~~~~~~

* Options Globales :

    C'est la premi�re chose dont vous aurez � vous soucier avant d'essayer de
    compiler la GeeXboX. Elles sont contenues dans le fichier config/options,
    et devraient �tre suffisamment explicites.

* Linux :

    Il s'agit d'une configuration Linux classique (packages/linux/linux.conf).
    Vous pouvez �diter le fichier � la main, ou via scripts/unpack linux
    suivi de make menuconfig -C build/linux-* (ou utiliser votre m�thode
    pr�f�r�e en lieu et place de menuconfig). Puis, vous devrez sauvegarder
    votre fichier build/linux-*/.config dans packages/linux/linux.conf.

* Lirc :

    Lirc vous permet de contr�ler la GeeXboX en utilisant une t�l�commande.
    En premier lieu, vous aurez � choisir le fichier correspondant � votre
    t�l�commande dans build/lirc-*/remotes (apr�s avoir effectu�
    scripts/unpack lirc) et l'ajouterez � packages/lirc/install.

    Puis, choisissez votre p�riph�rique (par d�faut, il s'agit de /dev/ttyS0
    (COM1)) et le pilote lirc et mettez le tout dans un fichier nomm�
    packages/lirc/lircd_$REMOTE.

    Vous pourrez ensuite choisir l'affectation des touches dans le fichier
    packages/lirc/lircrc_$REMOTE. Pour chaque affectation, vous aurez � chosir
    un bouton (choisissez leurs noms dans le fichier de d�finitions de la
    t�l�commande) et associez lui une action. L'action sera une de celle
    disponible dans MPlayer (vous pouvez trouver une liste dans le fichier
    html build/MPlayer-*/DOCS/documentation.html#commands).


| MODIFICATION
| ~~~~~~~~~~~~

La premi�re chose dont vous aurez �vous soucier concerne le script
d'initialisation. En fait, ils sont 2. Le premier est dans
packages/initrd/linuxrc mais vous ne devriez pas avoir besoin de le modifier.
Le second est config/init et c'est dans ce dernier que vous aurez de
probables modifications � effectuer.

Puis, vous pourrez �tre int�ress�s par l'ajout de nouveaux paquetages. Un
paquetage n'est implement qu'un ensemble de scripts qui se doivent de suivre
certaines r�gles. Tous les scripts se doivent d'�tre plac�s dans un
r�pertoire dont le nom co�ncide avec celui du programme que vous d�sirez
ajouter, lui-m�me dans le r�pertoire packages.

Voici une liste de scripts que vous aurez � cr�er :
 - url : simple liste d'URLS o� sont disponibles les sources.
 - unpack : que faire apr�s avoir d�compresser les sources. Par exemples, vous
            pouvez modifier les fichiers de configuration. Ceci ne concerne
            pas l'application de patchs.
 - need_build : appel� lorsque le paquetage a d�j� �t� compil�, afin de
                s'assurer qu'il n'aura plus besoin d'�tre recompil�.
                Il devrait supprimer le fichier .stamps/"package name"/build
                si le paquetage n�cessite d'�tre reconstruit.
 - build : l'ensemble des �tapes n�cessaires pour compiler le programme.
 - install : l'ensemble des �tapes n�cessaires � l'installation du programme.
             Le pr�fixe d'installation devrait �tre $INSTALL.

De plus, le r�pertoire d�crivant un paquetage peut contenir de nombreux
sous-r�pertoires additionnels :
 - config : c'est l� que sont situ�s tous les fichiers de configuration. Ces
            derniers peuvent �tre, soit utilis�s par le script build pour
            compiler le paquetage, soit par le script install pour �tre copi�s
            dans le r�pertoire /etc de destination.
 - scripts : ce sous-r�pertoire peut contenir des scripts d'initialisation li�
             au paquetage courant et qui seront install�s par le script
             install
 - patches : ce sous-r�pertoire peut contenir des patchs destin�s � �tre
             appliqu�s aux sources du paquetage, au moment du script unpack.
 - sources : si des fichiers sont pr�sents dans ce sous-r�pertoire, ils seront
             automatiquement copi�s dans l'arbre de compilation du paquetage.
 - init.d : contient les scripts d'initialisation qui seront �x�cut�s au
            chargement du syst�me.

Vous devez avoir � l'esprit que les applications qui tournent sous le syst�me
GeeXboX doivent avoir �t� compil� avec la librairie uClibc.

Enfin, la meilleure mani�re d'ajouter un paquetage est de s'inspirer de la
fa�on dont les actuels sont faits.


| LICENSE
| ~~~~~~~

Tous les programmes utilis�s par GeeXboX sont prot�g�s par leurs licenses
respectives. Tous ces logiciels sont libres et, pour la plupart, prot�g�s par
une licence GPL (License Publique G�n�rale)
La GeeXboX elle-m�me, c'est � dire tous les scripts utilis� et le syst�me
de compilation, est couvert par la licence GNU-GPL.

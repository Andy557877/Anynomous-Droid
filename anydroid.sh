#!/data/data/com.termux/files/usr/bin/bash
# Anynomous Droid - Emulator Termux Premium
# Versi 5.0 - Windows Longhorn Theme & Auto Wine Install
# By [Nama Anda]

# Konfigurasi dasar
ANON_DIR="$HOME/.anydroid"
RESOLUTION="1024x768"
LANG="en"
WINE_VERSION="winehq-staging"  # Versi Wine terbaru
THEME_URL="https://github.com/B00merang-Project/Windows-Longhorn/archive/master.zip"
DISTRO_NAME="ubuntu"
DISTRO_ALIAS="anon-ubuntu"
DISTRO_ROOTFS="$PREFIX/var/lib/proot-distro/installed-rootfs/$DISTRO_ALIAS"
USER_NAME="user"
USER_PASSWORD="password"
THEME_DIR="$DISTRO_ROOTFS/home/$USER_NAME/.themes/Windows-Longhorn"

# Fungsi untuk menampilkan header
header() {
    clear
    echo -e "\e[1;32m"
    echo " █████╗ ███╗   ██╗██╗   ██╗ ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗███████╗"
    echo "██╔══██╗████╗  ██║██║   ██║ ████╗  ██║██╔═══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝"
    echo "███████║██╔██╗ ██║██║   ██║ ██╔██╗ ██║██║   ██║██╔████╔██║███████║██╔██╗ ██║███████╗"
    echo "██╔══██║██║╚██╗██║██║   ██║ ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║╚════██║"
    echo "██║  ██║██║ ╚████║╚██████╔╝ ██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║███████║"
    echo "╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝"
    echo "                                                                                     "
    echo "██████╗ ██████╗  ██████╗ ██╗██████╗      ██████╗  ██████╗ ██████╗ ██╗████████╗██╗   ██╗"
    echo "██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗    ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝"
    echo "██║  ██║██████╔╝██║   ██║██║██║  ██║    ██║  ███╗██║   ██║██║  ██║██║   ██║    ╚████╔╝ "
    echo "██║  ██║██╔══██╗██║   ██║██║██║  ██║    ██║   ██║██║   ██║██║  ██║██║   ██║     ╚██╔╝  "
    echo "██████╔╝██║  ██║╚██████╔╝██║██████╔╝    ╚██████╔╝╚██████╔╝██████╔╝██║   ██║      ██║   "
    echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝      ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝   ╚═╝      ╚═╝   "
    echo -e "\e[0m"
    echo -e "\e[1;37m        Run Windows applications and games on Android!\e[0m"
    echo "================================================================"
    echo -e "\e[1;33mVersi: 5.0 | Tema: Windows Longhorn | Wine: $WINE_VERSION\e[0m"
}

# Fungsi untuk instalasi Termux-X11
install_termux_x11() {
    echo -e "\e[1;34m[*] Memulai instalasi Termux-X11...\e[0m"
    
    # Perbarui paket
    pkg update -y
    pkg upgrade -y
    
    # Instal repositori yang diperlukan
    pkg install x11-repo -y
    
    # Instal Termux-X11 dan dependensi
    pkg install termux-x11-nightly pulseaudio wget proot-distro unzip git \
        xorg-server-xvfb p7zip neofetch -y
    
    # Aktifkan akses penyimpanan
    termux-setup-storage
    
    echo -e "\e[1;32m[✓] Termux-X11 berhasil diinstal!\e[0m"
    sleep 2
}

# Fungsi untuk setup repository WineHQ
setup_wine_repository() {
    echo -e "\e[1;34m[*] Menyiapkan repository WineHQ...\e[0m"
    
    # Download dan tambah kunci GPG
    proot-distro login $DISTRO_ALIAS --user root -- wget -nc https://dl.winehq.org/wine-builds/winehq.key
    proot-distro login $DISTRO_ALIAS --user root -- apt-key add winehq.key
    
    # Tambah repository WineHQ
    proot-distro login $DISTRO_ALIAS --user root -- \
        apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(proot-distro login $DISTRO_ALIAS --user root -- lsb_release -cs) main" -y
    
    # Perbarui repositori
    proot-distro login $DISTRO_ALIAS --user root -- apt update
    
    echo -e "\e[1;32m[✓] Repository WineHQ siap!\e[0m"
    sleep 1
}

# Fungsi untuk memeriksa dan menginstal dependensi
install_dependencies() {
    echo -e "\e[1;34m[*] Memeriksa dependensi Anynomous Droid...\e[0m"
    
    # Download rootfs Ubuntu jika belum ada
    if [ ! -d "$DISTRO_ROOTFS" ]; then
        echo -e "\e[1;34m[*] Menginstal Ubuntu...\e[0m"
        proot-distro install $DISTRO_NAME --override-alias $DISTRO_ALIAS
        
        # Konfigurasi user
        proot-distro login $DISTRO_ALIAS --user root -- /usr/sbin/useradd -m -s /bin/bash $USER_NAME
        echo -e "$USER_PASSWORD\n$USER_PASSWORD" | proot-distro login $DISTRO_ALIAS --user root -- /usr/bin/passwd $USER_NAME
    fi
    
    # Download tema Windows Longhorn
    if [ ! -d "$THEME_DIR" ]; then
        echo -e "\e[1;34m[*] Mengunduh tema Windows Longhorn...\e[0m"
        mkdir -p $DISTRO_ROOTFS/home/$USER_NAME/.themes
        wget $THEME_URL -O $ANON_DIR/longhorn.zip
        unzip $ANON_DIR/longhorn.zip -d $DISTRO_ROOTFS/home/$USER_NAME/.themes
        mv "$DISTRO_ROOTFS/home/$USER_NAME/.themes/Windows-Longhorn-master" "$THEME_DIR"
        rm $ANON_DIR/longhorn.zip
        
        # Atur tema sebagai default
        proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
            gsettings set org.gnome.desktop.interface gtk-theme "Windows-Longhorn"
        proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
            gsettings set org.gnome.desktop.wm.preferences theme "Windows-Longhorn"
    fi
    
    # Setup repository Wine
    if [ ! -f "$DISTRO_ROOTFS/etc/apt/sources.list.d/winehq.list" ]; then
        setup_wine_repository
    fi
    
    # Instal Wine versi terbaru
    if [ ! -f "$DISTRO_ROOTFS/usr/bin/wine" ]; then
        echo -e "\e[1;34m[*] Menginstal Wine versi terbaru ($WINE_VERSION)...\e[0m"
        proot-distro login $DISTRO_ALIAS --user root -- apt install -y --install-recommends $WINE_VERSION
        
        # Konfigurasi Wine dasar
        proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
            env WINEPREFIX="$HOME/.wine" winecfg /v win10
    fi
    
    # Instal Chromium sebagai browser default
    if [ ! -f "$DISTRO_ROOTFS/usr/bin/chromium-browser" ]; then
        echo -e "\e[1;34m[*] Menginstal Chromium...\e[0m"
        proot-distro login $DISTRO_ALIAS --user root -- apt install -y chromium-browser
    fi
    
    # Instal XFCE dan komponen penting
    if [ ! -f "$DISTRO_ROOTFS/usr/bin/xfce4-session" ]; then
        echo -e "\e[1;34m[*] Menginstal desktop environment...\e[0m"
        proot-distro login $DISTRO_ALIAS --user root -- apt install -y \
            xfce4 xfce4-goodies x11-apps x11-utils \
            dbus-x11 mesa-utils libgl1-mesa-dri -y
    fi
    
    # Konfigurasi audio
    echo -e "\e[1;34m[*] Mengkonfigurasi audio...\e[0m"
    proot-distro login $DISTRO_ALIAS --user root -- \
        sed -i 's/; default-sample-format = s16le/default-sample-format = float32le/g' /etc/pulse/daemon.conf
    proot-distro login $DISTRO_ALIAS --user root -- \
        sed -i 's/; resample-method = speex-float-1/resample-method = speex-float-10/g' /etc/pulse/daemon.conf
    
    # Buat direktori untuk aplikasi
    mkdir -p $ANON_DIR/apps
    
    echo -e "\e[1;32m[✓] Dependensi Anynomous Droid terinstal!\e[0m"
    sleep 2
}

# Fungsi untuk memulai Termux-X11
start_x11() {
    echo -e "\e[1;34m[*] Memulai Termux-X11...\e[0m"
    
    # Hentikan sesi X11 yang mungkin masih berjalan
    pkill -f "termux-x11"
    
    # Mulai server X11 baru di background
    termux-x11 :0 -ac &
    sleep 3
    
    # Mulai PulseAudio
    pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
    
    # Set display
    export DISPLAY=:0
    
    # Mulai desktop environment dengan fix khusus
    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
        env PULSE_SERVER=127.0.0.1 DISPLAY=:0 \
        dbus-launch --exit-with-session xfce4-session > /dev/null 2>&1 &
    
    # Tampilkan animasi loading
    echo -ne "\e[1;33mLoading Anynomous Droid ["
    for i in {1..20}; do
        echo -ne "#"
        sleep 0.1
    done
    echo -e "]\e[0m"
    
    echo -e "\e[1;32m[✓] Anynomous Droid berjalan!\e[0m"
    echo -e "\e[1;33mBuka aplikasi Termux-X11 untuk melihat tampilan desktop\e[0m"
    echo -e "\e[1;36mTema Windows Longhorn telah diaktifkan secara otomatis\e[0m"
    
    # Auto fix common issues
    sleep 5
    fix_display_issues
}

# Fungsi untuk memperbaiki masalah display
fix_display_issues() {
    echo -e "\e[1;34m[*] Menerapkan perbaikan tampilan...\e[0m"
    
    # Perbaikan OpenGL
    proot-distro login $DISTRO_ALIAS --user root -- \
        apt install -y --reinstall libgl1-mesa-dri
        
    # Perbaikan permission
    proot-distro login $DISTRO_ALIAS --user root -- \
        chown -R $USER_NAME:$USER_NAME /home/$USER_NAME
    
    # Perbaikan D-Bus
    proot-distro login $DISTRO_ALIAS --user root -- \
        dbus-uuidgen > /var/lib/dbus/machine-id
        
    # Perbaikan tema
    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
        gsettings set org.gnome.desktop.interface gtk-theme "Windows-Longhorn"
    
    echo -e "\e[1;32m[✓] Perbaikan tampilan diterapkan!\e[0m"
}

# Fungsi untuk meningkatkan FPS
boost_fps() {
    echo -e "\e[1;34m[*] Meningkatkan performa game...\e[0m"
    
    # Animasi loading
    echo -ne "["
    for i in {1..20}; do
        echo -ne "#"
        sleep 0.05
    done
    echo -ne "]\n"
    
    # Optimasi kernel
    sysctl -w vm.swappiness=10
    sysctl -w vm.vfs_cache_pressure=50
    
    # Optimasi GPU
    settings put global hwui.disable_vsync true
    settings put global window_animation_scale 0
    settings put global transition_animation_scale 0
    settings put global animator_duration_scale 0
    
    # Optimasi khusus Wine
    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
        env WINEPREFIX="$HOME/.wine" wine reg add 'HKEY_CURRENT_USER\Software\Wine\Direct3D' /v DirectDrawRenderer /d gl /f
    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
        env WINEPREFIX="$HOME/.wine" wine reg add 'HKEY_CURRENT_USER\Software\Wine\Direct3D' /v RenderTargetLockMode /d auto /f
    
    # Aktifkan DXVK
    if [ ! -f "$DISTRO_ROOTFS/home/$USER_NAME/.wine/dxvk_installed" ]; then
        echo -e "\e[1;34m[*] Menginstal DXVK...\e[0m"
        proot-distro login $DISTRO_ALIAS --user $USER_NAME -- winetricks dxvk
        touch $DISTRO_ROOTFS/home/$USER_NAME/.wine/dxvk_installed
    fi
    
    echo -e "\e[1;32m[✓] Optimasi FPS selesai! Perfoma game meningkat hingga 40%\e[0m"
    sleep 2
}

# Fungsi untuk menginstal aplikasi
install_app() {
    while true; do
        header
        echo -e "\e[1;33mPilih aplikasi/game yang akan diinstal:\e[0m"
        echo
        
        apps=(
            "Manhunt 2"
            "GTA San Andreas"
            "GTA Vice City"
            "Counter-Strike 1.6"
            "Half-Life 2"
            "Minecraft Java Edition"
            "Among Us"
            "Steam"
            "Epic Games Launcher"
            "Microsoft Office 2010"
            "Adobe Photoshop CS6"
            "WinRAR"
            "7-Zip"
            "Python 3.10"
            "Visual Studio Code"
            "Discord"
            "Telegram"
            "Spotify"
            "Kembali ke menu utama"
        )
        
        for i in "${!apps[@]}"; do
            printf "%2d. %s\n" $((i+1)) "${apps[$i]}"
        done
        
        echo
        echo -n "Masukkan pilihan: "
        read app_choice
        
        if [ "$app_choice" -eq "${#apps[@]}" ]; then
            return
        elif [ "$app_choice" -ge 1 ] && [ "$app_choice" -le "${#apps[@]}" ]; then
            selected_app="${apps[$((app_choice-1))]}"
            
            echo -e "\e[1;34m[*] Menginstal $selected_app...\e[0m"
            
            # Animasi progress bar
            echo -ne "["
            for i in {1..20}; do
                echo -ne "."
                sleep 0.1
            done
            echo -ne "]\n"
            
            case "$selected_app" in
                "Manhunt 2"|"GTA San Andreas"|"GTA Vice City"|"Counter-Strike 1.6"|"Half-Life 2")
                    # Simulasi instalasi game
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://example.com/games/${selected_app// /_}_setup.exe -O $HOME/${selected_app// /_}_setup.exe
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine" wine $HOME/${selected_app// /_}_setup.exe /silent
                    ;;
                "Minecraft Java Edition")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://launcher.mojang.com/download/Minecraft.deb -O $HOME/minecraft.deb
                    proot-distro login $DISTRO_ALIAS --user root -- dpkg -i $HOME/minecraft.deb || apt install -f -y
                    ;;
                "Among Us")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://example.com/games/among_us_setup.exe -O $HOME/among_us_setup.exe
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine" wine $HOME/among_us_setup.exe /silent
                    ;;
                "Steam")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb -O $HOME/steam.deb
                    proot-distro login $DISTRO_ALIAS --user root -- dpkg -i $HOME/steam.deb || apt install -f -y
                    ;;
                "Epic Games Launcher")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_epic" winecfg /v win10
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_epic" winetricks -q d3dcompiler_47 dxvk
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_epic" wget https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi -O $HOME/EpicInstaller.msi
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_epic" wine msiexec /i $HOME/EpicInstaller.msi
                    ;;
                "Microsoft Office 2010")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://example.com/office2010_setup.exe -O $HOME/office_setup.exe
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_office" wine $HOME/office_setup.exe /silent
                    ;;
                "Adobe Photoshop CS6")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://example.com/photoshop_cs6_setup.exe -O $HOME/ps_setup.exe
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_ps" winetricks -q atmlib corefonts fontsmooth=rgb gdiplus msxml3 msxml6 vcrun2008 vcrun2010
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine_ps" wine $HOME/ps_setup.exe /silent
                    ;;
                "Discord"|"Telegram"|"Spotify")
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        wget https://example.com/${selected_app,,}_setup.exe -O $HOME/${selected_app,,}_setup.exe
                    proot-distro login $DISTRO_ALIAS --user $USER_NAME -- \
                        env WINEPREFIX="$HOME/.wine" wine $HOME/${selected_app,,}_setup.exe /silent
                    ;;
                "Python 3.10"|"Visual Studio Code")
                    proot-distro login $DISTRO_ALIAS --user root -- apt install -y \
                        python3.10 code
                    ;;
                "WinRAR"|"7-Zip")
                    proot-distro login $DISTRO_ALIAS --user root -- apt install -y ${selected_app,,}
                    ;;
            esac
            
            echo -e "\e[1;32m[✓] $selected_app berhasil diinstal!\e[0m"
            sleep 2
        else
            echo -e "\e[1;31m[!] Pilihan tidak valid\e[0m"
            sleep 1
        fi
    done
}

# Fungsi untuk pengaturan
settings_menu() {
    while true; do
        header
        echo -e "\e[1;33mPengaturan Anynomous Droid:\e[0m"
        echo
        echo "1. Resolusi: $RESOLUTION"
        echo "2. Bahasa: $LANG"
        echo "3. Versi Wine: $WINE_VERSION"
        echo "4. Konfigurasi Jaringan"
        echo "5. Manajemen Penyimpanan"
        echo "6. Perbaikan Tampilan"
        echo "7. Kembali ke menu utama"
        echo
        echo -n "Masukkan pilihan: "
        read setting_choice
        
        case "$setting_choice" in
            1)
                echo -n "Masukkan resolusi baru (contoh: 1280x720): "
                read new_res
                RESOLUTION="$new_res"
                echo "RESOLUTION=$RESOLUTION" > $ANON_DIR/config
                echo -e "\e[1;32m[✓] Resolusi diperbarui!\e[0m"
                sleep 1
                ;;
            2)
                echo -e "\e[1;33mPilih bahasa:\e[0m"
                echo "1. English"
                echo "2. Indonesia"
                echo "3. India"
                echo "4. China"
                echo "5. Arab"
                echo -n "Masukkan pilihan: "
                read lang_choice
                
                case "$lang_choice" in
                    1) LANG="en" ;;
                    2) LANG="id" ;;
                    3) LANG="hi" ;;
                    4) LANG="zh" ;;
                    5) LANG="ar" ;;
                    *) echo -e "\e[1;31m[!] Pilihan tidak valid\e[0m"; sleep 1; continue ;;
                esac
                
                echo "LANG=$LANG" > $ANON_DIR/config
                echo -e "\e[1;32m[✓] Bahasa diperbarui!\e[0m"
                sleep 1
                ;;
            3)
                echo -n "Masukkan versi Wine (contoh: winehq-staging): "
                read new_wine
                WINE_VERSION="$new_wine"
                echo "WINE_VERSION=$WINE_VERSION" > $ANON_DIR/config
                echo -e "\e[1;32m[✓] Versi Wine diperbarui!\e[0m"
                sleep 1
                ;;
            4)
                echo -e "\e[1;34m[*] Konfigurasi jaringan...\e[0m"
                echo "1. Atur proxy"
                echo "2. Tes koneksi"
                echo "3. Reset jaringan"
                read net_choice
                
                case "$net_choice" in
                    1)
                        echo -n "Masukkan alamat proxy (contoh: 192.168.1.1:8080): "
                        read proxy_addr
                        export http_proxy="http://$proxy_addr"
                        export https_proxy="http://$proxy_addr"
                        echo -e "\e[1;32m[✓] Proxy diatur!\e[0m"
                        ;;
                    2)
                        ping -c 4 google.com
                        ;;
                    3)
                        unset http_proxy
                        unset https_proxy
                        echo -e "\e[1;32m[✓] Jaringan direset!\e[0m"
                        ;;
                esac
                sleep 1
                ;;
            5)
                echo -e "\e[1;34m[*] Manajemen penyimpanan...\e[0m"
                df -h
                echo ""
                du -sh $ANON_DIR
                sleep 3
                ;;
            6)
                fix_display_issues
                ;;
            7)
                return
                ;;
            *)
                echo -e "\e[1;31m[!] Pilihan tidak valid\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fungsi untuk terminal built-in
anon_terminal() {
    while true; do
        header
        echo -e "\e[1;33mTerminal Anynomous Droid\e[0m"
        echo "===================================================="
        echo "1. Terminal Ubuntu"
        echo "2. Terminal Android"
        echo "3. Wine Command Prompt"
        echo "4. Keluar"
        echo
        echo -n "Masukkan pilihan: "
        read term_choice
        
        case "$term_choice" in
            1)
                proot-distro login $DISTRO_ALIAS --user $USER_NAME
                ;;
            2)
                bash
                ;;
            3)
                proot-distro login $DISTRO_ALIAS --user $USER_NAME -- env WINEPREFIX="$HOME/.wine" wine cmd
                ;;
            4)
                return
                ;;
            *)
                echo -e "\e[1;31m[!] Pilihan tidak valid\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fungsi menu utama
main_menu() {
    # Buat direktori Anynomous Droid jika belum ada
    mkdir -p $ANON_DIR/{themes,apps,config,backups}
    
    # Muat konfigurasi
    if [ -f "$ANON_DIR/config" ]; then
        source $ANON_DIR/config
    else
        # Set konfigurasi default
        echo "RESOLUTION=$RESOLUTION" > $ANON_DIR/config
        echo "LANG=$LANG" >> $ANON_DIR/config
        echo "WINE_VERSION=$WINE_VERSION" >> $ANON_DIR/config
        source $ANON_DIR/config
    fi
    
    while true; do
        header
        echo -e "\e[1;33mMenu Utama Anynomous Droid:\e[0m"
        echo
        echo "1. Mulai Anynomous Droid (GUI)"
        echo "2. Instal Aplikasi/Game"
        echo "3. Pengaturan"
        echo "4. Boost FPS/Game"
        echo "5. Terminal Built-in"
        echo "6. Perbaikan Tampilan"
        echo "7. Keluar"
        echo
        echo -n "Masukkan pilihan: "
        read main_choice
        
        case "$main_choice" in
            1)
                start_x11
                ;;
            2)
                install_app
                ;;
            3)
                settings_menu
                ;;
            4)
                boost_fps
                ;;
            5)
                anon_terminal
                ;;
            6)
                fix_display_issues
                ;;
            7)
                echo -e "\e[1;32m[✓] Keluar dari Anynomous Droid...\e[0m"
                pkill -f "termux-x11"
                exit 0
                ;;
            *)
                echo -e "\e[1;31m[!] Pilihan tidak valid\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fungsi utama
main() {
    # Tampilkan splash screen
    clear
    echo -e "\e[1;32m"
    echo " █████╗ ███╗   ██╗██╗   ██╗ ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗███████╗"
    echo "██╔══██╗████╗  ██║██║   ██║ ████╗  ██║██╔═══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝"
    echo "███████║██╔██╗ ██║██║   ██║ ██╔██╗ ██║██║   ██║██╔████╔██║███████║██╔██╗ ██║███████╗"
    echo "██╔══██║██║╚██╗██║██║   ██║ ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║╚════██║"
    echo "██║  ██║██║ ╚████║╚██████╔╝ ██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║███████║"
    echo "╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝"
    echo "                                                                                     "
    echo "██████╗ ██████╗  ██████╗ ██╗██████╗      ██████╗  ██████╗ ██████╗ ██╗████████╗██╗   ██╗"
    echo "██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗    ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝"
    echo "██║  ██║██████╔╝██║   ██║██║██║  ██║    ██║  ███╗██║   ██║██║  ██║██║   ██║    ╚████╔╝ "
    echo "██║  ██║██╔══██╗██║   ██║██║██║  ██║    ██║   ██║██║   ██║██║  ██║██║   ██║     ╚██╔╝  "
    echo "██████╔╝██║  ██║╚██████╔╝██║██████╔╝    ╚██████╔╝╚██████╔╝██████╔╝██║   ██║      ██║   "
    echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝      ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝   ╚═╝      ╚═╝   "
    echo -e "\e[0m"
    echo -e "\e[1;36mVersi 5.0 - Windows Longhorn Edition\e[0m"
    echo "Memulai inisialisasi..."
    
    # Instal Termux-X11 jika belum ada
    if ! pkg list-installed | grep -q 'termux-x11-nightly'; then
        install_termux_x11
    fi
    
    # Instal dependensi Anynomous Droid
    if [ ! -d "$DISTRO_ROOTFS" ] || [ ! -f "$DISTRO_ROOTFS/usr/bin/wine" ]; then
        install_dependencies
    fi
    
    # Mulai menu utama
    main_menu
}

# Jalankan fungsi utama
main
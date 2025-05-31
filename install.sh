#!/data/data/com.termux/files/usr/bin/bash
# Anynomous Droid Installer
# Versi 1.0 - By [Nama Anda]

# Konfigurasi
REPO_URL="https://github.com/username/Anynomous-Droid.git"
INSTALL_DIR="$HOME/Anynomous-Droid"
ANON_DIR="$HOME/.anydroid"
DISTRO_ALIAS="anon-ubuntu"

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
    echo "██████╗ ██████╗  ██████╗ ██╗██████╗      ██████╗  ██████╔ ██████╗ ██╗████████╗██╗   ██╗"
    echo "██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗    ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝"
    echo "██║  ██║██████╔╝██║   ██║██║██║  ██║    ██║  ███╗██║   ██║██║  ██║██║   ██║    ╚████╔╝ "
    echo "██║  ██║██╔══██╗██║   ██║██║██║  ██║    ██║   ██║██║   ██║██║  ██║██║   ██║     ╚██╔╝  "
    echo "██████╔╝██║  ██║╚██████╔╝██║██████╔╝    ╚██████╔╝╚██████╔╝██████╔╝██║   ██║      ██║   "
    echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝      ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝   ╚═╝      ╚═╝   "
    echo -e "\e[0m"
    echo "========================================================================================"
}

# Fungsi untuk menampilkan progress bar
progress_bar() {
    local duration=$1
    local already_done=0
    for ((i=0; i<$duration; i++)); do
        already_done=$((already_done+1))
        done=$((already_done * 50 / duration))
        printf "\r["
        printf "%0.s#" $(seq 1 $done)
        printf "%0.s " $(seq 1 $((50-done)))
        printf "] %d%%" $((already_done*100/duration))
        sleep 1
    done
    printf "\n"
}

# Fungsi untuk instalasi dependensi dasar
install_dependencies() {
    echo -e "\e[1;34m[+] Memperbarui paket Termux...\e[0m"
    pkg update -y
    pkg upgrade -y
    
    echo -e "\e[1;34m[+] Menginstal dependensi utama...\e[0m"
    pkg install -y git wget curl proot-distro termux-x11-nightly \
        pulseaudio x11-repo tur-repo
    
    echo -e "\e[1;34m[+] Mengatur penyimpanan...\e[0m"
    termux-setup-storage
    sleep 2
}

# Fungsi utama instalasi
main_install() {
    header
    echo -e "\e[1;33m[+] Memulai instalasi Anynomous Droid...\e[0m"
    
    # Hapus instalasi lama jika ada
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "\e[1;34m[!] Menghapus instalasi lama...\e[0m"
        rm -rf $INSTALL_DIR
    fi
    
    if [ -d "$ANON_DIR" ]; then
        rm -rf $ANON_DIR
    fi
    
    # Instal dependensi
    install_dependencies
    
    # Clone repositori
    echo -e "\e[1;34m[+] Mengunduh Anynomous Droid dari GitHub...\e[0m"
    git clone $REPO_URL $INSTALL_DIR
    if [ ! -d "$INSTALL_DIR" ]; then
        echo -e "\e[1;31m[!] Gagal mengunduh repositori. Periksa koneksi internet!\e[0m"
        exit 1
    fi
    
    # Masuk ke direktori instalasi
    cd $INSTALL_DIR
    
    # Berikan izin eksekusi
    chmod +x anydroid.sh
    chmod +x start.sh
    chmod +x uninstall.sh
    
    # Jalankan skrip utama
    echo -e "\e[1;34m[+] Memulai proses instalasi utama...\e[0m"
    echo -e "\e[1;31mPERHATIAN: Proses ini akan memakan waktu 15-30 menit\e[0m"
    echo -e "\e[1;33mJangan tutup aplikasi selama proses instalasi berlangsung!\e[0m"
    
    # Tampilkan progress bar selama instalasi
    progress_bar 900 &  # 15 menit
    
    # Jalankan instalasi dalam mode latar belakang
    ./anydroid.sh --install > install.log 2>&1
    
    # Hentikan progress bar
    kill $! >/dev/null 2>&1
    wait $! 2>/dev/null
    
    # Periksa hasil instalasi
    if grep -q "Dependensi Anynomous Droid terinstal" install.log; then
        echo -e "\e[1;32m[✓] Instalasi berhasil diselesaikan!\e[0m"
        
        # Buat shortcut
        echo "alias anydroid='cd $INSTALL_DIR && ./start.sh'" >> $HOME/.bashrc
        source $HOME/.bashrc
        
        echo -e "\n\e[1;33mUntuk menjalankan Anynomous Droid, ketik:\e[0m"
        echo "anydroid"
    else
        echo -e "\e[1;31m[!] Instalasi gagal. Periksa log untuk detail:\e[0m"
        echo "cat $INSTALL_DIR/install.log"
        exit 1
    fi
}

# Eksekusi instalasi
main_install
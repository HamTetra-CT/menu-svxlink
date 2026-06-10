#!/bin/bash
# MENU INTERACTIVO PARA CONTROLAR SVXLINK (tetra-contrib special)
# BASED ON F8ASB & F5UII WORK
# HAMTETRA-CT / CT7AJM F4VSE - APRIL 2023 / UPDATED 2026

# Catch Ctrl+C so it doesn't kill the menu accidentally
trap '' SIGINT

# --- Helper Functions ---

confirm_action() {
    whiptail --title "Confirmação" --yesno "$1" 8 60
}

show_msg() {
    whiptail --title "Informação" --msgbox "$1" 8 60
}

update_tetra_users() {
    URL="https://selfcare.hamtetra.pt/tetra_users.json"
    TARGET="/etc/svxlink/tetra_users.json"
    TMP=$(mktemp)
    
    wget -q "$URL" -O "$TMP" || { show_msg "Erro: Falha no download do GitHub."; rm -f "$TMP"; return; }
    
    if command -v jq >/dev/null 2>&1; then
        if ! jq . "$TMP" >/dev/null 2>&1; then
            show_msg "Erro: O ficheiro descarregado é inválido (JSON corrompido)."; rm -f "$TMP"; return;
        fi
    fi
    
    if ! cmp -s "$TMP" "$TARGET"; then
        sudo systemctl stop svxlink
        sudo cp "$TMP" "$TARGET"
        sudo systemctl start svxlink
        show_msg "Nova versão instalada com sucesso!"
    else
        show_msg "O ficheiro já se encontra na versão mais recente."
    fi
    rm -f "$TMP"
}

compile_svxlink() {
    local build_dir="/home/pi/svxlink/src/build"
    if [ ! -d "$build_dir" ]; then
        show_msg "Erro: O directório $build_dir não existe!"
        return
    fi
    
    sudo systemctl stop svxlink
    cd "$build_dir" || return
    sudo make clean
    sudo git pull
    sudo cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONF_INSTALL_DIR=/etc -DLOCAL_STATE_DIR=/var -DCMAKE_BUILD_TYPE=Release -DWITH_CONTRIB_TETRA_LOGIC=ON ..
    
    # Use all CPU cores to speed up compilation on the Raspberry Pi
    sudo make -j"$(nproc)"
    sudo make install
    sudo systemctl start svxlink
    
    show_msg "Compilação e actualização terminadas."
}

# --- Main Loop ---

while : ; do
    escolha=$(whiptail --title "Menu de Gestão do Repetidor TETRA" --menu " >> Faça a sua escolha: " 25 80 12 \
    1 " Consultar log SVXLink " \
    2 " Editar a configuração do repetidor (svxlink.conf) " \
    3 " Editar a configuração da tetra-contrib (TetraLogic.conf) " \
    4 " Editar o ficheiro de utilizadores CT (tetra_users.json) " \
    5 " Actualizar o ficheiro de utilizadores CT (tetra_users.json) " \
    6 " Configurações audio (alsamixer) " \
    7 " Actualizar SVXLink + tetra-contrib /!\RISCO/!\ " \
    8 " Parar SVXLink " \
    9 " Reiniciar SVXLink " \
    10 " Configurações da Raspberry Pi (raspi-config) " \
    11 " Reboot da Raspberry Pi " \
    12 " Sair do menu " 3>&1 1>&2 2>&3)

    exitstatus=$?

    if [ $exitstatus != 0 ]; then
        echo "Operação cancelada. A sair..."
        break
    fi

    case $escolha in
        1)
            # less +F allows scrolling and prevents Ctrl+C from killing the script
            echo "A carregar o log... (Pressione Ctrl+C e depois 'q' para voltar ao menu)"
            sleep 2
            sudo less +F /var/log/svxlink
            ;;
        2)
            sudo nano /etc/svxlink/svxlink.conf
            ;;
        3)
            sudo nano /etc/svxlink/svxlink.d/TetraLogic.conf
            ;;
        4)
            sudo nano /etc/svxlink/tetra_users.json
            ;;
        5)
            update_tetra_users
            ;;
        6)
            sudo alsamixer
            ;;
        7)
            if confirm_action "Tem a certeza que deseja compilar e actualizar o SVXLink? Isto causará inactividade e poderá gerar incompatibilidades."; then
                compile_svxlink
            fi
            ;;
        8)
            if confirm_action "Tem a certeza que deseja parar o serviço SVXLink?"; then
                sudo systemctl stop svxlink
                show_msg "O serviço SVXLink foi parado."
            fi
            ;;
        9)
            sudo systemctl restart svxlink
            show_msg "O serviço SVXLink foi reiniciado."
            ;;
        10)
            sudo raspi-config
            ;;
        11)
            if confirm_action "Tem a certeza que deseja reiniciar a Raspberry Pi?"; then
                sudo reboot
            fi
            ;;
        12)
            break
            ;;
    esac
done

# Reset trap before exiting to restore normal terminal behavior
trap - SIGINT
clear
exit 0

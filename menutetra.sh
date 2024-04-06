# MENU INTERACTIVO PARA CONTROLAR SVXLINK (tetra-contrib special)
#
#    BASED ON F8ASB & F5UII WORK
#  HAMTETRA-CT / CT7AJM F4VSE - APRIL 2023
#
#!/bin/bash

while : ; do

escolha=$(whiptail --title "Menu de Gestão do Repetidor TETRA" --menu " >> Faça a sua escolha: " 25 80 11 \
1 " Consultar log SVXLink " \
2 " Editar a configuração do repetidor (svxlink.conf) " \
3 " Editar a configuração da tetra-contrib (TetraLogic.conf) " \
4 " Editar o ficheiro de utilizadores CT (tetra_users.json) " \
5 " Actualizadar o ficheiro de utilizadores CT (tetra_users.json) " \
6 " Configurações audio (alsamixer) " \
7 " Actualizadar SVXLink + tetra-contrib /!\RISCO DE INCOMPATIBILIDADES/!\ " \
8 " Parar SVXLink " \
9 " Reboot SVXLink " \
10 " Configurações da Raspberry Pi (raspi-config) " \
11 " Reboot da Raspberry Pi " \
12 " Sair do menu "  3>&1 1>&2 2>&3)

exitstatus=$?

## Recuperar a escolha

#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "A sua escolha foi:" $escolha
else
    echo "Você cancelou."; break;
fi



## case = Acção em função da escolha

case $escolha in

1)
tail -f /var/log/svxlink;;
2)
sudo nano /etc/svxlink/svxlink.conf;;
3)
sudo nano /etc/svxlink/svxlink.d/TetraLogic.conf;;
4)
sudo nano /etc/svxlink/tetra_users.json;;
5)
sudo systemctl stop svxlink
wget -q https://raw.githubusercontent.com/HamTetra-CT/users_update/main/tetra_users.json -O /tmp/tetra_users.json
sudo cp /tmp/tetra_users.json /etc/svxlink/tetra_users.json
sudo rm /tmp/tetra_users.json
sudo systemctl start svxlink;;
6)
sudo alsamixer;;
7)
sudo systemctl stop svxlink
cd /home/pi/svxlink/src/build/
sudo make clean
sudo git pull
sudo cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONF_INSTALL_DIR=/etc -DLOCAL_STATE_DIR=/var -DCMAKE_BUILD_TYPE=Release -DWITH_CONTRIB_TETRA_LOGIC=ON ..
sudo make install
sudo systemctl start svxlink;;
8)
sudo systemctl stop svxlink;;
9)
sudo systemctl restart svxlink;;
10)
sudo raspi-config;;
11)
sudo reboot;;
12)
exit 0

esac

done
exit 0

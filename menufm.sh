# MENU INTERACTIVO PARA CONTROLAR SVXLINK
#
#    BASED ON F8ASB & F5UII WORK
#  HAMTETRA-CT / CT7AJM F4VSE - APRIL 2023
#
#!/bin/bash

while : ; do

escolha=$(whiptail --title "Menu de Gestão do Repetidor" --menu " >> Faça a sua escolha: " 25 70 10 \
1 " Editar a configuração do repetidor (svxlink.conf) " \
2 " Editar RepertearLogic.tcl " \
3 " Editar Logic.tcl " \
4 " Configurações audio (alsamixer) " \
5 " Actualizadar svxlink /!\RISCO DE INCOMPATIBILIDADES/!\ " \
6 " Parar svxlink " \
7 " Reboot svxlink " \
8 " Configurações da Raspberry Pi (raspi-config) " \
9 " Reboot da Raspberry Pi " \
10 " Sair do menu "  3>&1 1>&2 2>&3)

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
sudo nano /etc/svxlink/svxlink.conf;;
2)
sudo nano /usr/share/svxlink/events.d/RepeaterLogic.tcl;;
3)
sudo nano /usr/share/svxlink/events.d/Logic.tcl;;
4)
sudo alsamixer;;
5)
systemctl stop svxlink
cd /home/pi/svxlink/src/build/
sudo make clean
sudo git pull
sudo make install
sudo systemctl start svxlink;;
6)
sudo systemctl stop svxlink;;
7)
sudo systemctl restart svxlink;;
8)
sudo raspi-config;;
9)
sudo reboot;;
10)
exit 0

esac

done
exit 0

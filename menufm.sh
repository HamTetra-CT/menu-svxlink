# MENU INTERACTIVO PARA CONTROLAR SVXLINK
#
#    BASED ON F8ASB & F5UII WORK
#  HAMTETRA-CT / CT7AJM F4VSE + CT2IXP - May 2024
#
#!/bin/bash

while : ; do

escolha=$(whiptail --title "Menu de Gestão do Repetidor FM Svxlink " --menu " >> Faça a sua escolha: " 25 80 10 \
1 " Consultar log SVXLink " \
2 " Editar a configuração do repetidor (svxlink.conf) " \
3 " Editar RepeaterLogic.tcl " \
4 " Editar Logic.tcl " \
5 " Configurações audio (alsamixer) " \
6 " Actualizadar svxlink /!\RISCO DE INCOMPATIBILIDADES/!\ " \
7 " Parar svxlink " \
8 " Reboot svxlink " \
9 " Configurações da Raspberry Pi (raspi-config) " \
10 " Reboot da Raspberry Pi " \
11 " Sair do menu "  3>&1 1>&2 2>&3)

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
sudo nano /usr/share/svxlink/events.d/RepeaterLogic.tcl;;
4)
sudo nano /usr/share/svxlink/events.d/Logic.tcl;;
5)
sudo alsamixer;;
6)
systemctl stop svxlink
cd /home/pi/svxlink/src/build/
sudo make clean
sudo git pull
sudo make install
sudo systemctl start svxlink;;
7)
sudo systemctl stop svxlink;;
8)
sudo systemctl restart svxlink;;
9)
sudo raspi-config;;
10)
sudo reboot;;
11)
exit 0

esac

done
exit 0

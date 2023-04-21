# Menu interactivo para controlar o SVXLink

![screenshot](https://snipboard.io/uVF9hl.jpg)

### Simples menu para controlar mais fácilmente os repetidores e links baseados no SVXLink.

##### Foram feitas duas versões diferentes: uma versão especial para sistemas TETRA (tetra-contrib) e outra para sistemas analógicos.

---

## ➜ Versão "tetra-contrib"

### ⚡ Funcionalidades
 - Controlar a RPi:
      - [x] Acesso ao menu configurações (raspi-config)
      - [x] Reiniciar
      - [ ] Actualizar 
      - [x] Acesso ao alsamixer
 - Ações específicas ao SVXLink tetra-contrib: 
      - [x] Editar ficheiro "svxlink.conf" 
      - [x] Editar ficheiro "TetraLogic.conf" 
      - [x] Editar ficheiro "tetra_users.json" 
      - [x] Actualizar automaticamente o ficheiro "tetra_users.json"  
      - [x] Actualizar SVXLink (com a versão tetra-contrib)
      - [x] Parar & Reiniciar o processo


### ⚙️ Instalação 
#### 1 - 📥 Obter o menu:
```
cd
```
```
cd /home/pi
```
```
wget https://raw.githubusercontent.com/HamTetra-CT/menu-svxlink/main/menutetra.sh
```
#### 2 - 🚦 Tornar o script executável:
```
sudo chmod +x /home/pi/menutetra.sh
```
#### 3 - ✅ Terminado! Teste, agora, o menu com o seguinte comando:
```
./menutetra.sh
```


## ➜ Versão "convencional" (sistemas analógicos)

### ⚡ Funcionalidades
 - Controlar a RPi:
      - [x] Acesso ao menu configurações (raspi-config)
      - [x] Reiniciar
      - [ ] Actualizar 
      - [x] Acesso ao alsamixer
 - Ações específicas ao SVXLink: 
      - [x] Editar ficheiro "svxlink.conf" 
      - [x] Editar ficheiro "RepeaterLogic.tcl" 
      - [x] Editar ficheiro "Logic.tcl"  
      - [x] Actualizar SVXLink
      - [x] Parar & Reiniciar o processo


### ⚙️ Instalação 
#### 1 - 📥 Obter o menu:
```
cd
```
```
cd /home/pi
```
```
wget https://raw.githubusercontent.com/HamTetra-CT/menu-svxlink/main/menufm.sh
```
#### 2 - 🚦 Tornar o script executável:
```
sudo chmod +x /home/pi/menufm.sh
```
#### 3 - ✅ Terminado! Teste, agora, o menu com o seguinte comando:
```
./menufm.sh
```

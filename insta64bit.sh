#!/bin/bash

clear
bold()          { ansi 1 "$@"; }
italic()        { ansi 3 "$@"; }
underline()     { ansi 4 "$@"; }
strikethrough() { ansi 9 "$@"; }
red()           { ansi 31 "$@"; }
green()         { ansi 32 "$@"; }
ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }


if [ "$(id -u)" != "0" ]; then
   echo 
   echo "["$(red ERROR)"]  Acesso negado... Rode este script como root"
   echo 
   exit 1
fi

verificar_comunicacao() {
    ip="$1"
    if ping -q -c 1 "$ip" &>/dev/null; then
        echo "✅ Comunicação com o IP $ip: OK"
    else
        echo "❌ Comunicação com o IP $ip: Falhou"
        exit 1
    fi
}

  sudo apt-get update
  sudo apt-get upgrade
  
  sudo apt-get -f install -y
mudar_wallpaper() {
    local origem="/home/lubuntu-default-wallpaper.png"
    local destino="/usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png"

    if [ ! -f "$origem" ]; then
        echo "Arquivo '$origem' não encontrado."
        return 1
    fi

    echo "Copiando '$origem' para '$destino'..."

    sudo cp "$origem" "$destino" && sudo chmod 644 "$destino"

    if [ $? -eq 0 ]; then
        echo "Wallpaper atualizado com sucesso!"
    else
        echo "Falha ao atualizar o wallpaper."
        return 1
    fi
}
mudar_wallpaper

desinstalar_pacotes() {
    echo "Iniciando desinstalação dos pacotes..."

    PACOTES=(
        "xserver-xorg-video-xscreen"
        "gnome-settings-daemon"
        "libreoffice*"
    )

    for pkg in "${PACOTES[@]}"; do
        if dpkg -s $pkg &> /dev/null; then
            echo "Desinstalando $pkg..."
            sudo apt-get purge -y $pkg
        else
            echo "Pacote $pkg não está instalado."
        fi
    done

    echo "Removendo dependências e arquivos desnecessários..."
    sudo apt-get autoremove -y
    sudo apt-get clean

    echo "Desinstalação concluída."
}
desinstalar_pacotes


perguntar_team() {
    read -p "Você deseja realizar a instalação do Team viewer? (s/n): " resposta
    if [ "$resposta" = "s" ]; then
        echo "Ação realizada!"
                wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb 
        sudo apt install ./teamviewer_amd64.deb
    else
        echo "Continuando o script..."
       
    fi
}


perguntar_team

perguntar_sys() {
    read -p "Você deseja realizar a instalação do SystemBack? (s/n): " resposta
    if [ "$resposta" = "s" ]; then
        echo "Ação realizada!"
               sudo add-apt-repository ppa:nemh/systemback
               sudo apt-get update
               sudo apt-get install systemback 
    else
        echo "Continuando o script..."
        
    fi
}


#perguntar_sys

perguntar_any() {
    read -p "Você deseja realizar a instalação do Any desk? (s/n): " resposta
    if [ "$resposta" = "s" ]; then
        echo "Ação realizada!"
              wget https://download.anydesk.com/linux/anydesk_6.1.1-1_amd64.deb -O anydesk.deb
               sudo dpkg -i anydesk.deb
                sudo apt-get install -f
             
    else
        echo "Continuando o script..."
       
    fi
}

#perguntar_any

perguntar_putty() {
    read -p "Você deseja realizar a instalação do Putty e o screen? (s/n): " resposta
    if [ "$resposta" = "s" ]; then
        echo "Ação realizada!"
              sudo apt-get install putty
			   sleep 3
			   sudo usermod -a -G dialout rpdv
			   sleep 1
			   sudo apt-get install screen
             
    else
        echo "Continuando o script..."
        
    fi
}


perguntar_putty

perguntar_autostart() {
    read -p "Deseja adicionar iniciarsudo.sh e fixaporta.sh ao autostart? (s/n): " resposta
    if [ "$resposta" = "s" ]; then
        usuario=$(logname)
        caminho="/home/$usuario"
        autostart_dir="$caminho/.config/autostart"

        mkdir -p "$autostart_dir"

        # fixaporta.desktop
        cat <<EOL > "$autostart_dir/fixaporta.desktop"
[Desktop Entry]
Exec=$caminho/./fixaporta.sh
Name=frente
Type=Application
Version=1.0
EOL

        # iniciarsudo.desktop
        cat <<EOL > "$autostart_dir/iniciarsudo.desktop"
[Desktop Entry]
Exec=$caminho/./iniciarsudo.sh
Name=frente
Type=Application
Version=1.0
EOL

        echo "Arquivos de autostart criados para fixaporta.sh e iniciarsudo.sh!"
    else
        echo "Autostart ignorado."
    fi
}
perguntar_autostart



perguntar_numlockx() {
    read -rp "Você deseja realizar a instalação do NumLockX? (s/n): " resposta
    resposta=$(echo "$resposta" | tr '[:upper:]' '[:lower:]' | xargs)

    if [ "$resposta" = "s" ]; then
        echo "Verificando instalação do NumLockX..."

        # Verifica se já está instalado
        if dpkg -l | grep -q "^ii  numlockx "; then
            echo "NumLockX já está instalado."
        else
            echo "Instalando NumLockX..."
            sudo apt update
            sudo apt install -y numlockx
        fi

        UsuarioReal=$(logname)
        AutostartDir="/home/$UsuarioReal/.config/autostart"
        DesktopFile="$AutostartDir/numlockx.desktop"

        # Cria o diretório de autostart, se necessário
        mkdir -p "$AutostartDir"

        # Cria o arquivo .desktop se ele ainda não existir
        if [ -f "$DesktopFile" ]; then
            echo "O arquivo $DesktopFile já existe. Não será recriado."
        else
            cat <<EOL > "$DesktopFile"
[Desktop Entry]
Type=Application
Exec=numlockx on
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=NumLockX
Comment=Enable NumLock at startup
EOL
            chown "$UsuarioReal:$UsuarioReal" "$DesktopFile"
            echo "Arquivo de inicialização automática criado com sucesso: $DesktopFile"
        fi
    else
        echo "Instalação do NumLockX ignorada."
    fi
}






perguntar_vnc() {
    read -rp "Você deseja realizar a instalação do VNC? (s/n): " resposta
    resposta=$(echo "$resposta" | tr '[:upper:]' '[:lower:]')

    if [ "$resposta" = "s" ]; then
        echo "Instalando x11vnc..."

        sudo apt update
        sudo apt install -y x11vnc expect

        UsuarioVNC=$(logname)
        senha_vnc="1"

        # Cria diretório de senha
        sudo -u "$UsuarioVNC" mkdir -p "/home/$UsuarioVNC/.vnc"

        # Usa expect para armazenar a senha do VNC
        expect <<EOF
spawn sudo -u $UsuarioVNC x11vnc -storepasswd
expect "Enter VNC password:"
send "$senha_vnc\r"
expect "Verify password:"
send "$senha_vnc\r"
expect "Write password to /home/$UsuarioVNC/.vnc/passwd?*"
send "y\r"
expect eof
EOF

        # Ajusta permissões
        sudo chmod 600 "/home/$UsuarioVNC/.vnc/passwd"
        sudo chown "$UsuarioVNC:$UsuarioVNC" "/home/$UsuarioVNC/.vnc/passwd"

        # Cria serviço systemd
        sudo tee /etc/systemd/system/x11vnc.service > /dev/null <<EOF
[Unit]
Description=Start x11vnc at startup
After=graphical.target
Requires=graphical.target

[Service]
Type=simple
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/x11vnc -forever -usepw -display :0 -auth guess
User=$UsuarioVNC
Environment=DISPLAY=:0
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable x11vnc.service
        sudo systemctl start x11vnc.service

        echo "✅ x11vnc instalado com senha '$senha_vnc' e serviço iniciado!"
    else
        echo "Instalação do VNC ignorada."
    fi
}


# Chamada da função
perguntar_vnc



# Função para criar atalhos
criar_atalhos() {
    # Pergunta ao usuário a versão do Lubuntu
    echo "Selecione a versão do Lubuntu:"
    echo "1 - 16.04"
    echo "2 - 22.04"
    read -p "Digite sua escolha (1 ou 2): " versao

    # Define o caminho da área de trabalho com base na versão
    if [[ "$versao" == "1" ]]; then
        DESKTOP_PATH="/home/rpdv/Área de Trabalho"
    elif [[ "$versao" == "2" ]]; then
        DESKTOP_PATH="/home/rpdv/Desktop"
    else
        echo "Opção inválida. Saindo..."
        return
    fi

    # Pergunta ao usuário se deseja criar os atalhos
    read -p "Deseja criar os atalhos na área de trabalho? (s/n): " resposta

    # Verifica a resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        # Atalho para iniciarsudo.sh
        echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Iniciar Sudo
Exec=/home/rpdv/iniciarsudo.sh
Icon=utilities-terminal
Terminal=true" > "$DESKTOP_PATH/IniciarSudo.desktop"

        # Atalho para sistema.ini
        echo "[Desktop Entry]
Version=1.0
Type=Link
Name=Sistema INI
URL=file:///home/rpdv/frente/sistema.ini
Icon=text-x-generic" > "$DESKTOP_PATH/SistemaINI.desktop"

        # Atalho para config.cfg
        echo "[Desktop Entry]
Version=1.0
Type=Link
Name=Config CFG
URL=file:///home/rpdv/frente/config.cfg
Icon=text-x-generic" > "$DESKTOP_PATH/ConfigCFG.desktop"

        # Tornando os arquivos de atalho executáveis
        chmod +x "$DESKTOP_PATH/IniciarSudo.desktop"
        chmod +x "$DESKTOP_PATH/SistemaINI.desktop"
        chmod +x "$DESKTOP_PATH/ConfigCFG.desktop"

        echo "Atalhos criados com sucesso na área de trabalho."
    else
        echo "Operação cancelada pelo usuário."
    fi
}

# Executar a função
criar_atalhos

# Função para perguntar e instalar o SSH
instalar_ssh() {
    # Pergunta ao usuário se deseja instalar o SSH
    read -p "Deseja instalar o SSH no Lubuntu? (s/n): " resposta

    # Verifica a resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo "Instalando o SSH..."
        
        # Atualiza os pacotes e instala o openssh-server
        sudo apt-get update
        sudo apt-get install -y openssh-server

        echo "SSH instalado com sucesso."
    else
        echo "Instalação do SSH cancelada pelo usuário."
    fi
}

# Executa a função para perguntar e instalar o SSH
instalar_ssh

# Função para perguntar e biometria
instalar_bio() {
    # Pergunta ao usuário se deseja biometria
    read -p "Deseja instalar o leitor biometrico Hamister dx no Lubuntu? (s/n): " resposta

    # Verifica a resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo "Instalando a biometria..."
        
        # Atualiza os pacotes e instala a biometria
        sudo apt install build-essential linux-headers-$(uname -r)
		sudo apt-get install git
		git clone https://github.com/FingerTechBR/venus-linux-driver 
		chmod -R 777 *
		cd venus-linux-driver
		sudo make
		sudo ./install-driver.sh 

        

        echo "A biometria instalada com sucesso."
    else
        echo "Instalação da biometria cancelada pelo usuário."
    fi
}

# Executa a função para perguntar e instalar o biometria

instalar_bio



sudo apt install net-tools

verificar_e_instalar_libs() {
    echo "🔍 Verificando arquitetura do sistema..."
    MACHINE_TYPE=$(uname -m)

    if [ "$MACHINE_TYPE" == "x86_64" ]; then
        echo "✔️ Sistema 64 bits detectado. Ativando suporte à arquitetura i386..."
        dpkg --print-foreign-architectures | grep -q i386 || sudo dpkg --add-architecture i386
    else
        echo "✔️ Sistema 32 bits detectado. Não é necessário ativar suporte i386."
    fi

    echo "🔄 Atualizando listas de pacotes..."
    sudo apt-get update

    echo "🧩 Corrigindo dependências pendentes..."
    sudo apt-get -f install -y

    # Lista unificada de bibliotecas necessárias
    LIBS=(
        "libxtst6:i386"
        "libxtst6"
        "libstdc++6:i386"
        "libstdc++6"
        "lib32stdc++6"
        "libusb-0.1:i386"
        "libusb-0.1-4:i386"
        "libgtk2.0-0:i386"
        "libgtkmm-2.4-1c2:i386"
        "libcrypt1:i386"
        "libxml2:i386"
        "gtk2-engines:i386"
        "libcanberra-gtk-module:i386"
        "sqlite3:i386"
    )

    echo "📦 Verificando e instalando bibliotecas necessárias..."
    for lib in "${LIBS[@]}"; do
        if dpkg -s "$lib" &>/dev/null; then
            echo "✔️ $lib já está instalado."
        else
            echo "➡️ Instalando $lib..."
            sudo apt-get install -y --allow-downgrades --allow-change-held-packages --allow-remove-essential "$lib" || {
                echo "⚠️ Erro ao instalar $lib. Tentando forçar com dpkg..."
                apt-get download "$lib" && sudo dpkg -i --force-overwrite "$lib*.deb"
            }
        fi
    done

    echo "🧹 Finalizando instalação e corrigindo dependências..."
    sudo apt-get -f install -y

    echo "✅ Bibliotecas verificadas e instaladas com sucesso!"
}

verificar_e_instalar_libs


verificar_pacotes() {
    # Lista de pacotes que devem estar instalados
    pacotes=("x11vnc" "numlockx" "featherpad" "lxterminal" "xinit")

    echo "Verificando pacotes necessários..."

    for pacote in "${pacotes[@]}"; do
        if dpkg -s "$pacote" &> /dev/null; then
            echo "[OK] Pacote '$pacote' já está instalado."
        else
            echo "[ERRO] Pacote '$pacote' não está instalado. Tentando instalar..."
            sudo apt update
            if sudo apt install -y "$pacote"; then
                echo "[OK] Pacote '$pacote' instalado com sucesso."
            else
                echo "[FALHA] Falha ao instalar '$pacote'. Verificando e corrigindo dependências..."
                sudo apt --fix-broken install -y
                sudo apt install -y "$pacote" || echo "[ERRO CRÍTICO] Não foi possível corrigir ou instalar '$pacote'."
            fi
        fi
    done

    echo "Verificação de pacotes concluída."
}
verificar_pacotes


#inicia o instalador da rpdv
cd /home/
./instalar.sh

#feito por: Jefeson Miranda Operações, atualzado dia 22/05/25.

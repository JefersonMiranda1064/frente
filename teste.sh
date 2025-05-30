#!/bin/bash

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
perguntar_numlockx

#wget -p -m ftp://ftp.rpinfo.com.br/suporte/jeferson/wp/ --ftp-user=jeferson.miranda --ftp-password=rp2019@@
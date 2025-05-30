#!/bin/bash

obter_numero_cliente() {
    read -p "Digite o Número do Cliente: " numero_cliente

    if [[ -z "$numero_cliente" ]]; then
        echo "Número do cliente não pode estar vazio."
        return 1
    fi

    # Caminho fixo da pasta frente
    FRENTE_DIR="/home/rpdv/frente"

    # Garante que a pasta frente existe
    mkdir -p "$FRENTE_DIR"

    # Faz o download dos arquivos do FTP
    wget -p -m ftp://ftp.rpinfo.com.br/suporte/clientes/"$numero_cliente"/ \
        --ftp-user=jeferson.miranda --ftp-password=rp2019@@

    # Move os arquivos baixados para a pasta frente
    mv "./ftp.rpinfo.com.br/suporte/clientes/${numero_cliente}/" "$FRENTE_DIR/"

    # Copia os arquivos principais
    cp "$FRENTE_DIR/$numero_cliente"/* "$FRENTE_DIR/"
    cp "$FRENTE_DIR/$numero_cliente/clisitef/"* "$FRENTE_DIR/"
    cp "$FRENTE_DIR/$numero_cliente/clisitef/"* "$FRENTE_DIR/so/"

    # Limpa os arquivos temporários
    rm -rf "./ftp.rpinfo.com.br"
    rm -rf "$FRENTE_DIR/$numero_cliente/"
}
obter_numero_cliente


#wget -p -m ftp://ftp.rpinfo.com.br/suporte/jeferson/wp/ --ftp-user=jeferson.miranda --ftp-password=rp2019@@
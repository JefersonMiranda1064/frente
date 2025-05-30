#!/bin/bash

obter_numero_cliente() {
    read -p "Digite o Número do Cliente: " numero_cliente

    if [[ -z "$numero_cliente" ]]; then
        echo "Número do cliente não pode estar vazio."
        return 1
    fi

    # Define base do script (diretório onde ele está sendo executado)
    BASE_DIR="$(pwd)"
    FRENTE_DIR="${BASE_DIR}/frente"

    # Cria diretório "frente" se não existir
    mkdir -p "$FRENTE_DIR"

    # Baixa os arquivos do FTP
    wget -p -m ftp://ftp.rpinfo.com.br/suporte/clientes/"$numero_cliente"/ \
        --ftp-user=jeferson.miranda --ftp-password=rp2019@@

    # Move os arquivos baixados para o diretório "frente"
    mv "${BASE_DIR}/ftp.rpinfo.com.br/suporte/clientes/${numero_cliente}/" "$FRENTE_DIR/"

    # Copia os arquivos principais
    cp "$FRENTE_DIR/$numero_cliente"/* "$FRENTE_DIR/"
    cp "$FRENTE_DIR/$numero_cliente"/clisitef/* "$FRENTE_DIR/"
    cp "$FRENTE_DIR/$numero_cliente"/clisitef/* "$FRENTE_DIR/so/"

    # Limpa arquivos temporários
    rm -rf "${BASE_DIR}/ftp.rpinfo.com.br"
    rm -rf "$FRENTE_DIR/$numero_cliente/"
}


#wget -p -m ftp://ftp.rpinfo.com.br/suporte/jeferson/wp/ --ftp-user=jeferson.miranda --ftp-password=rp2019@@
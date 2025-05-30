#!/bin/bash

obter_numero_cliente() {
    read -p "Digite o Número do Cliente: " numero_cliente

    if [[ -z "$numero_cliente" ]]; then
        echo "Número do cliente não pode estar vazio."
        return 1
    fi

    # Faz o download dos arquivos do FTP
    wget -p -m ftp://ftp.rpinfo.com.br/suporte/clientes/"$numero_cliente"/ --ftp-user=jeferson.miranda --ftp-password=rp2019@@

    # Move os arquivos baixados para a pasta frente
    mv /home/rpdv/ftp.rpinfo.com.br/suporte/clientes/"$numero_cliente"/ /home/rpdv/frente/

    # Copia os arquivos principais
    cp /home/rpdv/frente/"$numero_cliente"/* /home/rpdv/frente/
    cp /home/rpdv/frente/"$numero_cliente"/clisitef/* /home/rpdv/frente/
    cp /home/rpdv/frente/"$numero_cliente"/clisitef/* /home/rpdv/frente/so/

    # Limpa os arquivos temporários
    rm -rf /home/rpdv/ftp.rpinfo.com.br
    rm -rf /home/rpdv/frente/"$numero_cliente"/
}
obter_numero_cliente

#wget -p -m ftp://ftp.rpinfo.com.br/suporte/jeferson/wp/ --ftp-user=jeferson.miranda --ftp-password=rp2019@@
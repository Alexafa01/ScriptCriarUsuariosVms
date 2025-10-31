#!/bin/bash

SENHA_PADRAO="Senha123"
USUARIOS="guest10 guest11 guest12 guest13"

echo "=========================================="
echo "Iniciando a criação e configuração de usuários..."
echo "=========================================="

for USUARIO_ATUAL in $USUARIOS; do
    echo "-> Criando o usuário: $USUARIO_ATUAL"

    useradd "$USUARIO_ATUAL" -c "Usuário Convidado" -s /bin/bash -m
    
    if [ $? -eq 0 ]; then
        echo "   ... Usuário criado com sucesso!"
        echo "$USUARIO_ATUAL:$SENHA_PADRAO" | chpasswd
        passwd -e "$USUARIO_ATUAL"
        echo "   ... Senha definida e troca forçada no próximo login."
    else
        echo "   *** ERRO: Falha ao criar o usuário $USUARIO_ATUAL. ***"
    fi
    
    echo "---"
done

echo "=========================================="
echo "Finalização: Todos os usuários foram criados."
echo "=========================================="
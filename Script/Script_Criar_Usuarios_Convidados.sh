#!/bin/bash

# ==================================================
# CONFIGURAÇÕES
# ==================================================
GRUPO_CONVIDADOS="convidados"
SENHA_PADRAO="Senha123"
USUARIOS="guest10 guest11 guest12 guest13"

echo "=========================================="
echo "Iniciando a criação e configuração de usuários e grupos..."
echo "=========================================="

# --------------------------------------------------
# 1. CRIAÇÃO DO GRUPO
# --------------------------------------------------
echo "-> Criando o grupo $GRUPO_CONVIDADOS..."
groupadd "$GRUPO_CONVIDADOS"

if [ $? -eq 0 ]; then
    echo "   ... Grupo $GRUPO_CONVIDADOS criado com sucesso!"
else
    # O erro mais comum aqui é o grupo já existir.
    echo "   ... Grupo $GRUPO_CONVIDADOS já existe ou falha na criação. Prosseguindo."
fi

echo "---"

# --------------------------------------------------
# 2. CRIAÇÃO DOS USUÁRIOS E ADIÇÃO AO GRUPO
# --------------------------------------------------
# O loop 'for' percorre a lista de usuários
for USUARIO_ATUAL in $USUARIOS; do
    
    echo "-> Configurando o usuário: $USUARIO_ATUAL"

    # A. Cria o usuário com diretório home (-m) e shell /bin/bash (-s)
    useradd "$USUARIO_ATUAL" -c "Usuário Convidado" -s /bin/bash -m
    
    if [ $? -eq 0 ]; then
        echo "   ... Usuário criado com sucesso!"
        
        # B. Define a senha de forma segura usando o chpasswd
        echo "$USUARIO_ATUAL:$SENHA_PADRAO" | chpasswd
        
        # C. Adiciona o usuário ao grupo suplementar (secundário)
        #    -a = Append (adicionar), -G = Grupo suplementar
        usermod -aG "$GRUPO_CONVIDADOS" "$USUARIO_ATUAL"
        
        # D. Força a troca de senha no primeiro login (recomendado)
        passwd -e "$USUARIO_ATUAL"
        
        echo "   ... Senha definida e adicionado ao grupo $GRUPO_CONVIDADOS."
    else
        echo "   *** ERRO: Falha ao criar ou usuário $USUARIO_ATUAL já existe. ***"
    fi
    
    echo "---"

done

echo "=========================================="
echo "Finalização: Usuários e grupo configurados."
echo "=========================================="
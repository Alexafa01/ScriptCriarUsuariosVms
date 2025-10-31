
Aqui estão os passos exatos para executar o *script* no seu servidor:

### ⚙️ Passos para Executar o Script

#### 1\. Criar o Arquivo

Use um editor de terminal (como `nano` ou `vi`) para criar o arquivo do *script*.

```bash
nano criar_usuarios.sh
```

Cole o código do *script* otimizado:

```bash
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
```

Salve e feche o editor.

#### 2\. Dar Permissão de Execução

Por padrão, arquivos de *script* não vêm com permissão para serem executados. Você precisa conceder essa permissão usando o comando `chmod`:

```bash
chmod +x criar_usuarios.sh
```

O `+x` significa "adicionar permissão de execução".

#### 3\. Executar o Script com `sudo`

Como o *script* usa comandos de administração de sistema, você deve executá-lo como o usuário **root** (o superusuário) usando o `sudo`:

```bash
sudo ./criar_usuarios.sh
```

  * **`sudo`**: Executa o comando subsequente com privilégios de root (pedirá sua senha).
  * **`./`**: Indica ao sistema para procurar o arquivo no diretório atual.
  * **`criar_usuarios.sh`**: O nome do seu *script*.

-----

Ao seguir esses passos, o *script* será executado no seu servidor e criará os usuários .

!!!!!!!!! 2 Script Criando varios Usuários Convidados !!!!

Vamos adicionar os seguintes comandos ao *script*:

1.  **`groupadd`**: Para criar o novo grupo.
2.  **`usermod -aG`**: Para adicionar cada usuário ao grupo suplementar (secundário), sem remover os grupos atuais.

Aqui está o *script* final, incluindo a criação do grupo `convidados`:

### 🚀 Script Final (Com Grupos)

```bash
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
```

**Com este *script*, todos os usuários `guest10` a `guest13` serão criados e automaticamente adicionados ao grupo secundário `convidados`.**

Gostaria de ajuda para executar esse *script* ou para configurar permissões para o novo grupo `convidados` em algum diretório específico?

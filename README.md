<!-- ////////////////////////////  README MAIS ATUAL /////////////////// -->

Este é um excelente script para automatizar a criação de usuários.

Abaixo está uma descrição formatada e atualizada, pronta para ser inserida em seu arquivo `README.md`, com uma linguagem mais **formal** e **profissional**.

-----

# 👤 Gerenciamento de Usuários de Acesso Temporário (Convidados)

Este script Bash é responsável por provisionar **contas de usuários convidados** com configurações padronizadas de forma automatizada no sistema. Ele utiliza métodos modernos de criptografia de senhas (SHA-512) e garante que os usuários sejam forçados a atualizar suas credenciais no primeiro login.

## 🚀 Script de Provisionamento de Usuários

### Descrição da Execução

O script realiza as seguintes ações em sequência:

1.  **Criação das Contas:** Quatro contas de usuário temporárias (`guest20` a `guest23`) são criadas.
2.  **Configuração Padronizada:** Cada usuário é configurado com:
      * **Comentário (`-c`):** "Usuário convidado".
      * **Shell de Login (`-s`):** `/bin/bash` (fornecendo acesso completo ao shell).
      * **Diretório Home (`-m`):** Cria um diretório home dedicado (`/home/guestXX`).
      * **Senha Criptografada (`-p`):** A senha inicial (`Senha123`) é definida usando o algoritmo de hash **SHA-512** (opção `-6` do `openssl passwd`) para garantir a segurança da credencial armazenada.
3.  **Expiração Forçada da Senha (`passwd -e`):** Imediatamente após a criação, a senha de cada usuário é **marcada como expirada**. Isso **força o usuário a alterar a senha** no primeiro acesso ao sistema, aumentando a segurança e aderindo às melhores práticas de gerenciamento de identidade.

### Código (`script_criacao_convidados.sh`)

```bash
#!/bin/bash
# Este script deve ser executado com privilégios de root (sudo)

echo "Iniciando o provisionamento de Contas de Acesso Temporário..."

# A senha inicial "Senha123" será criptografada usando SHA-512 (-6)
PASSWORD_HASH=$(openssl passwd -6 Senha123)
COMMENT="Usuário convidado"
SHELL_DEFAULT="/bin/bash"

# Lista de usuários a serem criados
USERS=("guest20" "guest21" "guest22" "guest23")

for USER in "${USERS[@]}"; do
    echo " -> Criando e configurando o usuário: ${USER}"
    
    # Cria o usuário, define o shell, cria o home dir e define a senha
    useradd "${USER}" -c "${COMMENT}" -s "${SHELL_DEFAULT}" -m -p "${PASSWORD_HASH}"
    
    # Força a expiração da senha para que o usuário precise alterá-la no primeiro login
    passwd "${USER}" -e
done

echo "✅ Provisionamento de todos os usuários concluído com sucesso."
```

### 💡 **Melhoria e Boas Práticas (Recomendação)**

Para ambientes de produção, é altamente recomendável utilizar **variáveis** (como no código revisado acima) para a senha e comentários, e utilizar um *loop* (como o que adicionei na sugestão de código) para evitar a repetição de código e facilitar a manutenção e escalabilidade.

-----

Qual parte desta descrição você gostaria de expandir ou detalhar mais no seu README?

<!-- ///////////////////////////////////////////////////// FIM DO README MAIS ATUAL ////////////////////////////////////////////////////////// -->


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


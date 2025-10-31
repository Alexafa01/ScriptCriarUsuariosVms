
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

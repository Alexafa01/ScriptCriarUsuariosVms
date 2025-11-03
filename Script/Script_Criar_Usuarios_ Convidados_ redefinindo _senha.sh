echo "Criando usuarios do Sistema"

useradd guest20 -c "Usuário convidado" -s /bin/bash -m -p $(openssl passwd -6 Senha123)
passwd guest20 -e

useradd guest21 -c "Usuário convidado" -s /bin/bash -m -p $(openssl passwd -6 Senha123)
passwd guest21 -e

useradd guest22 -c "Usuário convidado" -s /bin/bash -m -p $(openssl passwd -6 Senha123)
passwd guest22 -e

useradd guest23 -c "Usuário convidado" -s /bin/bash -m -p $(openssl passwd -6 Senha123)
passwd guest23 -e

echo "Usuarios criados com sucesso"

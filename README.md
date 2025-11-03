# Desafio Técnico DevOps (Cubos)

Esta é a minha solução para o desafio técnico. É uma arquitetura de 3 camadas (Frontend, Backend, DB) rodando com Docker e orquestrada pelo Terraform.


## Arquitetura
O ambiente é dividido em três serviços principais e duas redes para garantir a segurança:

* **rede-externa**: Rede pública apenas para o usuário.
* **rede-interna**: Rede privada para os serviços (usuario não consegue acessar).

* **Proxy (Nginx):** direciona o `localhost:8080`. Ele serve o `index.html` e redireciona todas as chamadas `/api` para o backend.
* **Backend (Node.js):** recebe as chamadas do proxy e consulta o banco de dados.
* **Database (Postgres):** O banco. Ele fica em uma rede interna, isolado, e só o backend consegue acessá-lo.

## Como funciona
* **Terraform (IaC):** foi criado o main.tf para orquestrar a criação dos containers, redes e volumes.
* **Docker (Container):**: Foi criado um Dockerfile e usamos imagens do PostgreSQL 15.8 e nginx Alpine para outros serviços.
* **Volumes:** criamos o docker_volume pelo Terraform, para o banco de dados gravar as informações.
**Variaveis de ambiente**: foram criadas variaveis de ambiente para setar credenciais e conexões POSTGRES_USER, POSTGRES_PASSWORD, etc


O Terraform cuida de criar as imagens, as redes (`rede-interna` e `rede-externa`) e os volumes, tudo com um comando.

## Pré-requisitos

Para executar o projeto, é crucial ter instalado:

1.  **Docker Desktop**
2.  **Terraform**


## Como Executar

Com o Docker Desktop aberto (após a configuração inicial dele e podendo ser em segundo plano), crie uma pasta local, abra um terminal ou prompt de comando na pasta do projeto e rode:

**1. Inicializar o Terraform e subir o ambiente:**

Rode o comando no terminal ou prompt:
```bash
terraform init
```
Isso irá iniciar o Terraform


Depois rode para criar o ambiente:
```bash
terraform apply
```

Digite "yes" para confirmar.


**2. Testar/acessar o programa**

Para testar o programa, basta abrir um navegador no endereço http://localhost:8080

Na tela será possível visualizar a página do projeto e o botão principal, que ao acionado mostra as mensagens "Database is up" e "Migration runned"


## Como desligar/parar o projeto

Para parar e apagar tudo (containers, redes e o volume do banco):

```bash
terraform destroy
```

Digite "yes" para confirmar.

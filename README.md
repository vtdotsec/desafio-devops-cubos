# Desafio Técnico DevOps (Cubos)

Esta é a minha solução para o desafio técnico. É uma arquitetura de 3 camadas (Frontend, Backend, DB) rodando com Docker e orquestrada pelo Terraform.

## Como funciona

* **Proxy (Nginx):** É a porta de entrada no `localhost:8080`. Ele serve o `index.html` e redireciona todas as chamadas `/api` para o backend.
* **Backend (Node.js):** O cérebro da aplicação. Ele recebe as chamadas do proxy e consulta o banco de dados.
* **Database (Postgres):** O banco. Ele fica em uma rede interna, isolado, e só o backend consegue acessá-lo.

O Terraform cuida de criar as imagens, as redes (`rede-interna` e `rede-externa`) e os volumes, tudo com um comando.

## Pré-requisitos (O "Passo 0")

Antes de começar, você **precisa** ter isso instalado e rodando:

1.  **Docker Desktop**
2.  **Terraform**

## 🚀 Como Executar

Com o Docker Desktop aberto, abra um terminal na pasta do projeto e rode:

**1. Inicializar o Terraform:**
(Baixa o "provider" do Docker)
```bash
terraform init
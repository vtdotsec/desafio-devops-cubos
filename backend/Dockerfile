# backend/Dockerfile

# Use uma imagem base leve do Node
FROM node:18-alpine

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o package.json (e package-lock.json se existir)
COPY package.json .

# Instale as dependências
RUN npm install

# Copie o resto do código (nosso index.js corrigido)
COPY . .

# Exponha a porta que o servidor vai usar
EXPOSE 3000

# O comando para iniciar a aplicação
CMD ["node", "index.js"]
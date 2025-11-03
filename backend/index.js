// backend/index.js (A VERSÃO CORRETA)

import http from 'http';
import PG from 'pg';

// 1. Leia TUDO do process.env
const port = Number(process.env.PORT) || 3000;

// 2. Crie o cliente usando o OBJETO de configuração
//    O Terraform está injetando essas variáveis de ambiente.
const client = new PG.Client({
  host: process.env.POSTGRES_HOST,
  port: Number(process.env.POSTGRES_PORT) || 5432,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
});

// 3. Crie uma função async para conectar ANTES de iniciar o servidor
async function startServer() {
  try {
    // Tenta conectar ao banco
    await client.connect();
    console.log("Database connected successfully!");

    // 4. Inicia o servidor SÓ DEPOIS de conectar com sucesso
    http.createServer(async (req, res) => {
      console.log(`Request: ${req.url}`);

      if (req.url === "/api") {
        res.setHeader("Content-Type", "application/json");
        res.writeHead(200);

        let result;
        try {
          result = (await client.query("SELECT * FROM users")).rows[0];
        } catch (error) {
          console.error("Query error:", error);
        }

        const data = {
          database: true,
          userAdmin: result?.role === "admin"
        };

        res.end(JSON.stringify(data));
      } else {
        res.writeHead(404);
        res.end("Not Found (tente /api)");
      }

    }).listen(port, () => {
      console.log(`Server is listening on port ${port}`);
    });

  } catch (err) {
    // Se a conexão com o banco falhar, o app nem sobe
    console.error('Failed to connect to database -', err.stack);
    process.exit(1); // Isso faz o contêiner falhar (o que é bom)
  }
}

// Inicia tudo
startServer();
import app from "./app";
import listRoutes from "express-list-routes";

const PORT = process.env.APP_PORT || 3000;

console.log(`\nIniciando o servidor na porta ${PORT}... 😁\n`)

// Listar rotas na consola
app.listen(PORT, () => {
  console.log(`🚀 API rodando na porta ${PORT}`);

  // imprime rotas registradas
  console.log("📌 Rotas disponíveis:");
  listRoutes(app, { prefix: "/api", forceUnixPathStyle: true });
});
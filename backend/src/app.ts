import express from "express";
import cors from "cors";

const app = express();

app.use(cors());
app.use(express.json());

// Rotas base (ainda mockadas)
app.get("/", (req, res) => {
  res.json({ message: "API de Patrimônio OK 🚀" });
});

app.get("/patrimonios", (req, res) => {
  res.json([]);
});

app.get("/secoes", (req, res) => {
  res.json([]);
});

export default app;

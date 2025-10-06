# 📚 Sistema de Gestão de Património e Inventário

Este README descreve todos os passos necessários para configurar e executar o sistema de gestão de património, tanto em ambientes Windows quanto Linux, com ou sem Docker.

---

## 1. Criar o `.env`

Baseie-se no ficheiro de template para criar o `.env` do backend:

```bash
cd backend
cp .env.template .env
```

> Certifique-se de preencher corretamente os campos, principalmente `DATABASE_URL`.

---

## 2. Instalar dependências

### Backend

```bash
cd backend
npm install
```

### Frontend

```bash
cd ../frontend
npm install
```

---

## 3. Base de dados

### 3.1 Usuários Windows (Workbench, XAMPP, WAMP, etc.)

Para quem utiliza MySQL instalado localmente:

1. Certifique-se de que o MySQL está em execução.
2. Crie a base de dados conforme definido no `.env`:

```sql
CREATE DATABASE sgpi;
```

> O nome da base de dados deve coincidir com o `DATABASE_URL` do `.env`, ex.:
> `DATABASE_URL="mysql://root:123456@localhost:3306/sgpi"`

3. Execute as migrações Prisma:

```bash
cd backend
npx prisma migrate deploy
npx prisma generate
```

4. (Opcional) Popular a base com dados iniciais:

```bash
npx prisma db seed
```

---

### 3.2 Usuários Linux (Docker)

Se utilizar containers:

```bash
docker compose up -d
```

Depois, no backend:

```bash
cd backend
npx prisma migrate deploy
npx prisma generate
npx prisma db seed
```

> Certifique-se de que o container MySQL está **pronto e saudável** antes de rodar os comandos Prisma.

---

## 4. Executar aplicações

### 4.1 Backend

```bash
cd backend
npm run dev
```

* Servidor Node/Express com TypeScript + nodemon
* Porta padrão: 3001 (conforme `.env`)
* Reinicia automaticamente ao salvar alterações

### 4.2 Frontend

```bash
cd frontend
npm run dev
```

* Servidor de frontend (React/Vite ou similar)
* Porta padrão: 3000
* Acesse via `http://localhost:3000`

---

## 5. Prisma Studio (opcional)

Ferramenta visual para inspeção e edição dos dados:

```bash
cd backend
npx prisma studio
```

* Acessível via navegador: [http://localhost:5555](http://localhost:5555)
* Permite navegar, adicionar ou editar registros diretamente

---

## 6. Scripts úteis

No `package.json` do backend, recomenda-se adicionar:

```json
"scripts": {
  "dev": "nodemon src/server.ts",
  "seed": "ts-node prisma/seed.ts",
  "studio": "prisma studio"
}
```

* `npm run dev` → inicia o backend
* `npm run seed` → popula a base de dados
* `npm run studio` → abre Prisma Studio

---

## 7. Observações

* Sempre verifique o **estado do MySQL** antes de rodar migrate ou seed.
* Para usuários Windows sem Docker, certifique-se que o MySQL local corresponde ao `DATABASE_URL`.
* O seed já inclui **hash de senha** para usuários iniciais, garantindo segurança.
* Caso haja alterações no **schema Prisma**, execute sempre:

```bash
npx prisma generate
```

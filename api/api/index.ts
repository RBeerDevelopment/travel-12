import { db } from "../db/connection.js";
import { users } from "../db/schema.js";
import { eq } from "drizzle-orm";

import { createTenantDatabase } from "../utils/create-tenant-db.js";
import cors from "cors";
import express, { Request, Response } from "express";
import { fetchTenantDbCredentials } from "../utils/fetch-tenant-db-credentials.js";

export const app = express();

app.use(cors());
app.use(express.json());

app.get("/api/users", (req: Request, res: Response) => {
  const userId = req.query.id;

  if (!userId) {
    res.status(400).json({ error: "User ID is required" });
    return;
  }

  db.select()
    .from(users)
    // .where(eq(users.id, userId))
    .then((userRows) => {
      if (!userRows) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      return res.status(200).json(userRows[0]);
    });
});

app.get("/api/users/:id", async (req: Request, res: Response) => {
  const userId = req.params.id;

  if (!userId) {
    res.status(400).json({ error: "User ID is required" });
    return;
  }

  const userRows = await db
    .select({ id: users.id })
    .from(users)
    .where(eq(users.id, userId));

  if (userRows.length === 0) {
    res.status(404).json({ error: "User not found" });
    return;
  }

  const credentials = await fetchTenantDbCredentials(userId);
  res.status(201).json(credentials);
});

app.post("/api/users", async (req: Request, res: Response) => {
  const { email, userId } = req.body;

  console.log("BODY: ");
  console.log(req.body);

  if (!userId || !email) {
    res.status(400).json({ error: "ID and email are required" });
    return;
  }

  await db
    .insert(users)
    .values({ id: userId, email })
    .catch((err) => {
      console.error(err);
      res.status(409).json({ error: "User already exists" });
      return;
    });

  const credentials = await createTenantDatabase(userId);

  await db
    .update(users)
    .set({ dbName: credentials.dbUrl })
    .where(eq(users.id, userId));
  res.status(201).json(credentials);
});

app.listen(3000).on("listening", () => {
  console.info("server is listening on port http://localhost:3000");
});

export default app;

import { defineConfig } from "drizzle-kit";
export default defineConfig({
  dialect: "sqlite",
  schema: "./db.ts",
  dbCredentials: {
    url: "file:stations.sqlite",
  },
});

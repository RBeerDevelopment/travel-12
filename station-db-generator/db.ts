import { drizzle } from "drizzle-orm/libsql";
import { real, sqliteTable, text } from "drizzle-orm/sqlite-core";

export const stations = sqliteTable("stations", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  normalizedName: text("normalized_name").notNull(),
  weight: real("weight").notNull(),
  lat: real("lat").notNull(),
  lng: real("lng").notNull(),
});

export const products = sqliteTable("products", {
  id: text("id").primaryKey(),
  mode: text("mode").notNull(),
});

export const stationToLines = sqliteTable("station_to_lines", {
  stationId: text("station_id").references(() => stations.id),
  lineId: text("line_id").references(() => lines.id),
});

export const lines = sqliteTable("lines", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  productId: text("product_id")
    .notNull()
    .references(() => products.id),
  color: text("color").notNull(),
});

export const db = drizzle({
  connection: {
    url: "file:test.db",
  },
  logger: true,
});

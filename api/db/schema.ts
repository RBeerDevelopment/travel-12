import { sql } from "drizzle-orm";
import { integer, sqliteTable, text } from "drizzle-orm/sqlite-core";

export const favoriteTrips = sqliteTable("favorite_trips", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull(),
  stationId: text("station_id").notNull(),
  stationName: text("station_name").notNull(),
  lineId: text("line_id").notNull(),
  destinationId: text("destination_id").notNull(),
  createdAt: integer("created_at", { mode: "timestamp" }).default(
    sql`(CURRENT_TIMESTAMP)`
  ),
  updatedAt: integer("updated_at", { mode: "timestamp" }).default(
    sql`(CURRENT_TIMESTAMP)`
  ),
  deletedAt: integer("deleted_at", { mode: "timestamp" }).default(sql`NULL`),
});

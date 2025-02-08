import { sql } from "drizzle-orm";
import { integer, sqliteTable, text } from "drizzle-orm/sqlite-core";

export const favoriteTrips = sqliteTable("favorite_trips", {
  id: text("id").primaryKey(),
  userId: text("user_id"),
  stationId: text("station_id"),
  lineId: text("line_id"),
  destinationId: text("destination_id"),
  createdAt: integer("created_at", { mode: "timestamp" }).default(
    sql`(CURRENT_TIMESTAMP)`
  ),
  updatedAt: integer("updated_at", { mode: "timestamp" }).default(
    sql`(CURRENT_TIMESTAMP)`
  ),
  deletedAt: integer("deleted_at", { mode: "timestamp" }).default(sql`NULL`),
});

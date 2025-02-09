import { sql } from "drizzle-orm";
import {
  integer,
  primaryKey,
  sqliteTable,
  text,
} from "drizzle-orm/sqlite-core";

export const favoriteTrips = sqliteTable(
  "favorite_trips",
  {
    userId: text("user_id").notNull(),
    stationId: text("station_id").notNull(),
    lineId: text("line_id").notNull(),
    destinationId: text("destination_id").notNull(),
    createdAt: integer("created_at", { mode: "timestamp" }).default(
      sql`(CURRENT_TIMESTAMP)`
    ),
    updatedAt: integer("updated_at", { mode: "timestamp" }).default(
      sql`(CURRENT_TIMESTAMP)`
    ),
    deletedAt: integer("deleted_at", { mode: "timestamp" }).default(sql`NULL`),
  },
  (t) => {
    return [
      primaryKey({
        columns: [t.userId, t.stationId, t.lineId, t.destinationId],
      }),
    ];
  }
);

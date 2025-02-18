import { Hono } from "hono";
import { handle } from "hono/vercel";
import { cors } from "hono/cors";
import { db } from "../db/connection.js";
import { and, eq } from "drizzle-orm";
import { favoriteTrips } from "../db/schema.js";
import {
  ApiResponse,
  CreateFavoriteTripBody,
  FavoriteTrip,
  UpdateFavoriteTripBody,
} from "../types/favorite-trips.js";

const app = new Hono().basePath("/api");

// Enable CORS
app.use("*", cors());

// Get all favorite trips
app.get("/favorite-trips", async (c) => {
  try {
    const trips = await db.select().from(favoriteTrips);
    return c.json<ApiResponse<FavoriteTrip[]>>({
      data: trips,
    });
  } catch (error) {
    return c.json<ApiResponse<never>>(
      {
        error: "Failed to fetch favorite trips",
      },
      500
    );
  }
});

// Get all favorite trips for a user
app.get("/favorite-trips/user/:userId", async (c) => {
  const userId = c.req.param("userId");
  try {
    const trips = await db
      .select()
      .from(favoriteTrips)
      .where(eq(favoriteTrips.userId, userId));

    return c.json<ApiResponse<FavoriteTrip[]>>({
      data: trips,
    });
  } catch (error) {
    return c.json<ApiResponse<never>>(
      {
        error: "Failed to fetch favorite trips",
      },
      500
    );
  }
});

// Create new favorite trip
app.post("/favorite-trips", async (c) => {
  try {
    const body = await c.req.json<CreateFavoriteTripBody>();

    const newTrip: FavoriteTrip = {
      id: body.id,
      userId: body.userId,
      stationId: body.stationId,
      stationName: body.stationName,
      lineId: body.lineId,
      destinationId: body.destinationId,
      createdAt: new Date(),
      updatedAt: new Date(),
      deletedAt: null,
    };

    await db.insert(favoriteTrips).values(newTrip).onConflictDoNothing();
    return c.json<ApiResponse<FavoriteTrip>>(
      {
        data: newTrip,
        message: "Favorite trip created successfully",
      },
      201
    );
  } catch (error) {
    return c.json<ApiResponse<never>>(
      {
        error: "Failed to create favorite trip",
      },
      500
    );
  }
});

// Delete favorite trip
app.delete("/favorite-trips/:id", async (c) => {
  const id = c.req.param("id");
  try {
    await db.delete(favoriteTrips).where(eq(favoriteTrips.id, id));
    return c.json<ApiResponse<never>>({
      message: "Favorite trip deleted successfully",
    });
  } catch (error) {
    return c.json<ApiResponse<never>>(
      {
        error: "Failed to delete favorite trip",
      },
      500
    );
  }
});

export const GET = handle(app);
export const POST = handle(app);
export const PUT = handle(app);
export const DELETE = handle(app);

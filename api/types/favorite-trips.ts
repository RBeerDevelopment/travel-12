import { InferSelectModel } from "drizzle-orm";
import { favoriteTrips } from "../db/schema.js";

export type FavoriteTrip = InferSelectModel<typeof favoriteTrips>;
export type NewFavoriteTrip = Omit<FavoriteTrip, "id">;

export type CreateFavoriteTripBody = {
  userId: string;
  stationId: string;
  lineId: string;
  destinationId: string;
};

export type UpdateFavoriteTripBody = Partial<CreateFavoriteTripBody>;

export type ApiResponse<T> = {
  data?: T;
  error?: string;
  message?: string;
};

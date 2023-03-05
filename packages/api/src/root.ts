import { authRouter } from "./router/auth";
import { departureRouter } from "./router/departures";
import { locationRouter } from "./router/location";
import { tripRouter } from "./router/trip";
import { createTRPCRouter } from "./trpc";

export const appRouter = createTRPCRouter({
  auth: authRouter,
  departures: departureRouter,
  location: locationRouter,
  trip: tripRouter
});

// export type definition of API
export type AppRouter = typeof appRouter;

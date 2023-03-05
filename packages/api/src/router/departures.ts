import { z } from "zod";

import { createTRPCRouter, publicProcedure } from "../trpc";
import { hafasClient } from "../utils/vbb-hafas/client";
import type { DepartureResponse } from "../models/response";
import { mapResponseToDeparture } from "../models";

export const departureRouter = createTRPCRouter({
  byStationId: publicProcedure
    .input(
      z.object({
        stationId: z.string(),
        resultCount: z.number().default(30),
        duration: z.number().default(30),
      })
    )
    .query(async ({ input }) => {
      const { stationId, resultCount, duration } = input;

      // eslint-disable-next-line
      const { departures }: { departures: DepartureResponse[] } =
        // eslint-disable-next-line
        await hafasClient.departures(stationId, {
          remarks: false,
          results: resultCount,
          duration: duration,
        });

      return departures.map(mapResponseToDeparture);
    }),
});

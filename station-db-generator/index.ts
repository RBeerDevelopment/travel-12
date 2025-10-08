import vbbStations from "vbb-stations";
import normalize from "normalize-for-search";
import linesAt from "vbb-lines-at";
import lineColors from "vbb-line-colors";

import { db, products, lines, stations, stationToLines } from "./db";
import type { Line, StationInLib } from "./types";
import { sql } from "drizzle-orm";

const fallbackColor = "#cdcdcd";

await db
  .insert(products)
  .values([
    { id: "bus", mode: "bus" },
    { id: "regional", mode: "train" },
    { id: "suburban", mode: "train" },
    { id: "subway", mode: "train" },
    { id: "tram", mode: "train" },
    { id: "ferry", mode: "watercraft" },
  ])
  .onConflictDoNothing();

const allStations: StationInLib[] = vbbStations("all").filter(
  (station: StationInLib) => !/^VERWAIST: /.test(station.name)
);

console.log(allStations.length, "stations!!");

const stationsToInsert = allStations.map((station) => ({
  id: station.id,
  name: station.name.replace("U Mohrenstr.", "U Anton-W.-Amo-Str. (Mohrenstr.)"),
  normalizedName: normalize(station.name.replace("U Mohrenstr.", "U Anton-W.-Amo-Str. (Mohrenstr.)")),
  lat: station.location.latitude,
  lng: station.location.longitude,
  weight: station.weight,
}));

console.dir(stationsToInsert.at(0));
console.log(stationsToInsert.length, "stations to insert");

// Insert stations in batches
const INSERT_BATCH_SIZE = 500;

for (
  let index = 0;
  index < stationsToInsert.length;
  index += INSERT_BATCH_SIZE
) {
  const endIndex = Math.min(
    index + INSERT_BATCH_SIZE,
    stationsToInsert.length - 1
  );
  const batch = stationsToInsert.slice(index, endIndex);
  await db.insert(stations).values(batch);
}

// Insert lines and line-station relations
const linesAtStation: Line[][] = Object.values(linesAt);

const lineMap = new Map<string, Line>();
linesAtStation.forEach((lines) => {
  lines.forEach((line) => {
    lineMap.set(line.id, line);
  });
});

const uniqueLines = Array.from(lineMap.values());

await db
  .insert(lines)
  .values(
    uniqueLines.map((line) => ({
      id: line.id,
      name: line.name,
      productId: line.product,
      color: lineColors?.[line.product]?.[line.name]?.bg ?? fallbackColor,
    }))
  )
  .onConflictDoNothing();

const stationLineEntries = Object.entries(linesAt)
  .map(([stationId, lines]) =>
    (lines as Line[]).map((line) => ({
        stationId: stationId,
        lineId: line.id,
      })
    )
  )
  .flat();

let errorCount = 0

for (
  let index = 0;
  index < stationLineEntries.length;
  index += 1
) {
  const endIndex = Math.min(
    index + 1,
    stationLineEntries.length - 1
  );
  const batch = stationLineEntries.slice(index, endIndex);
  if(batch.length === 0) {
    continue;
  }
  await db.insert(stationToLines).values(batch)
    .onConflictDoNothing()
    .catch((err) => {
      errorCount += 1;
    });
}

console.log(errorCount, "errors");
await db.run(
  sql`CREATE VIRTUAL TABLE stations_fts USING fts5(normalized_name, tokenize="trigram");`
);

await db.run(
  sql`INSERT INTO stations_fts(normalized_name) SELECT normalized_name FROM stations;`
);
await db.run(
  sql`CREATE INDEX idx_stl_station_id ON station_to_lines (station_id);`
);
await db.run(sql`CREATE INDEX idx_stl_line_id ON station_to_lines (line_id);`);
console.log("Done");

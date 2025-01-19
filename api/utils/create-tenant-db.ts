import { createClient } from "@libsql/client";
import axios from "axios";
import { TenantDbCredentials } from "../types/db-credentials.js";

export async function createTenantDatabase(
  userId: string
): Promise<TenantDbCredentials> {
  const config = {
    headers: {
      Authorization: `Bearer ${process.env.TURSO_API_TOKEN}`,
    },
  };

  const dbName = `${process.env.TURSO_APP_NAME}-${userId}`;

  // create a database for organization
  const orgDatabase = await axios.post(
    `${process.env.TURSO_API_URL}/v1/databases`,
    {
      name: dbName,
      group: `${process.env.TURSO_APP_GROUP}`,
      location: `${process.env.TURSO_PRIMARY_LOCATION}`,
    },
    config
  );
  const {
    database: { Hostname: dbUrl },
  } = orgDatabase.data;

  // create an authentication token
  const tokenResponse = await axios.post(
    `${process.env.TURSO_API_URL}/v1/organizations/${process.env.TURSO_APP_ORGANIZATION}/databases/${dbName}/auth/tokens?expiration=2m`,
    {},
    config
  );
  const { jwt: authToken } = tokenResponse.data;

  // run migrations
  const db = createClient({
    url: `libsql://${dbUrl}`,
    authToken,
  });

  const setupStatement = `
    CREATE TABLE favorite_trips (
        start_station_id TEXT NOT NULL,
        start_station_name TEXT NOT NULL,
        line_id TEXT NOT NULL,
        direction TEXT NOT NULL,
        PRIMARY KEY (start_station_id, line_id, direction)
    );
  `;

  await db.execute(setupStatement);

  return {
    dbUrl,
    authToken,
  };
}

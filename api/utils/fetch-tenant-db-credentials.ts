import axios from "axios";
import { TenantDbCredentials } from "../types/db-credentials.js";
import { formatDbNameToUrl } from "./format-db-name-to-url.js";

export async function fetchTenantDbCredentials(
  userId: string
): Promise<TenantDbCredentials> {
  const config = {
    headers: {
      Authorization: `Bearer ${process.env.TURSO_API_TOKEN}`,
    },
  };

  const dbName = `travel12-${userId}`;
  const dbUrl = formatDbNameToUrl(dbName);

  const tokenResponse = await axios.post(
    `${process.env.TURSO_API_URL}/v1/organizations/${process.env.TURSO_APP_ORGANIZATION}/databases/${dbName}/auth/tokens`,
    {},
    config
  );

  console.log(
    `${process.env.TURSO_API_URL}/v1/organizations/${process.env.TURSO_APP_ORGANIZATION}/databases/${dbName}/auth/tokens`,
    `Authorization: Bearer ${process.env.TURSO_API_TOKEN}`
  );
  console.log(tokenResponse.data);

  const { jwt: authToken } = tokenResponse.data;

  return {
    dbUrl,
    authToken,
  };
}

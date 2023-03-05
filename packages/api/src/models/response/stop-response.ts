import type { ProductsBoolean } from "../utils";

export interface StopResponse {
    type: string;
    id: string;
    name: string;
    location: Location;
    products: ProductsBoolean;
    stationDHID: string;
}
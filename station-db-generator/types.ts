type LocationInLib = {
  type: "location";
  latitude: number;
  longitude: number;
};

export type StationInLib = {
  type: "station";
  id: string;
  name: string;
  location: LocationInLib;
  weight: number;
};

export type LinesAtStation = Record<string, Line[]>;

export type Line = {
  id: string;
  name: string;
  mode: string;
  product: string;
};

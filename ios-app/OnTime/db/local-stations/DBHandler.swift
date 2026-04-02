//
//  DBHandler.swift
//  OnTime
//
//  Created by Robin Beer on 04.11.24.
//
import Libsql
import Foundation

let STATION_QUERY_MATCH_PART = """
    INNER JOIN stations_fts f ON s.rowid = f.rowid
    WHERE f.normalized_name MATCH ?
"""

let STATION_QUERY_NO_MATCH_PART = """
    WHERE s.normalized_name LIKE ?
"""

let STATION_QUERY_WITH_SEARCH_PLACEHOLDER = """
    SELECT 
        s.id, 
        s.name, 
        s.lat, 
        s.lng,
        (SELECT json_group_array(
            json_object(
                'name', line.name,
                'color', line.color,
                'product', line.product_id
            )
        )
        FROM 
            (
            SELECT DISTINCT l.name, l.color, l.product_id
                FROM station_to_lines stl2
                INNER JOIN lines l ON stl2.line_id = l.id
                WHERE stl2.station_id = s.id
            ) AS line
        )
    FROM stations s
    %@
    GROUP BY s.name
    ORDER BY s.weight DESC LIMIT 10;
"""

let NEARBY_STATION_QUERY = """
    SELECT 
        s.id, 
        s.name, 
        s.lat, 
        s.lng,
        (
            SELECT 
                json_group_array(
                    json_object(
                        'name', line.name,
                        'color', line.color,
                        'product', line.product_id
                    )
                )
            FROM 
                (
                SELECT DISTINCT l.name, l.color, l.product_id
                    FROM station_to_lines stl2
                    INNER JOIN lines l ON stl2.line_id = l.id
                    WHERE stl2.station_id = s.id
                ) AS line
        )
    FROM stations s
    GROUP BY s.name
    ORDER BY (
            (:user_lat - lat) * (:user_lat - lat)
        ) + (
            (:user_lng - lng) * (:user_lng - lng)
        ) ASC
    LIMIT 5;
"""

class DatabaseConnectionManager {
    // Static instance of the singleton
    static let shared = DatabaseConnectionManager()
    
    // Private property to store the existing database connection
    private var connection: Connection?
    
    // Private initializer to prevent multiple instances
    private init() {}
    
    // Path to the database file (this should be set up according to your app's requirements)
    
    // Method to establish a database connection if none exists
    func getConnection() throws -> Connection {
        // If there's already an active connection, return it
        if let existingConnection = connection {
            return existingConnection
        }
        
        guard let dbPath = getDatabasePath() else {
            throw "Couldn't get DB path"
            }
        
        let db = try Database(dbPath)
        let newConnection = try db.connect()
    
        self.connection = newConnection
        
        return newConnection
    }
    
    func getDatabasePath() -> String? {
        return Bundle.main.path(forResource: "stations", ofType: "sqlite")
    }
}


func queryStationInDB(query: String) -> [StationSearchItem] {
    
    if(query.isEmpty) {
        return []
    }
    
    let cleanedQuery = query.cleanUmlauts()
        
    var stations: [StationSearchItem] = []
    do {
        let matchPart = cleanedQuery.count > 2 ?
            STATION_QUERY_MATCH_PART :
            STATION_QUERY_NO_MATCH_PART.replacingOccurrences(of: "?", with: "'%\(cleanedQuery)%'")
        let statement = String(format: STATION_QUERY_WITH_SEARCH_PLACEHOLDER, matchPart)
        
        let queryParam = cleanedQuery.count > 2 ?
            [cleanedQuery] :
            []
        
        let connection = try DatabaseConnectionManager.shared.getConnection()
        
        print(statement, queryParam)
        let rows = try connection.query(statement, queryParam)
        
        for row in rows {
            let linesJsonString = try row.getString(4)
            let linesData = linesJsonString.data(using: .utf8) ?? Data()
            let lines = try! JSONDecoder().decode([StationSearchItemLine].self, from: linesData)

            stations.append(StationSearchItem(id: try row.getString(0), name: try row.getString(1), lines: lines, location: Location(id: try row.getString(0), latitude: try row.getDouble(2), longitude: try row.getDouble(3))))
        }
    } catch {
        print("Error fetching stations: \(error)")

    }
    
    return stations
}


func queryNearbyStationsInDB(lat: Double, lng: Double) -> [StationSearchItem] {
    var stations: [StationSearchItem] = []
    
    do {
        let connection = try DatabaseConnectionManager.shared.getConnection()
        
        let queryParams = [ ":user_lat": lat, ":user_lng": lng ]
        
        let rows = try connection.query(NEARBY_STATION_QUERY, queryParams)
        for row in rows {
            let linesJsonString = try row.getString(4)
            let linesData = linesJsonString.data(using: .utf8) ?? Data()
            let lines = (try? JSONDecoder().decode([StationSearchItemLine].self, from: linesData)) ?? []
            stations.append(StationSearchItem(id: try row.getString(0), name: try row.getString(1), lines: lines, location: Location(id: try row.getString(0), latitude: try row.getDouble(2), longitude: try row.getDouble(3))))
        }
    } catch {
        print("Error fetching stations: \(error)")
    }
    
    return stations
}


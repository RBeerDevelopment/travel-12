//
//  DBHandler.swift
//  Travel12
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
    WHERE s.name LIKE ?
"""

let STATION_QUERY_WITH_SEARCH_PLACEHOLDER = """
    SELECT 
        s.id, 
        s.name, 
        s.lat, 
        s.lng,
        GROUP_CONCAT(DISTINCT l.product_id) AS products
    FROM stations s
    INNER JOIN station_to_lines stl ON s.id = stl.station_id
    INNER JOIN lines l ON stl.line_id = l.id
    %@
    GROUP BY s.name
    ORDER BY s.weight DESC LIMIT 10;
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
        let statment = String(format: STATION_QUERY_WITH_SEARCH_PLACEHOLDER, matchPart)
        
        let queryParam = cleanedQuery.count > 2 ?
            [cleanedQuery] :
            []
        
        let connection = try DatabaseConnectionManager.shared.getConnection()
        
        let rows = try connection.query(statment, queryParam)
        for row in rows {
            stations.append(StationSearchItem(id: try row.getString(0), name: try row.getString(1), products: try row.getString(4).components(separatedBy: ","), location: StationLocation(id: try row.getString(0), latitude: try row.getDouble(2), longitude: try row.getDouble(3))))
        }
    } catch {
        print("Error info: \(error)")
        print("Error fetching stations")
    }
    
    return stations
}


import Foundation
import SQLite3

class GogoDatabase {
    private var db: OpaquePointer?
    private let dbPath: String

    init() {
        dbPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("gogo.sqlite").path
    }

    func open() -> Bool {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
            return true
        } else {
            print("Unable to open database.")
            return false
        }
    }

    func close() {
        sqlite3_close(db)
    }

    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS gogo(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            score INTEGER
        );
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Gogo table created.")
            } else {
                print("Gogo table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    func insert(name: String, score: Int) {
        let insertStatementString = "INSERT INTO gogo (name, score) VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(score))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    func query() -> [(Int, String, Int)] {
        let queryStatementString = "SELECT * FROM gogo;"
        var queryStatement: OpaquePointer?
        var result: [(Int, String, Int)] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let score = sqlite3_column_int(queryStatement, 2)
                result.append((Int(id), name, Int(score)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return result
    }
}

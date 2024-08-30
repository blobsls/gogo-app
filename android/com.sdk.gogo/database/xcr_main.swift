
import Foundation
import SQLite3

class GogoDatabase {
    private var db: OpaquePointer?
    private let dbPath: String

    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        dbPath = documentsDirectory.appendingPathComponent("gogo.sqlite").path
    }

    func initialize() {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }

        createTables()
    }

    private func createTables() {
        let createUserTableSQL = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        """

        let createProfileTableSQL = """
        CREATE TABLE IF NOT EXISTS profiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            full_name TEXT,
            bio TEXT,
            avatar_url TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
        );
        """

        let createSettingsTableSQL = """
        CREATE TABLE IF NOT EXISTS settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            theme TEXT DEFAULT 'light',
            notifications_enabled INTEGER DEFAULT 1,
            FOREIGN KEY (user_id) REFERENCES users(id)
        );
        """

        executeSQLStatement(sql: createUserTableSQL)
        executeSQLStatement(sql: createProfileTableSQL)
        executeSQLStatement(sql: createSettingsTableSQL)
    }

    private func executeSQLStatement(sql: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table created successfully")
            } else {
                print("Error creating table")
            }
        } else {
            print("Error preparing SQL statement")
        }
        sqlite3_finalize(statement)
    }

    deinit {
        sqlite3_close(db)
    }
}

// Usage
let gogoDb = GogoDatabase()
gogoDb.initialize()

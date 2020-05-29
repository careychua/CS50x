//
//  Note.swift
//  Notes
//
//  Created by Carey Chua on 14/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var contents: String
}

// handle database connections
class NoteManager {
    // reference to database, so that it doesn't need to keep reconnecting
    var database: OpaquePointer? = nil
    
    // create an instance of NoteManager inside of itself
    // singleton -> only one instance
    static let main = NoteManager()
    // to ensure no one can instatiate/call this class by marking it as private
    private init() {
    }
    
    
    // connect to database
    func connect() {
        // to make sure that database is connected and only once, if keeps connecting, it slows down
        if database != nil {
            return
        }
        
        do {
            // get path and append file for database in user's disk, create file if it doesn't exist,
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            // open sqlite3 file to access database
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Could not connect to database")
                return
            }
            
            // create table in the database
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) != SQLITE_OK {
                print("Could not create table")
            }
        }
        catch let error {
            print("Could not create database")
        }
    }
    
    // create new note
    func create() -> Int {
        // ensure that there is a database pointer
        connect()
        
        // 1. prepare the sql statement
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('new note')", -1, &statement, nil) != SQLITE_OK {
            print("Could not query INSERT")
            return -1
        }
        
        //2. execute statement
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not insert note")
            return -1
        }
        
        //3. finalise statement
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    // get all notes from database
    func getAllNotes() -> [Note] {
        connect()
        
        var statement: OpaquePointer? = nil
        var results: [Note] = []
        // prepare
        if sqlite3_prepare_v2(database, "SELECT rowid, contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Could not query ALL notes")
            return []
        }
        //execute and get results
        while sqlite3_step(statement) == SQLITE_ROW {
            results.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1))))
        }
        //finalise
        sqlite3_finalize(statement)
        return results
        
    }
    
    // save updated note contents
    func save(note: Note) {
        connect()
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could not query update")
            return
        }
        
        // bind data to the query
        sqlite3_bind_text(statement, 1, NSString(string: note.contents).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not update note")
            return
        }
        
        sqlite3_finalize(statement)
    }
    
    // delete note contents
    func delete(note: Note) {
        connect()
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could not query delete")
            return
        }
        
        // bind data to the query
        sqlite3_bind_int(statement, 1, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not delete note")
            return
        }
        
        sqlite3_finalize(statement)
    }
}

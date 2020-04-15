//
//  DBHelper.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 06/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import Foundation

import SQLite3
class DBHelper
{
    init()
    {
        db = openDatabase()
        //createTable()
        createCatogeryTable()
    }

    let dbPath: String = "CategoryDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    /*
     var SNo = ""
     var CategoryId = ""
     var Name = ""
     var PlayStore_Url = ""
     var AppleStore_Url = ""
     var Description = ""
     var Redirect_Link_1 = ""
     var Actutal_Reditrect = ""
     var IsActive = ""
     var Count = ""
     var CategoryName = ""
     
     */
    
    func createCatogeryTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS cateogry(SNo TEXT PRIMARY KEY, CategoryId TEXT ,Name TEXT,PlayStore_Url TEXT,AppleStore_Url TEXT,Description TEXT,Redirect_Link_1 TEXT,Actutal_Reditrect TEXT,IsActive TEXT,Count TEXT,CategoryName TEXT,CategoryImagePng TEXT, ChatID TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Category table created.")
            } else {
                print("Category table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    /*
     CREATE TABLE IF NOT EXISTS cateogry(SNo INTEGER PRIMARY KEY, CategoryId INTEGER ,Name TEXT,PlayStore_Url TEXT,AppleStore_Url TEXT,Description TEXT,Redirect_Link_1 TEXT,Actutal_Reditrect TEXT,IsActive TEXT,Count TEXT,CategoryName TEXT)
     */
    func insertInto(SNo:String, CategoryId :String,Name :String,PlayStore_Url :String,AppleStore_Url:String,Description:String,Redirect_Link_1:String,Actutal_Reditrect:String,IsActive:String,Count:String,CategoryName:String,CategoryImagePng:String,chatID:String)
    {
       let cat =   readCatoegory()
        
//        let persons = read()
//        for p in persons
//        {
//            if p.id == id
//            {
//                return
//            }
//        }
        
        
        
        
        let insertStatementString = "INSERT INTO cateogry (SNo, CategoryId, Name, PlayStore_Url, AppleStore_Url, Description, Redirect_Link_1, Actutal_Reditrect, IsActive, Count, CategoryName, CategoryImagePng,chatID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (SNo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (CategoryId as NSString).utf8String, -1, nil)

            sqlite3_bind_text(insertStatement, 3, (Name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (PlayStore_Url as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (AppleStore_Url as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (Description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (Redirect_Link_1 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (Actutal_Reditrect as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (IsActive as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (Count as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, (CategoryName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, (CategoryImagePng as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, (chatID as NSString).utf8String, -1, nil)
            
            
            
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
    
    
    
    
//    func read() -> [Person] {
//        let queryStatementString = "SELECT * FROM person;"
//        var queryStatement: OpaquePointer? = nil
//        var psns : [Person] = []
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            while sqlite3_step(queryStatement) == SQLITE_ROW {
//                let id = sqlite3_column_int(queryStatement, 0)
//                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                let year = sqlite3_column_int(queryStatement, 2)
//                psns.append(Person(id: Int(id), name: name, age: Int(year)))
//                print("Query Result:")
//                print("\(id) | \(name) | \(year)")
//            }
//        } else {
//            print("SELECT statement could not be prepared")
//        }
//        sqlite3_finalize(queryStatement)
//        return psns
//    }
    
    
    func readCatoegory() -> [Category] {
        let queryStatementString = "SELECT DISTINCT CategoryName FROM cateogry "
        var queryStatement: OpaquePointer? = nil
        var psns : [Category] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                /*
                 "INSERT INTO cateogry (SNo, CategoryId, Name, PlayStore_Url, AppleStore_Url, Description, Redirect_Link_1, Actutal_Reditrect, IsActive, Count, CategoryName) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?);"
                 */
                let SNo = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
//                let CategoryId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                let Name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
//                let PlayStore_Url = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
//                let AppleStore_Url = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
//                let Description = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
//                let Redirect_Link_1 = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
//
//                let Actutal_Reditrect = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
//                let IsActive = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
//                let Count = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
//                let CategoryName = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
//                psns.append(Category(SNo: SNo, CategoryId: CategoryId, Name: Name, PlayStore_Url: PlayStore_Url, AppleStore_Url: AppleStore_Url, Description: Description, Redirect_Link_1: Redirect_Link_1, Actutal_Reditrect: Actutal_Reditrect, IsActive: IsActive, Count: Count, CategoryName: CategoryName))
                
                print(SNo)
                
               // psns.append(Person(id: Int(id), name: name, age: Int(year)))
                print("Query Result:")
              //  print("\(SNo) | \(CategoryId) | \(Name)|\(PlayStore_Url) | \(AppleStore_Url) | \(Description)")
            }
            print(psns.count)
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}

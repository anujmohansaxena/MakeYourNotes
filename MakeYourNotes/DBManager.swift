//
//  DBManager.swift
//  SQLiteSwiftDem
//  Created by Anuj Mohan Saxena on 01/11/18.
//  Copyright © 2018 Anuj Mohan Saxena. All rights reserved.

import UIKit

class DBManager: NSObject {
    
    let name = "name"
    let age = "age"
    let address = "address"
    let emailId = "emailId"
    let imageUrl = "imageUrl"
    let id = "ID"
    let categoryID = "CatID"
    let localIdentifier = "localIdentifier"
    let question = "question"
    let answer = "answer"
    let option1 = "option1"
    let option2 = "option2"
    let option3 = "option3"
    let option4 = "option4"
    
    let subject = "subject"
    

   // let databaseFileName = "AnujAllDetails.sqlite"
    
    let databaseFileName = "MakeYourNotesa.sqlite"
    
  // let databaseFileName = "student.sqlite"
    
    var pathToDatabase: String!
    var database: FMDatabase!
    static let shared:DBManager = DBManager()
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    print("database open")
                    let createMoviesTableQuery = "create table anuj (\(name) text not null, \(age) integer not null)"
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
        
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func createSubjectTable()->Bool{
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    print("database open")
                    let createSubjectTableQuery = "create table subject (\(id) integer primary key autoincrement , \(subject) text not null)"
                    do {
                        try database.executeUpdate(createSubjectTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
        
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    
    func getSubjects()  {
        if openDatabase(){
            let query = "select * from subject"
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                  print("table is opened")
                    var row = [String:String]()
                    var dic = [[String:String]]()
                     while(results.next())
                     {
                        var m = [String:String]()
                        row["id"] = results.string(forColumn:id)!
                        row["subject"] = results.string(forColumn: subject)
                        m["id"] = row["id"]
                        m["subject"] = row["subject"]
                        
                        dic.append(m)
                     }
                    
                    print("result = \(dic)")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: open database
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    //MARK: insert Data
 
    //MARK: find data
    func loadMovies()->[[String:String]]  {
       
        var allData = [[String:String]]()
        
        if openDatabase()
        {
            let query = "select * from anuj"
            
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                  print("table is opened")
                    var row = [String:String]()
                     while(results.next())
                     {
//                        print("name \(results.string(forColumn: name)!)")
//                        print("name = \(results.string(forColumn: name)!)")
//                        print("age = \(Int(results.int(forColumn: age)))")
//                       
                        row["name"] = results.string(forColumn:name)!
                        row["age"] = results.string(forColumn: age)
                        allData.append(row)
                     }
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            print("all data = \(allData)")
            
            
            //**********
            var allData2 = [[String:String]]()
            let query2 = "select * from users"
            
            print("query  = \(query2)")
            print(database)
            do{
                let results2 =  try database.executeQuery(query2,values: nil)
                if results2 != nil
                {
                    print("table is opened")
                    var row = [String:String]()
                    while(results2.next())
                    {
                        row["name"] = results2.string(forColumn:name)!
                        row["age"] = results2.string(forColumn: age)
                        row["address"] = results2.string(forColumn: address)
                        
                        allData2.append(row)
                    }
                    
                    print("all users = \(allData2)")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            //*************
            
            database.close()
        }
        return allData
    }
    
    //MARK: Load Categories
    
    func loadCategories()->[[String:String]]  {
        var allData = [[String:String]]()
        if openDatabase()
        {
            let query = "select * from categories"
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                    print("table is opened")
                    var row = [String:String]()
                    while(results.next())
                    {   row["id"] = results.string(forColumn: id)!
                        row["name"] = results.string(forColumn:name)!
                        row["modified_date"] = results.string(forColumn: "modified_data")
                        allData.append(row)
                    }
                }
                print("all categries = \(allData)")
            }
            catch
            {
                print(error.localizedDescription)
            }
            print("all data = \(allData)")
            database.close()
        }
        return allData
    }
    
    //******************
    
    
    //MARK: insert Data
    func insertMovieData(name:String,age:Int)
     {
        if openDatabase()
        {
            do {
                let query = "insert into anuj values('\(name)',\(age))"
                    if !database.executeStatements(query) {
                        print("Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                    else
                    {
                        print("data is successfully added")
                    }
                //*******************
              }
            catch {
                    print(error.localizedDescription)
                }
            database.close()
        }
    }
    
    //MARK: UserData
    
    func loadUsers()->[[String:String]]
     {
        var allData = [[String:String]]()
        
        if openDatabase()
        {
            //**********
            var allData = [[String:String]]()
            let query = "select * from users"
            
            print("query  = \(query)")
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                    print("table is opened")
                    var row = [String:String]()
                    while(results.next())
                    {
                        row["id"] = results.string(forColumn: "ID")!
                        row["name"] = results.string(forColumn:name)!
                        row["address"] = results.string(forColumn: address)!
                        row["emailId"] = results.string(forColumn: emailId)!
                        row["imageUrl"] = results.string(forColumn: imageUrl)!
                        row["localIdentifier"] = results.string(forColumn: localIdentifier)!
                        
                        allData.append(row)
                    }
                    print("all users = \(allData)")
                    return allData
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            //*************
            database.close()
        }
        return allData
    }
    
    func insertUserData(Name:String,Address:String,EmailId:String,ImageUrl:String,imageIdentifier:String)
    {
        if openDatabase()
        {
            do {
                let query = "insert into users values(NULL,'\(Name)','\(Address)','\(EmailId)','\(ImageUrl)','\(imageIdentifier)')"
                if  !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                else
                {
                    print("data is successfully added")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    func insertMyUserData(Name:String,Address:String,EmailId:String,ImageUrl:String)
    {
        if openDatabase()
        {
            
            do {
                let query = "insert into myusers values(NULL,'\(Name)','\(Address)','\(EmailId)','\(ImageUrl)')"
                if  !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                else
                {
                    print("data is successfully added")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    func loadMyUsers()->[[String:String]]  {
        var allData = [[String:String]]()
        if openDatabase()
        {
            //**********
            var allData = [[String:String]]()
            let query = "select * from myusers"
            
            print("query  = \(query)")
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                    print("table is opened")
                    var row = [String:String]()
                    while(results.next())
                    {
                        row["id"] = results.string(forColumn: "ID")!
                        row["name"] = results.string(forColumn:name)!
                        row["address"] = results.string(forColumn: address)!
                        row["emailId"] = results.string(forColumn: emailId)!
                        row["imageUrl"] = results.string(forColumn: imageUrl)!
                        
                        allData.append(row)
                    }
                    print("all myusers = \(allData)")
                    
                    database.close()
                    return allData
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            //*************
            
            database.close()
        }
        return allData
    }
    
    
    func insertCategoryData(name:String,modifiedDate:String)
    {
        if openDatabase()
        {
            do {
                let query = "insert into categories values(NULL,'\(name)','\(modifiedDate)')"
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                else
                {
                    print("data is successfully added")
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    func  dropCategoryTable() ->Bool {
        var droped = false
        if openDatabase()
        {
            do{
                let query = "DROP TABLE categories"
                if !database.executeStatements(query)
                {
                    print("category table not droped")
                }
                else
                {
                    print("category table is droped successfuly")
                }
            }
            catch
            {
                
            }
        }
        return droped
    }
    
    func  dropUsersTable() ->Bool {
        var droped = false
        if openDatabase()
        {
            do{
                let query = "DROP TABLE users"
                if !database.executeStatements(query)
                {
                    print("category table not droped")
                }
                else
                {
                    print("category table is droped successfuly")
                }
            }
            catch
            {
                print("error")
            }
        }
        return droped
    }
    
    func  dropMyUsersTable() ->Bool {
        var droped = false
        if openDatabase()
        {
            do{
                let query = "DROP TABLE myusers"
                if !database.executeStatements(query)
                {
                    print("category table not droped")
                }
                else
                {
                    print("category table is droped successfuly")
                }
            }
            catch
            {
                print("error")
            }
        }
        return droped
    }
    
    
    func deleteData(nameRecieve : String) -> Bool {
        var deleted = false
        if openDatabase() {
            let query = "delete from anuj where \(name)=?"
            
            do {
                try database.executeUpdate(query, values: [nameRecieve])
                deleted = true
                print("data deleted successfully")
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }
    
    func groupbyData() ->[AnyObject]
    {
        var allData = [[String:String]]()
        if openDatabase()
        {
            let query = "select * from anuj group by name"
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                    print("table is opened")
                    print("result group by = \(results)")
                    var row = [String:String]()
                    while(results.next())
                    {
                        row["name"] = results.string(forColumn:name)!
                        row["age"] = results.string(forColumn: age)
                        allData.append(row)
                    }
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        print("all data group by \(allData)")
        return allData as! [AnyObject]
    }
    
    func createUserTable() ->Bool {
        
        var created = false
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    print("database open")
                    let createMoviesTableQuery = "create table users (\(id) integer primary key autoincrement ,\(name) text not null, \(address) text not null, \(emailId) VARCHAR(255) not null, \(imageUrl) text not null ,\(localIdentifier) text not null)"
                   
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
      //MARK: start question answer mark
    func createQuestionAnswerTable() ->Bool {
        var created = false
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    print("database open")
                    let createQuestionAnswerTableQuery = "create table questionanswer (\(id) integer primary key autoincrement ,\(question) text not null, \(option1) text not null, \(option2) text not null,\(option3) text not null, \(option4) text not null,\(answer) text not null,\(categoryID) text not null)"
//                    let createQuestionAnswerTableQuery = "create table questionanswer (\(id) integer primary key autoincrement ,\(question) text not null, \(option1) text not null, \(option2) text not null,\(option3) text not null, \(option4) text not null,\(answer) text not null)"
                    
                    do {
                        try database.executeUpdate(createQuestionAnswerTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func insertQuestionAnswerData(question:String,option1:String,option2:String,option3:String,option4:String,answer:String,catID:String)
    {
        if openDatabase()
        {
            do {
                let query = "insert into questionanswer values(NULL,'\(question)','\(option1)','\(option2)','\(option3)','\(option4)','\(answer)','\(catID)')"
                if  !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                else
                {
                    print("data is successfully added")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    func dropQuestionanswer() -> Bool {
        var droped = false
        if openDatabase()
        {
            do{
                let query = "DROP TABLE questionanswer"
                if !database.executeStatements(query)
                {
                    print("questionanswer table not droped")
                }
                else
                {
                    print("questionanswer table is droped successfuly")
                }
            }
            catch
            {
                
            }
        }
        return droped
        
    }
    
    func loadQuestionAnswer()->[[String:String]]
    {
        var allData = [[String:String]]()
        
        if openDatabase()
        {
            //**********
            var allData = [[String:String]]()
            let query = "select * from questionanswer"
            
            print("query  = \(query)")
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
                if results != nil
                {
                    print("table is opened")
                    var row = [String:String]()
                    while(results.next())
                    {
                        row["id"] = results.string(forColumn: "ID")!
                        row["question"] = results.string(forColumn:question)!
                        row["option1"] = results.string(forColumn: option1)!
                        row["option2"] = results.string(forColumn: option2)!
                        row["option3"] = results.string(forColumn: option3)!
                        row["option4"] = results.string(forColumn: option4)!
                        row["answer"] = results.string(forColumn: answer)!
                        row["CatID"] = results.string(forColumn: categoryID)
                        
                        allData.append(row)
                    }
                    print("all question answer = \(allData)")
                    return allData
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            //*************
            database.close()
        }
        return allData
    }
    //MARK: end question answer mark
    
    
    
    func createMyUserWithID() ->Bool
    {
        var created = false
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    print("database open")
                    let createMoviesTableQuery = "create table myusers ( \(id) integer primary key autoincrement , \(name) text not null, \(address) text not null, \(emailId) VARCHAR(255) not null, \(imageUrl) text not null )"
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
    
    func createCategoryTable() ->Bool {
        
        var created = false
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    print("database open")
                    
                    let createMoviesTableQuery = "create table categories (\(id) integer primary key autoincrement , 'Name' text not null,'modified_data' text not null)"
                    do
                     {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
            
                    
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
    
    
    func groupbyData2() ->[AnyObject]
    {
        var allData = [[String:String]]()
        var myGroupData  = [[[String:String]]]()
        if openDatabase()
        {
            let query = "select Distinct name from anuj"
            print(database)
            do{
                let results =  try database.executeQuery(query,values: nil)
    
                if results != nil
                {
                    print("table is opened")
                    print("result group by = \(results)")
                    var row = [String:String]()
                    var mygroupArr = [[String:String]]()
                    
                    while(results.next())
                    {
                        row["name"] = results.string(forColumn:name)!
                        row["age"] = results.string(forColumn: age)
                        allData.append(row)
    
                        let query2 = "select * from anuj where \(name) = ?"
                        
                        do
                        {
                            let results2 = try database.executeQuery(query2,values:[row["name"]])
                            
                            var mygrouprow = [[String:String]]()
                            
                            while(results2.next())
                            {
                                var mygroupdict = [String:String]()
                                mygroupdict["name"] = results2.string(forColumn: name)!
                                mygroupdict["age"] = results2.string(forColumn: age)
                                mygrouprow.append(mygroupdict)
                             }
                           myGroupData.append(mygrouprow)
                        }
                        catch
                        {
                            print("catch error")
                        }
                    }
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            database.close()
        }
        
        print("all data 2 group by \(allData)")
        print("group data = \(myGroupData)")
        
        for dict in allData as [[String:String]]
        {
          print("name = \(dict["name"]!)")
        }
        
        
        //****************** group data print from object ***************************
        // array with name anuj
        
        var shortedArray = [[[String:String]]]()
        
        for element in myGroupData as [[[String:String]]]
        {
            print("************")
            for subelement in element as [[String:String]]
            {
                print("name = \(subelement["name"]!)")
                print("age = \(subelement["age"]!)")
            }
            
            //**************** filter dictionary according to name star
           let foundItems = element.filter {($0["name"] as! String) == "anuj" }
           print("fount Items = \(foundItems)")
          
            if foundItems.count > 0
            {
                shortedArray.append(foundItems)
            }
            //**************** filter dictionary according to name end
            
            print("***********")
        }
        
        
        // **************** group data object as json string start *******************
        
        print("shorted Array = \(shortedArray)")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(myGroupData)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        print("json string = \(json!)")
        // **************** group data object as json string end *******************
        
        return allData as! [AnyObject]
    }
    
    func deleteCategory(recievename:String)->Bool
     {
        var deleted = false
        if openDatabase()
        {
            let query = "delete from  categories where \(name) = ?"
            do
            {
                try database.executeUpdate(query, values:[recievename])
                deleted = true
                print("data deleted successfully")
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }
    
    func deleteUser(recieveID:String)->Bool
    {
        var deleted = false
        if openDatabase()
        {
            let query = "delete from  users where \(id) = ?"
            do
            {
                try database.executeUpdate(query, values:[recieveID])
                deleted = true
                print("data deleted successfully")
            }
            catch
            {
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }
    
}

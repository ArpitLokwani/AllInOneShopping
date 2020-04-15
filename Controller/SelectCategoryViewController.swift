//
//  SelectCategoryViewController.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 03/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import SendBirdSDK
import SwiftyJSON
import SQLite3
class SelectCategoryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,SBDChannelDelegate{
    
    var nameArr = NSMutableArray()
    var descArr = NSMutableArray()
    var urlArr = NSMutableArray()
    var diseaseIDArr = NSMutableArray()
    var selectedIndex = 0
    var isValueSelected = false
    var isRecordFound = ""
    var vSpinner : UIView?
    var responeDat:JSON? = nil
    var categoryArr:[CatergoryModal] = []
    var dbs:DBHelper = DBHelper()
    var persons:[Category] = []
    var catArr = NSMutableArray()
    var catIdArr = NSMutableArray()
    
    

    
       
    @IBAction func continueButtonPressed(_ sender: Any) {
        isValueSelected = true
        if isValueSelected == false {
            let alert = UIAlertController(title: "Alert", message: "Please Select any Disease",  preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Alert",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
           
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "VirusTrackerBaseViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    
    
    func getChatID() -> Void {
        let selectedCategoryIDs: Int =  UserDefaults.standard.integer(forKey: "selectedCategoryID")
       // self.showSpinner(onView: self.view)

        APIManager.sharedInstance.getChatID(id: 0,onSuccess: { json in
                            DispatchQueue.main.async {
                                print(json)
                                for book in json["data"].arrayValue
                                {
                                    let chatID = book["chat_key"].string
                                    SBDMain.initWithApplicationId(chatID!)
                                    SBDMain.add(self as SBDChannelDelegate, identifier: self.description)

                                        
                                }
                                DispatchQueue.main.async {
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VirusTrackerBaseViewController") as? VirusTrackerBaseViewController
                                               if let selectedIndexValue = UserDefaults.standard.string(forKey: "selectedCategoryIndex"){
                                                self.selectedIndex = Int(selectedIndexValue)!
                                               }
                                               
                                               let selectedCategoryIDs:String = self.catIdArr.object(at: self.selectedIndex) as! String
                                               
                                               //UserDefaults.standard.set(selectedCategoryID, forKey: "selectedCategoryIDs")
                                                      UserDefaults.standard.set("YES", forKey: "isDiseaseSelected")
                                                      //setObject
                                                             vc!.selectedDiseaseID = self.diseaseIDArr.object(at: self.selectedIndex) as! String
                                               vc?.isRecordFounds = self.isRecordFound

                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }
                                
                            }
                        }, onFailure: { error in
                            
                           
                        })
    }
    
    

    func setupTableView() {
     
        let textFieldCell = UINib(nibName: "DiseaseTableViewCell", bundle: nil)
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "DiseaseTableViewCell")
    
     
     tableView.delegate = self
     tableView.dataSource = self
     
     let continueButton = UIButton()
     continueButton.frame = CGRect.init(x: 40, y:self.view.frame.size.height-50, width: self.view.frame.size.width-80, height: 40)
    // continueButton.titleLabel?.text = "Continue"
     continueButton.setTitle("Continue", for: .normal)
    // continueButton.backgroundColor = UIColor.red
     //view.addSubview(continueButton)
     continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
    }
//            super.viewDidLoad()
//        SBDMain.disconnect(completionHandler: nil)
//        if #available(iOS 13.0, *) {
//                          overrideUserInterfaceStyle = .light
//                      } else {
//                          // Fallback on earlier versions
//                      }
//            self.title = "Select Category"
//            setupTableView()
//            let uiImage = UIImage(named: "background")
//            let backgroundColor = UIColor(patternImage: uiImage!)
//            self.view.backgroundColor = backgroundColor
//            tableView.backgroundColor = UIColor.clear
//
//
//        APIManager.sharedInstance.getAllCategories(id: 0, onSuccess: { json in
//                  DispatchQueue.main.async {
//                      let jsonMessage:String = json["msg"].string!
//                    print(json)
//                      if(jsonMessage == "No Records found"){
//
//                      }else{
//
//                        for category in json["data"].arrayValue{
//                            let cat = CatergoryModal(userJSON: category)
//                            print(cat.SNo)
//                            print(cat.CategoryId)
//                            print(cat.Name)
//                            print(cat.PlayStore_Url)
//                            print(cat.AppleStore_Url)
//                            print(cat.Description)
//                            print(cat.Redirect_Link_1)
//                            print(cat.Actutal_Reditrect)
//                            print(cat.IsActive)
//                            print(cat.Count)
//                            print(cat.CategoryName)
//                            print(cat.CategoryImagePng)
//
//
//                            self.dbs.insertInto(SNo: cat.SNo, CategoryId: cat.CategoryId, Name: cat.Name, PlayStore_Url: cat.PlayStore_Url, AppleStore_Url: cat.AppleStore_Url, Description: cat.Description, Redirect_Link_1: cat.Redirect_Link_1, Actutal_Reditrect: cat.Actutal_Reditrect, IsActive: cat.IsActive, Count: cat.Count, CategoryName: cat.CategoryName,CategoryImagePng: cat.CategoryImagePng,chatID: cat)
//
//
//
//                           // self.persons = self.dbs.readCatoegory()
//
//                            self.categoryArr.append(cat)
//
//
//
//                        }
//                        self.db = self.openDatabase()
//
//                        self.getCategoriesFromDB()
//
//                        print(self.persons.count)
//
//
//                       print(self.categoryArr.count)
//                        DispatchQueue.main.async {
//                        self.tableView.reloadData()
//
//                        }
//
//                      }
//
//                  }
//
//              }, onFailure: { error in
//                  let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                  alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                  self.show(alert, sender: nil)
//              })
//
//
//
//            // Do any additional setup after loading the view.
//        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              // 1
        return self.catArr.count
    }
          
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              // 2
        tableView.separatorColor = UIColor.white
              let cell = tableView.dequeueReusableCell(withIdentifier: "DiseaseTableViewCell", for: indexPath) as! DiseaseTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        if let selectedIndex = UserDefaults.standard.object(forKey: "selectedCategoryIndex") as? Int{
                  if selectedIndex == indexPath.row {
                      cell.accessoryType = .checkmark
                  }else{
                      cell.accessoryType = .none
                  }
              }
        
        
       

            if(self.catArr.count>0){
                let basicCat = self.catArr[indexPath.row]
                
                cell.DiseaseNameLabel.text = basicCat as! String
                cell.DiseaseNameLabel.textColor = UIColor.black
                
                cell.DiseaseNameLabel.textColor = UIColor.white

            }
              return cell
          }
          
          
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 60
          }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func resetChecks() {
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isValueSelected = true
        let allCell = getAllCells()
        print(allCell)
        if let cell = tableView.cellForRow(at: indexPath) {
            resetChecks()
            cell.accessoryType = .checkmark
        }
        

        
        selectedIndex = indexPath.row

        UserDefaults.standard.set(selectedIndex, forKey: "selectedCategoryIndex") //setObject
        let selectedCategoryID:String = self.self.catIdArr.object(at: selectedIndex) as! String
        UserDefaults.standard.set(selectedCategoryID, forKey: "selectedCategoryID")
      
        
        
        
        let categoryName:String = self.catArr.object(at: indexPath.row) as! String
        UserDefaults.standard.set(categoryName, forKey: "selectedCategoryName") //setObject
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    
    func getAllCells() -> [DiseaseTableViewCell] {

       var cells = [DiseaseTableViewCell]()
       // assuming tableView is your self.tableView defined somewhere
       for i in 0...tableView.numberOfSections-1
       {
        for j in 0...tableView.numberOfRows(inSection: 0)
           {
            //  let rowsCount = self.tableView.numberOfRows(inSection: indexPath.section)
            
            if let cell = tableView.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) {

                cells.append(cell as! DiseaseTableViewCell)
               }

           }
       }
    return cells
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var db:OpaquePointer?
    let dbPath: String = "CategoryDB.sqlite"

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
    func getCategoriesFromDB() -> Void {
        let queryStatementString = "SELECT DISTINCT CategoryName,CategoryId FROM cateogry "
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                    while sqlite3_step(queryStatement) == SQLITE_ROW {
                        let categoryName = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                        let categoryID = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                        self.catArr.add(categoryName)
                        self.catIdArr.add(categoryID)
                        
                    }
                    print(self.catArr.count)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("SELECT statement could not be prepared")
                }
                sqlite3_finalize(queryStatement)

    }
    
}

//
//  NewCategoryViewController.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 10/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import SendBirdSDK
import SwiftyJSON
import SQLite3
import SwiftKeychainWrapper
class NewCategoryViewController: UIViewController,SBDChannelDelegate {
    var responeDat:JSON? = nil
    var categoryArr:[CatergoryModal] = []
    var dbs:DBHelper = DBHelper()
    var persons:[Category] = []
    var catArr = NSMutableArray()
    var catIdArr = NSMutableArray()
    var isValueSelected = false
    var scrollView: UIScrollView!
    var descriptionArr = NSMutableArray()
    
    var categoryViewArr = NSMutableArray()
    
    var selectedIndex = 0
    
    func setSelectedCatView() -> Void {
        if let selectedInd = UserDefaults.standard.object(forKey: "selectedCategoryIndex") as? Int{


            selectedIndex = selectedInd
            
            isValueSelected = true
            if(categoryViewArr.count>0){
                for i in 0...self.categoryViewArr.count-1{
                    
                    var view = UIView()
                    view = self.categoryViewArr.object(at: i) as! UIView
                    if(view.tag == selectedIndex){
                        view.layer.borderWidth = 6
                        view.layer.borderColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 0.5).cgColor
                        
                      
                        
                    }else{
                        view.layer.borderWidth = 1
                        view.layer.borderColor = UIColor.lightGray.cgColor
                        
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Select Category"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        getCategoriesFromDB()
        setupView()
        
        
        APIManager.sharedInstance.getAllCategories(id: 0, onSuccess: { json in
            DispatchQueue.main.async {
                let jsonMessage:String = json["msg"].string!
                print(json)
                if(jsonMessage == "No Records found"){
                    
                }else{
                    
                    let chatID = json["chatId"].string
                    print(chatID!)
                    SBDMain.initWithApplicationId(chatID!)
                    SBDMain.add(self as! SBDChannelDelegate, identifier: self.description)
                    self.createConnection()
                    
                    
                    for category in json["data"].arrayValue{
                        let cat = CatergoryModal(userJSON: category)
                        
                        
                        self.dbs.insertInto(SNo: cat.SNo, CategoryId: cat.CategoryId, Name: cat.Name, PlayStore_Url: cat.PlayStore_Url, AppleStore_Url: cat.AppleStore_Url, Description: cat.Description, Redirect_Link_1: cat.Redirect_Link_1, Actutal_Reditrect: cat.Actutal_Reditrect, IsActive: cat.IsActive, Count: cat.Count, CategoryName: cat.CategoryName,CategoryImagePng:cat.CategoryImagePng,chatID:chatID! )
                        
                        
                        
                        // self.persons = self.dbs.readCatoegory()
                        
                        self.categoryArr.append(cat)
                        
                        
                        
                    }
                    self.db = self.openDatabase()
                    
                    self.getCategoriesFromDB()
                    
                    //  print(self.persons.count)
                    
                    
                    //  print(self.categoryArr.count)
                    DispatchQueue.main.async {
                        self.setupView()
                        self.setSelectedCatView()
                        
                    }
                    
                }
                
            }
            
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
        
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        var contentSize = 0
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var j = 0
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        
        var categoryContentSize = 20
        var catXAxis = 10
        
        let countValue = self.catArr.count/3
        var jj = 0
        var k = 0
        for i in 0...countValue{
            catXAxis = 30
            
            
            if(i<self.catArr.count){
                
                if(jj<self.catArr.count){
                    
                    let mainCategoryView = UIView()
                    mainCategoryView.frame = CGRect(x: catXAxis, y: categoryContentSize, width: 80, height: 80)
                    scrollView.addSubview(mainCategoryView)
                    mainCategoryView.layer.borderWidth = 0.5
                    mainCategoryView.layer.borderColor = UIColor.lightGray.cgColor
                    mainCategoryView.layer.cornerRadius = 20
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(categoryView3ImageViewTapped(tapGestureRecognizer:)))
                    mainCategoryView.isUserInteractionEnabled = true
                    mainCategoryView.tag = jj

                    let categoryView1 = UIImageView()
                    categoryView1.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
                    mainCategoryView.addSubview(categoryView1)
                    // categoryView1.backgroundColor = UIColor.red
                    
                    categoryView1.contentMode = .scaleAspectFit
                    categoryView1.clipsToBounds = true
                    mainCategoryView.addGestureRecognizer(tapGestureRecognizer)
                    categoryView1.backgroundColor = UIColor.white
                    
                    categoryViewArr.add(mainCategoryView)

                    let imageName = self.descriptionArr[jj]
                    
                    guard let name = imageName as? String else {
                        print("something went wrong, name can not be cast to String")
                        return
                    }
                    
                    //                                      if let url = URL(string: "http://smartlycompare.com/allinone/application/assets/imgs/logo/\(name)") {
                    
                    
                    if let url = URL(string: "http://smartlycompare.com/allinone/application/assets/imgs/logo/\(name)") {
                        
                        
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.async() {    // execute on main thread
                                categoryView1.image = UIImage(data: data)
                            }
                        }
                        
                        task.resume()
                    }
                    let categoryView1Label = UILabel()
                    categoryView1Label.frame = CGRect(x: catXAxis-10, y: categoryContentSize+85, width: 100, height: 15)
                    scrollView.addSubview(categoryView1Label)
                    categoryView1Label.text = self.catArr.object(at: jj) as! String
                    categoryView1Label.textAlignment = .center
                    categoryView1Label.font = UIFont.systemFont(ofSize: 12)
                    let selectedColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0)
                    categoryView1Label.textColor = selectedColor
                    catXAxis = Int(screenWidth/2-40)
                    jj += 1
                }
                
            }
            
            if(i+1<self.catArr.count){
                
                if(jj<self.catArr.count){
                    let mainCategoryView = UIView()
                    mainCategoryView.frame = CGRect(x: catXAxis, y: categoryContentSize, width: 80, height: 80)
                    scrollView.addSubview(mainCategoryView)
                    mainCategoryView.layer.borderWidth = 0.5
                    mainCategoryView.layer.borderColor = UIColor.lightGray.cgColor
                    mainCategoryView.layer.cornerRadius = 20
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(categoryView3ImageViewTapped(tapGestureRecognizer:)))
                    mainCategoryView.isUserInteractionEnabled = true
                    
                    
                    
                    let categoryView2 = UIImageView()
                    categoryView2.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
                    mainCategoryView.addSubview(categoryView2)
                    
                    categoryView2.backgroundColor = UIColor.white
                    mainCategoryView.tag = jj
                    categoryViewArr.add(mainCategoryView)
                    
                    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(categoryView3ImageViewTapped(tapGestureRecognizer:)))
                    mainCategoryView.addGestureRecognizer(tapGestureRecognizer1)
                    
                    let imageName = self.descriptionArr[jj]
                    
                    guard let name = imageName as? String else {
                        print("something went wrong, name can not be cast to String")
                        return
                    }
                    if let url = URL(string: "http://smartlycompare.com/allinone/application/assets/imgs/logo/\(name)") {
                        
                        
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.async() {    // execute on main thread
                                categoryView2.image = UIImage(data: data)
                            }
                        }
                        
                        task.resume()
                    }
                    let categoryView2Label = UILabel()
                    categoryView2Label.frame = CGRect(x: catXAxis-10, y: categoryContentSize+85, width: 100, height: 15)
                    scrollView.addSubview(categoryView2Label)
                    categoryView2Label.text = self.catArr.object(at: jj) as! String
                    categoryView2Label.textAlignment = .center
                    categoryView2Label.font = UIFont.systemFont(ofSize: 12)
                    let selectedColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0)
                    categoryView2Label.textColor = selectedColor
                    
                    
                }
                
                
                catXAxis = Int(screenWidth-120)
                
                jj += 1
                
            }
            
            if(i+2<self.catArr.count){
                
                if(jj<self.catArr.count){
                    let mainCategoryView = UIView()
                    mainCategoryView.frame = CGRect(x: catXAxis, y: categoryContentSize, width: 80, height: 80)
                    scrollView.addSubview(mainCategoryView)
                    mainCategoryView.layer.borderWidth = 0.5
                    mainCategoryView.layer.borderColor = UIColor.lightGray.cgColor
                    mainCategoryView.layer.cornerRadius = 20
                    mainCategoryView.isUserInteractionEnabled = true
                    
                 
                    
                    let categoryView3 = UIImageView()
                    categoryView3.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
                    mainCategoryView.addSubview(categoryView3)
                    //  categoryView3.backgroundColor = UIColor.red
                    categoryView3.layer.cornerRadius = 20
                    
                    mainCategoryView.tag = jj
                    categoryViewArr.add(mainCategoryView)
                    categoryView3.backgroundColor = UIColor.white
                    
                    let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(categoryView3ImageViewTapped(tapGestureRecognizer:)))
                    mainCategoryView.addGestureRecognizer(tapGestureRecognizer2)
                    
                    let imageName = self.descriptionArr[jj]
                    
                    guard let name = imageName as? String else {
                        print("something went wrong, name can not be cast to String")
                        return
                    }
                    if let url = URL(string: "http://smartlycompare.com/allinone/application/assets/imgs/logo/\(name)") {
                        
                        
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.async() {    // execute on main thread
                                categoryView3.image = UIImage(data: data)
                            }
                        }
                        
                        task.resume()
                    }
                    let categoryView3Label = UILabel()
                    categoryView3Label.frame = CGRect(x: catXAxis-10, y: categoryContentSize+85, width: 100, height: 15)
                    scrollView.addSubview(categoryView3Label)
                    categoryView3Label.text = self.catArr.object(at: jj) as! String
                    categoryView3Label.textAlignment = .center
                    categoryView3Label.font = UIFont.systemFont(ofSize: 12)
                    let selectedColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0)
                    categoryView3Label.textColor = selectedColor
                }
                
                
                jj += 1
                
                
            }
            
            categoryContentSize += 130
            
        }
        
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(categoryContentSize+100))
        
        
        view.addSubview(scrollView)
        
        let nextButton = UIButton()
        nextButton.frame = CGRect(x:screenWidth-100 , y: screenHeight-110, width: 60, height: 60)
        nextButton.backgroundColor = UIColor.white
        nextButton.layer.cornerRadius = 40
        nextButton.setImage(UIImage(named:"nextButtonIcon80"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)
        
    }
    
    @objc func nextButtonPressed(){
        if isValueSelected == false {
            let alert = UIAlertController(title: "Alert", message: "Please Select any Category",  preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            
            
            UserDefaults.standard.set(selectedIndex, forKey: "selectedCategoryIndex") //setObject
            let selectedCategoryID:String = self.self.catIdArr.object(at: selectedIndex) as! String
            UserDefaults.standard.set(selectedCategoryID, forKey: "selectedCategoryID")
            
            UserDefaults.standard.set("YES", forKey: "isCategorySelected")
            
            
            let categoryName:String = self.catArr.object(at: selectedIndex) as! String
            UserDefaults.standard.set(categoryName, forKey: "selectedCategoryName") //setObject
            
            
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "VirusTrackerBaseViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    @objc func categoryView3ImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        isValueSelected = true

        let tappedImage = tapGestureRecognizer.view!
        let tag = tappedImage.tag
        print(tag)
        selectedIndex = tag
         UserDefaults.standard.set(selectedIndex, forKey: "selectedCategoryIndex")
        for i in 0...self.categoryViewArr.count-1{
            
            var view = UIView()
            view = self.categoryViewArr.object(at: i) as! UIView
            if(view.tag == tag){
                view.layer.borderWidth = 6
                view.layer.borderColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 0.5).cgColor
                
              //  view.dropShadow(color: UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0), opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
                
            }else{
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.lightGray.cgColor
                
            }
        }
        
        
        // VirusTrackerWebViewController
        
        // Your action
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
        let queryStatementString = "SELECT DISTINCT CategoryName,CategoryId,CategoryImagePng FROM cateogry "
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let categoryName = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let categoryID = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                self.catArr.add(categoryName)
                self.catIdArr.add(categoryID)
                self.descriptionArr.add(description)
                
            }
            print(self.catArr.count)
            DispatchQueue.main.async {
                // self.setupView()
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
    }
    
    func getUDIDofDevice() -> String {
        //Check is uuid present in keychain or not
        if let deviceId: String = KeychainWrapper.standard.string(forKey: "deviceId") {
            return deviceId
        }else{
            // if uuid is not present then get it and store it into keychain
            let key : String = (UIDevice.current.identifierForVendor?.uuidString)!
            let saveSuccessful: Bool = KeychainWrapper.standard.set(key, forKey: "deviceId")
            print("Save was successful: \(saveSuccessful)")
            return key
        }
    }
    
    func createConnection() {
        let identifier = getUDIDofDevice()
                    print(identifier)
                    
                    let userdefaults = UserDefaults.standard
                    
                    var nickName = ""
                    if let userName = userdefaults.string(forKey: "\(identifier)"){
                        print(userName)
                        nickName = userName
                        UserDefaults.standard.set(userName, forKey: "\(identifier)") //setObject

                    } else {
                        let name:String = getName()
                               
                      let newName:String = "i_" + name
                        nickName = newName
                        UserDefaults.standard.set(newName, forKey: "UserName") //setObject
                        UserDefaults.standard.set(newName, forKey: "\(identifier)") //setObject
                    }
        
        ConnectionManager.login(userId: identifier, nickname: nickName) { user, error in
            
           if(error == nil){
               print(user?.profileUrl)
               UserDefaults.standard.set(user?.profileUrl!, forKey: "UserProfileImageURL")

           }
            guard error == nil else {
                
                return
            }
            
        }

    }
    
    func getName(length: Int = 7)->String{

        enum s {
            static let c = Array("abcdefghjklmnpqrstuvwxyz12345789")
            static let k = UInt32(c.count)
        }

        var result = [Character](repeating: "-", count: length)

        for i in 0..<length {
            let r = Int(arc4random_uniform(s.k))
            result[i] = s.c[r]
        }

        return String(result)
    }
    
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 2
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

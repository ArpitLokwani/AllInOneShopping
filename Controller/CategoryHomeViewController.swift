    //
    //  CategoryHomeViewController.swift
    //  AllInOne
    //
    //  Created by Arpit Lokwani on 06/04/20.
    //  Copyright © 2020 SendBird. All rights reserved.
    //
    
    import UIKit
    import SQLite3
    import SwiftKeychainWrapper
    import SendBirdSDK
    class CategoryHomeViewController: UIViewController,UITextFieldDelegate,SBDChannelDelegate {
        
        
        var CategoryIdArr = NSMutableArray()
        var NameArr = NSMutableArray()
        var Playstore_UrlArr = NSMutableArray()
        var Redirect_Link_1Arr = NSMutableArray()
        var DescriptionArr = NSMutableArray()
        var Actual_RedirectURLArr = NSMutableArray()
        
        
        var vSpinner : UIView?
        
        var scrollView: UIScrollView!
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            self.navigationController?.navigationBar.isTranslucent = false

            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                // Fallback on earlier versions
            }
            return .lightContent
        }
        
        
        
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            self.tabBarController?.tabBar.isHidden = false
            navigationController?.navigationBar.barTintColor = UIColor.white
            
            
            //      UINavigationBar.appearance().barTintColor = .white
            //        UINavigationBar.appearance().tintColor = .white
            //        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            //        self.view.backgroundColor = UIColor.white
            
        }
        
        func setupView() {
            scrollView = UIScrollView(frame: view.bounds)
            scrollView.backgroundColor = UIColor.white
            var contentSize = 0
            scrollView.layer.borderWidth = 1
            scrollView.layer.borderColor = UIColor.lightGray.cgColor
            let screenSize: CGRect = UIScreen.main.bounds
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.bounces = false
            
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            
            
            
            var j = 0
            if(self.NameArr.count>0){
                for i in 0...self.NameArr.count-1{
                    
                    if(j<self.NameArr.count-1){
                        var xAxis = 0
                        
                        let collectionView = UIView()
                        collectionView.frame = CGRect(x: Int(xAxis), y: Int(contentSize), width: Int(screenWidth/2), height: Int(screenHeight/5))
                        // collectionView.backgroundColor = UIColor.yellow
                        
                        scrollView.addSubview(collectionView)
                        xAxis += Int(screenWidth/2)
                        
                        
                        let leftImageView = UIImageView()
                        leftImageView.frame = CGRect(x: 10, y: 10, width: Int(screenWidth/2)-20, height: Int(screenHeight/5)-20)
                        // leftImageView.backgroundColor = UIColor.lightGray
                        collectionView.addSubview(leftImageView)
                        leftImageView.tag = j
                        
                        
                        let underlineView = UIView()
                        underlineView.frame = CGRect(x:0, y: (Int(screenHeight/5)-1), width: Int(screenWidth/2), height: 1)
                        underlineView.backgroundColor = UIColor.lightGray
                        collectionView.addSubview(underlineView)
                        
                        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(leftImageViewTapped(tapGestureRecognizer:)))
                        leftImageView.isUserInteractionEnabled = true
                        leftImageView.addGestureRecognizer(tapGestureRecognizer1)
                        leftImageView.contentMode = .scaleAspectFit
                        print(j)
                        
                        
                        
                        let imageName = self.DescriptionArr[j]
                        
                        guard let name = imageName as? String else {
                            print("something went wrong, name can not be cast to String")
                            return
                        }
                        
                        if let url = URL(string: "http://smartlycompare.com/allinone/application/assets/imgs/logo/\(name)") {
                            
                            
                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data, error == nil else { return }
                                
                                DispatchQueue.main.async() {    // execute on main thread
                                    leftImageView.image = UIImage(data: data)
                                }
                            }
                            
                            task.resume()
                            
                        } else {
                            print("could not open url, it was nil")
                        }
                        
                        
                        if(j < self.NameArr.count){
                            j = j+1
                            
                        }
                        
                        // *********** Border *********//
                        
                        let verticalBorder = UIView()
                        verticalBorder.frame = CGRect(x:Int(xAxis)-1, y: Int(contentSize), width: 1, height: Int(screenHeight/5))
                        verticalBorder.backgroundColor = UIColor.lightGray
                        scrollView.addSubview(verticalBorder)
                        
                        
                       
                        
                        
                        if(j < self.NameArr.count){
                            //************* Right collection view *************//
                            
                            let collectionView2 = UIView()
                            collectionView2.frame = CGRect(x: Int(xAxis), y: Int(contentSize), width: Int(screenWidth/2), height: Int(screenHeight/5))
                            // collectionView2.backgroundColor = UIColor.red
                            scrollView.addSubview(collectionView2)
                            
                            let rightImageView = UIImageView()
                            rightImageView.frame = CGRect(x: 10, y: 10, width: Int(screenWidth/2)-20, height: Int(screenHeight/5)-20)
                            rightImageView.contentMode = .scaleAspectFit
                            //rightImageView.backgroundColor = UIColor.lightGray
                            collectionView2.addSubview(rightImageView)
                            rightImageView.tag = j
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightImageViewTapped(tapGestureRecognizer:)))
                            rightImageView.isUserInteractionEnabled = true
                            rightImageView.addGestureRecognizer(tapGestureRecognizer)
                            
                            let underlineView = UIView()
                            underlineView.frame = CGRect(x:0, y: (Int(screenHeight/5)-1), width: Int(screenWidth/2), height: 1)
                            underlineView.backgroundColor = UIColor.lightGray
                            collectionView2.addSubview(underlineView)
                            
                            let imageName1 = self.DescriptionArr[j]
                            
                            guard let name1 = imageName1 as? String else {
                                print("something went wrong, name can not be cast to String")
                                return
                            }
                            
                            if let url = URL(string: "http://smartlycompare.com/allinone/application/assets/imgs/logo/\(name1)") {
                                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    
                                    DispatchQueue.main.async() {    // execute on main thread
                                        rightImageView.image = UIImage(data: data)
                                    }
                                }
                                
                                task.resume()
                                
                            } else {
                                print("could not open url, it was nil")
                            }
                            
                        }
                        if(j < self.NameArr.count-1){
                            j = j+1
                            
                        }
                        
                        
                        
                        
                        
                        
                        contentSize += Int(screenHeight/5)
                        
                        
                        
                        
                        
                    }
                    
                    
                }
            }
            scrollView.contentSize = CGSize(width: Int(screenWidth), height: contentSize)
            
            view.addSubview(scrollView)
        }
        
        @objc func rightImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            let tag = tappedImage.tag
            print(tag)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VirusTrackerWebViewController") as? VirusTrackerWebViewController
            vc?.titleName = self.NameArr.object(at: tag) as! String
            vc?.urlString = self.Actual_RedirectURLArr.object(at: tag) as! String
            self.navigationController?.pushViewController(vc!, animated: true)
            
            // VirusTrackerWebViewController
            
            // Your action
        }
        
        @objc func leftImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            let tag = tappedImage.tag
            print(tag)
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VirusTrackerWebViewController") as? VirusTrackerWebViewController
            vc?.titleName = self.NameArr.object(at: tag) as! String

            vc?.urlString = self.Actual_RedirectURLArr.object(at: tag) as! String
            self.navigationController?.pushViewController(vc!, animated: true)
            
            // Your action
        }
        
        
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
            if let selectedCat = UserDefaults.standard.object(forKey: "selectedCategoryName") as? String{
                
                var wiseWords = "\"\(selectedCat)\""
                var queryStatementString = ""
                if let dotRange = wiseWords.range(of: "'") {
                    wiseWords.removeSubrange(dotRange.lowerBound..<wiseWords.endIndex)
                    
                    wiseWords = wiseWords.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
                    
                    queryStatementString = "SELECT CategoryId,Name,Playstore_Url,Redirect_Link_1,Description,Actutal_Reditrect,chatID FROM cateogry WHERE CategoryName LIKE '%\(wiseWords)%'"
                    
                }else{
                    
                    
                    queryStatementString = "SELECT CategoryId,Name,Playstore_Url,Redirect_Link_1,Description,Actutal_Reditrect,chatID FROM cateogry WHERE CategoryName = \(wiseWords)"
                    
                    
                }
                
                
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                    while sqlite3_step(queryStatement) == SQLITE_ROW {
                        let CategoryId = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                        let Name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                        let Playstore_Url = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                        let Redirect_Link_1 = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                        let Description = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                        let Actual_Redirect = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                        
                        let chatID = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                        SBDMain.initWithApplicationId(chatID)
                        SBDMain.add(self as! SBDChannelDelegate, identifier: self.description)
                        print(CategoryId)
                        print(Name)
                        print(Playstore_Url)
                        print(Redirect_Link_1)
                        print(Description)
                        
                        self.CategoryIdArr.add(CategoryId)
                        self.NameArr.add(Name)
                        self.Playstore_UrlArr.add(Playstore_Url)
                        self.Redirect_Link_1Arr.add(Redirect_Link_1)
                        self.DescriptionArr.add(Description)
                        self.Actual_RedirectURLArr.add(Actual_Redirect)
                        print(self.DescriptionArr)
                        print(self.NameArr)
                        
                        
                        //self.catArr.add(categoryName)
                    }
                    print(self.NameArr.count)
                    DispatchQueue.main.async {
                        // self.setupView()
                        self.createConnection()
                        
                        //  self.tableView.reloadData()
                    }
                } else {
                    print("SELECT statement could not be prepared")
                }
                sqlite3_finalize(queryStatement)
                
                
            }
            
            
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.db = self.openDatabase()
            getCategoriesFromDB()
            self.setupView()
            
            
            
            self.view.backgroundColor = UIColor.white
            
//            if #available(iOS 13.0, *) {
//                overrideUserInterfaceStyle = .light
//            } else {
//                // Fallback on earlier versions
//            }
            
            
            
            
            //  self.title = "Home"
            
            if let selectedCat = UserDefaults.standard.object(forKey: "selectedCategoryName") as? String{
                self.navigationItem.title  = selectedCat
                let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
                navigationController?.navigationBar.titleTextAttributes = textAttributes
                
                
            }
            
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategoryTapped))
            
            // navigationItem.rightBarButtonItems = [add]
            
            
            // setupView()
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            self.navigationController?.addCustomBottomLine(color: UIColor.gray, height: 0.6)
            
            //headerTitleColor
            //        let headerTitleColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0)
            //        let textAttributes = [NSAttributedString.Key.foregroundColor:headerTitleColor]
            //        navigationController?.tab.titleTextAttributes = textAttributes
            
            UITabBar.appearance().backgroundColor = UIColor(red:1, green:0, blue:0, alpha:1)
            
            
            self.tabBarController!.tabBar.layer.borderWidth = 0.50
            self.tabBarController!.tabBar.layer.borderColor = UIColor.lightGray.cgColor
            self.tabBarController?.tabBar.clipsToBounds = true
            // Do any additional setup after loading the view.
        }
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true;
        }
        
        @objc func addCategoryTapped() -> Void {
            let alert = UIAlertController(title: "Add Category", message: "Please enter details", preferredStyle: UIAlertController.Style.alert )
            //Step : 2
            let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                let textField2 = alert.textFields![1] as UITextField
                let textField3 = alert.textFields![2] as UITextField
                
                if textField.text == ""{
                    self.showSmallToast(message: "Category required")
                    
                }else if(textField2.text == ""){
                    self.showSmallToast(message: "AppName required")
                    
                }else if(textField3.text == "") {
                    self.showSmallToast(message: "AppUrl required")
                    
                }else{
                    self.showToast(message: "Thanks for sharing information !! . Its under review by panel")
                }
                
                //               if textField.text != "" {
                //                   //Read TextFields text data
                //                   print(textField.text!)
                //                   print("TF 1 : \(textField.text!)")
                //               } else {
                //                   print("TF 1 is Empty...")
                //               }
                //
                //               if textField2.text != "" {
                //                   print(textField2.text!)
                //                   print("TF 2 : \(textField2.text!)")
                //               } else {
                //                   print("TF 2 is Empty...")
                //
                //               }
                //            if textField3.text != "" {
                //                print(textField3.text!)
                //                print("TF 2 : \(textField2.text!)")
                //            } else {
                //                print("TF 2 is Empty...")
                //
                //            }
                //            if(textField.text != nil && textField2.text != nil && textField3.text != nil){
                //
                //            }
                
                
            }
            
            //Step : 3
            alert.addTextField { (textField) in
                textField.delegate = self
                
                textField.placeholder = "Enter category name"
                textField.textColor = .red
            }
            
            //For first TF
            alert.addTextField { (textField) in
                textField.delegate = self
                
                textField.placeholder = "Enter App name"
                textField.textColor = .red
            }
            //For second TF
            alert.addTextField { (textField) in
                textField.delegate = self
                
                textField.placeholder = "Enter App URL"
                textField.textColor = .blue
            }
            
            //Step : 4
            alert.addAction(save)
            //Cancel action
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
            alert.addAction(cancel)
            //OR single line action
            //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
            
            self.present(alert, animated:true, completion: nil)
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
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
    
    extension UINavigationController
    {
        func addCustomBottomLine(color:UIColor,height:Double)
        {
            //Hiding Default Line and Shadow
            navigationBar.setValue(true, forKey: "hidesShadow")
            
            //Creating New line
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width:0, height: height))
            lineView.backgroundColor = color
            navigationBar.addSubview(lineView)
            
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            lineView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        }
    }
    

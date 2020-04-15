//
//  MainViewController.swift
//  SendBird-iOS
//
//  Created by Arpit Lokwani on 20/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftKeychainWrapper
class MainViewController: UIViewController,UITableViewDelegate,  UITableViewDataSource,GMSMapViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {
    
    var finalCountryArrs = NSArray()
    var shouldShowSearchResults = false
    
    var searchController =  UISearchController()
    var countryCaseSortedDict = NSMutableDictionary()
    var vSpinner : UIView?

    override func viewWillAppear(_ animated: Bool) {
       
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white

        
    }

    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false

        // Place the search bar view to the tableview headerview.
        tableview.tableHeaderView = searchController.searchBar
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableview.reloadData()
        }
     
        searchController.searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableview.reloadData()
    }
     
     
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableview.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if(searchString?.count == 0){
        self.finalCountryArrs = self.finalCountryArr
            tableview.reloadData()
        }else{
            // Filter the data array and get only those countries that match the search text.
            finalCountryArrs = finalCountryArr.filter({ (country) -> Bool in
            let countryText: NSString = country as! NSString
                return (countryText.range(of: searchString ?? "", options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                          }) as NSArray

            tableview.reloadData()
            
        }
    }
    
    
    
    var mapView : GMSMapView!
    
    var countryNameArr = NSMutableArray()
    var longArr = NSMutableArray()
    var latArr = NSMutableArray()
    var stateArr = NSMutableArray()
    var deathsArr = NSMutableArray()
    var confirmedTotal = 0
    var recoveredTotal = 0
    var deathsTotal = 0
    
    var countryDataDict = NSMutableDictionary()
    var uniqueCountriesNamesArr = NSArray()
    var allSortedCountriesName = NSArray()
    var allSortedCountriesValuesName = NSArray()
    var countryActualDataDict = NSMutableDictionary()
    var allKeys = NSArray()
    var allValues = NSArray()
    var COUNTRIESARR = NSMutableArray()
    var CASESARR = NSMutableArray()
    var finalCountryArr = NSArray()
    var finalCaseCountArr = NSMutableArray()
    var DATAARR = NSMutableArray()
    var headerCustomView = UIView()
    
    
    var totalConfirmedlabel = UILabel()
    var totalConfirmedValueLabel = UILabel()
    
    var activeLabel = UILabel()
    var activeValueLabel = UILabel()
    var recoveredLabel = UILabel()
    var recoveredValueLabel = UILabel()
    var fatalLabel = UILabel()
    var fatalValueLabel = UILabel()
    
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    func setupTableView() {
        
    headerCustomView.frame = CGRect.init(x: 0, y:80, width: self.view.frame.size.width, height: 249)
               headerCustomView.backgroundColor = UIColor.white
      view.addSubview(headerCustomView)
    
    totalConfirmedlabel.frame = CGRect.init(x: 10, y:10, width: self.view.frame.size.width-30, height: 25)
    totalConfirmedlabel.text = "Total Confirm Cases"
    totalConfirmedlabel.textAlignment = .center
    totalConfirmedlabel.textColor = UIColor.darkGray
    totalConfirmedlabel.font = UIFont.systemFont(ofSize: 15.0)
   // totalConfirmedlabel.backgroundColor = UIColor.red
    headerCustomView.addSubview(totalConfirmedlabel)
        
    totalConfirmedValueLabel.frame = CGRect.init(x: 10, y:40, width: self.view.frame.size.width-30, height: 25)
    totalConfirmedValueLabel.text = "\(confirmedTotal)"
    totalConfirmedValueLabel.textColor = UIColor.red
    totalConfirmedValueLabel.textAlignment = .center

    totalConfirmedValueLabel.font = UIFont.systemFont(ofSize: 25)
   // totalConfirmedValueLabel.backgroundColor = UIColor.red
    headerCustomView.addSubview(totalConfirmedValueLabel)
        
    let activeLabelCircularView = UIView()
    activeLabelCircularView.frame = CGRect.init(x: 10, y:80, width: 10, height: 10)
    activeLabelCircularView.backgroundColor = UIColor.systemOrange
    activeLabelCircularView.layer.cornerRadius = 5
    headerCustomView.addSubview(activeLabelCircularView)
        
    activeLabel.frame = CGRect.init(x: 25, y:75, width: self.view.frame.size.width/2, height: 20)
        activeLabel.text = "Active Cases"
        activeLabel.font = UIFont.systemFont(ofSize: 15)
       // activeLabel.backgroundColor = UIColor.green
        headerCustomView.addSubview(activeLabel)
        
        activeValueLabel.frame = CGRect.init(x: self.view.frame.size.width/2, y:75, width: self.view.frame.size.width/2-20, height: 20)
        activeValueLabel.text = "\(confirmedTotal-recoveredTotal+deathsTotal)"
        activeValueLabel.textAlignment = .right
        activeValueLabel.textColor = UIColor.darkGray

        activeValueLabel.font = UIFont.systemFont(ofSize: 15)
       // activeValueLabel.backgroundColor = UIColor.green
        headerCustomView.addSubview(activeValueLabel)
        
        let recoveredLabelCircularView = UIView()
        recoveredLabelCircularView.frame = CGRect.init(x: 10, y:110, width: 10, height: 10)
        recoveredLabelCircularView.backgroundColor = UIColor.green
        recoveredLabelCircularView.layer.cornerRadius = 5
        headerCustomView.addSubview(recoveredLabelCircularView)
        
        recoveredLabel.frame = CGRect.init(x: 25, y:105, width: self.view.frame.size.width/2, height: 20)
        recoveredLabel.text = "Recovered Cases"
        recoveredLabel.font = UIFont.systemFont(ofSize: 15)
       // recoveredLabel.backgroundColor = UIColor.green
        headerCustomView.addSubview(recoveredLabel)
        
        recoveredValueLabel.frame = CGRect.init(x: self.view.frame.size.width/2, y:105, width: self.view.frame.size.width/2-20, height: 20)
        recoveredValueLabel.text = "\(recoveredTotal)"
        recoveredValueLabel.textColor = UIColor.darkGray

        recoveredValueLabel.font = UIFont.systemFont(ofSize: 15)
       // recoveredValueLabel.backgroundColor = UIColor.green
        recoveredValueLabel.textAlignment = .right

        headerCustomView.addSubview(recoveredValueLabel)
        
        
        let fatalLabelCircularView = UIView()
        fatalLabelCircularView.frame = CGRect.init(x: 10, y:140, width: 10, height: 10)
        fatalLabelCircularView.backgroundColor = UIColor.darkGray
        fatalLabelCircularView.layer.cornerRadius = 5
        headerCustomView.addSubview(fatalLabelCircularView)
        
        fatalLabel.frame = CGRect.init(x: 25, y:135, width: self.view.frame.size.width/2, height: 20)
        fatalLabel.text = "Fatal Cases"
        fatalLabel.font = UIFont.systemFont(ofSize: 15)
        //fatalLabel.backgroundColor = UIColor.green
        headerCustomView.addSubview(fatalLabel)
        
        fatalValueLabel.frame = CGRect.init(x: self.view.frame.size.width/2, y:135, width: self.view.frame.size.width/2-20, height: 20)
        fatalValueLabel.text = "\(deathsTotal.delimiter)"
        fatalValueLabel.textColor = UIColor.darkGray

        fatalValueLabel.font = UIFont.systemFont(ofSize: 15)
        fatalValueLabel.textAlignment = .right
       // fatalValueLabel.backgroundColor = UIColor.green
        headerCustomView.addSubview(fatalValueLabel)
        
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.frame = CGRect.init(x: 0, y:250, width: self.view.frame.size.width, height: self.view.frame.size.height-250)
        
        let textFieldCell = UINib(nibName: "ListHeaderTableViewCell", bundle: nil)
        tableview.register(textFieldCell, forCellReuseIdentifier: "ListHeaderTableViewCell")
        
        let textFieldCells = UINib(nibName: "ListCountriesTableViewCell", bundle: nil)
        tableview.register(textFieldCells, forCellReuseIdentifier: "ListCountriesTableViewCell")
        // Place the search bar in the table view's header.
        configureSearchController()
        view.addSubview(tableview)
        
    }
    func setHeaderValues(){
        totalConfirmedValueLabel.text = "\(confirmedTotal.delimiter)"
        fatalValueLabel.text = "\(deathsTotal.delimiter)"
        recoveredValueLabel.text = "\(recoveredTotal.delimiter)"
        activeValueLabel.text = "\((confirmedTotal-recoveredTotal-deathsTotal).delimiter)"
    }
    
    
    func callWebService(){
        let selectedDiseaseID: Int =  UserDefaults.standard.integer(forKey: "selectedDiseaseID")
        self.showSpinner(onView: self.view)
        
        
        APIManager.sharedInstance.getAllRecords(diseaseID: selectedDiseaseID, state_id: 0, page: 0, city_id: 0, onSuccess: { json in
            DispatchQueue.main.async {
                let jsonMessage:String = json["msg"].string!
                if(jsonMessage == "No Records found"){
                    DispatchQueue.main.async {
                        self.showToast(message: jsonMessage)
                    }
                }else{
                    self.removeSpinner()
                    
                }
                
                for dict in json["data"].arrayValue
                    
                {
                    let country = dict["country"].string
                    
                    let lati = dict["latitude"].string
                    let longi = dict["longitude"].string
                    let death = dict["deaths"].string
                    let state = dict["state"].string
                    let confirmed = dict["confirmed"].string
                    let recovered = dict["recovered"].string
                    let deaths = dict["deaths"].string
                    
                    var confirmInt:Int = 0
                    var recoveredInt:Int = 0
                    var deathsInt:Int = 0
                    
                    if(confirmed!.count>0){
                        confirmInt = Int(confirmed!)!
                        
                    }
                    
                    if(recovered!.count>0){
                        recoveredInt = Int(recovered!)!
                        
                    }
                    
                    if(deaths!.count>0){
                        deathsInt = Int(deaths!)!
                        
                    }
                    
                    let totalCases:Int = confirmInt
                    
                    self.COUNTRIESARR.add(country!)
                    self.CASESARR.add(totalCases)
                    self.countryDataDict.setValue(totalCases, forKey:country!)
                    print(confirmInt)
                    
                    
                    self.confirmedTotal += confirmInt
                    self.recoveredTotal += recoveredInt
                    self.deathsTotal += deathsInt
                    
                    self.countryNameArr.add(country!)
                    self.longArr.add(longi ?? "")
                    self.latArr.add(lati ?? "")
                    self.stateArr.add(state ?? "")
                    self.deathsArr.add(death ?? "")
                }
                
                self.setHeaderValues()
                
                print(self.countryDataDict)
                print(self.COUNTRIESARR.count)
                print(self.CASESARR.count)
               
                self.allKeys = self.countryDataDict.allKeys as NSArray
                self.allValues = self.countryDataDict.allValues as NSArray
                
                print(self.allKeys.count)
                var appiDict = NSMutableDictionary()
                if(self.allKeys.count>0){

                        for i in 0...self.allKeys.count-1{
                        let countryName: String = self.allKeys.object(at: i) as! String
                            
                            var caseCount = 0
                            for j in 0...self.COUNTRIESARR.count-1{
                                print(self.COUNTRIESARR.count)

                                let currentCountry:String = self.COUNTRIESARR.object(at: j) as! String
                                
                                if(currentCountry == countryName){
                                    let indexValue:Int = self.COUNTRIESARR.index(of: currentCountry)
                                    
                                    let caseValue:Int = self.CASESARR.object(at: indexValue) as! Int
                                    caseCount += caseValue
                                    
                                }
                                
                                appiDict.setValue(caseCount, forKey: countryName)


                            }
                            
                                           
                    }
                }
                DispatchQueue.main.async {
                    self.removeSpinner()
                }
                
                print(appiDict)
                
                self.allKeys = appiDict.allKeys as NSArray
                self.allValues = appiDict.allValues as NSArray
                
            
                var sortedValuesArr = NSMutableArray()
//
//                var sortedStateArr = NSMutableArray()
//                sortedStateArr = self.stateArr.mutableCopy() as! NSMutableArray
//
//
                
           
                sortedValuesArr = self.allKeys.mutableCopy() as! NSMutableArray
                print(sortedValuesArr.count)
                
                let swiftArray = self.allKeys as! [String]
        
                var sortedArray = swiftArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                
                

         
                self.finalCountryArr = sortedArray as NSArray
                self.finalCountryArrs = self.finalCountryArr
                
                print(self.finalCountryArr)
                
                if(self.finalCountryArr.count>0){

                    for i in 0...self.finalCountryArr.count-1{
                        let countryName:String = self.finalCountryArr.object(at: i) as! String
                        
                        let indexValue:Int = self.allKeys.index(of: countryName)
                        print(self.allValues.object(at: indexValue))
                        
                     self.finalCaseCountArr.add(self.allValues.object(at: indexValue))
                    }
                }
                if(self.finalCaseCountArr.count>0){
                
                for i in 0...self.finalCaseCountArr.count-1{
                    let caseValue:Int = self.finalCaseCountArr.object(at:i) as! Int
                    let countryValue:String = self.finalCountryArr.object(at: i) as! String
                    
                    self.countryCaseSortedDict.setValue(caseValue, forKey: countryValue)
                }
                }
                
                
                print(self.countryCaseSortedDict)
                
                
                
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)

                    self.tableview.reloadData()
                }
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    @objc func refreshButtonPressed()
    {
         allKeys = NSArray()
         allValues = NSArray()
        COUNTRIESARR = NSMutableArray()
        CASESARR = NSMutableArray()
        finalCountryArr = NSArray()
        finalCaseCountArr = NSMutableArray()
        DATAARR = NSMutableArray()
        finalCountryArrs = NSArray()
         confirmedTotal = 0
         recoveredTotal = 0
        deathsTotal = 0
        callWebService()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

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
                   // print(user?.profileUrl)
                    UserDefaults.standard.set(user?.profileUrl!, forKey: "UserProfileImageURL")

                }
                 guard error == nil else {
                     
                     return
                 }
                 
             }
        
//        let name:String = getName()
//
//        let newName:String = "i_" + name
//
//        let identifier = getUDIDofDevice()
//        print(identifier)
//
//        let userdefaults = UserDefaults.standard
//        if let userName = userdefaults.string(forKey: "\(identifier)"){
//            print(userName)
//            UserDefaults.standard.set(userName, forKey: "\(identifier)") //setObject
//
//        } else {
//            UserDefaults.standard.set(newName, forKey: "UserName") //setObject
//            UserDefaults.standard.set(newName, forKey: "\(identifier)") //setObject
//        }
        
//
//        APIManager.sharedInstance.getUserProfile(id: Int(identifier)!,onSuccess: { json in
//                            DispatchQueue.main.async {
//                                print(json)
//
//
//
//                            }
//                        }, onFailure: { error in
//                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                            self.show(alert, sender: nil)
//                        })
        
        
        

        

        setupTableView()
        if let value = UserDefaults.standard.object(forKey: "selectedDiseaseName") as? String{
            self.title = value

        }
        
        //let button = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(refreshButtonPressed))

        
       // let button1 = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshButtonPressed)) // action:#selector(Class.MethodName) for swift 3
      //  self.navigationItem.rightBarButtonItem  = button1
        
        
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true

       

        
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        callWebService()
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        
       
        tableview.delegate = self
        tableview.dataSource = self
        
        self.tabBarController?.tabBar.items?[0].title = "Home"
        
        let button1: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button1.setImage(UIImage(named: "refresh-1"), for: .normal)
        //add function for button
        button1.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
        //set frame
        button1.frame = CGRect(x:0,y:0,width:35, height:35)
        //button1.backgroundColor = UIColor.red
        let barButton = UIBarButtonItem(customView: button1)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        if(finalCountryArrs.count>0){
            return finalCountryArrs.count
        }
        return 0
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(countryActualDataDict)

            let cell = tableview.dequeueReusableCell(withIdentifier: "ListCountriesTableViewCell", for: indexPath) as! ListCountriesTableViewCell
            tableView.separatorColor = UIColor.clear
            if(finalCountryArrs.count>0){
                cell.countryNameLabel.text = finalCountryArrs.object(at: indexPath.row) as? String
                let countryName:String = (finalCountryArrs.object(at: indexPath.row) as? String)!
                var countValue = 0
                for i in 0...countryCaseSortedDict.count-1{
                    countValue = countryCaseSortedDict.value(forKey: countryName) as! Int
                }
                
                cell.countryCountLable.text = "\(countValue.delimiter)"
                
            }
            return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80
    }
    @objc private func filterApply(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 0:
            tableview.isHidden = false
            mapView.isHidden = true
            break
        case 1:
            mapView.isHidden = false
            tableview.isHidden = true
            break
            
        default:
            break
            
        }
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
    
   func showSpinner(onView : UIView) {
       let spinnerView = UIView.init(frame: onView.bounds)
       spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
       let ai = UIActivityIndicatorView.init(style: .whiteLarge)
       ai.startAnimating()
       ai.center = spinnerView.center
       
       DispatchQueue.main.async {
           spinnerView.addSubview(ai)
           onView.addSubview(spinnerView)
       }
       
       vSpinner = spinnerView
   }
   
   func removeSpinner() {
       DispatchQueue.main.async {
        self.vSpinner?.removeFromSuperview()
        self.vSpinner = nil
       }
   }
    
}

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter
    }()

    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    
}
extension UIViewController {

func showToast(message : String) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height/2, width: 300, height: 60))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = UIFont.systemFont(ofSize: 15)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.numberOfLines = 100
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
    

    func showSmallToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 15)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 100
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

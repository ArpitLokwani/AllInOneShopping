//
//  SettingsPrefViewController.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 21/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class SettingsPrefViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var settingOptions = ["Change Category","FAQ","Privacy policy","Contact Us","Feedback"]
    var link = ""
       var faq = ""
       var privacy_link = ""
       var contact_us = ""
       var feedback_email = ""
    let textLable = UILabel()
 let imageView = UIImageView()

    let tableview: UITableView = {
           let tv = UITableView()
          // tv.backgroundColor = UIColor.gray
           
           tv.translatesAutoresizingMaskIntoConstraints = false
           return tv
       }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return ""
        } else if(section == 1) {
            return " "
        }else{
            return ""
        }
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        if(section == 0) {
            return 1
        } else if(section == 1) {
            return settingOptions.count
        } else {
            return 4
        }
    }
       func setupTableView() {
       
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.delegate = self
        tableview.dataSource = self
       tableview.frame = CGRect.init(x: 0, y:60, width: self.view.frame.size.width, height: self.view.frame.size.height-60)
       view.addSubview(tableview)
           
       }
    
  
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // 2
        tableView.tableFooterView = nil
           let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.separatorInset = UIEdgeInsets.zero

        if(indexPath.section == 0) {
            
            imageView.frame = CGRect(x: 15, y:15, width: 70, height: 70)
            imageView.layer.cornerRadius = 35
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 0.5
            imageView.image = UIImage(named: "img_default_profile_image_1")
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            
            let userdefaults = UserDefaults.standard
            if let savedValue = userdefaults.string(forKey: "UserProfileImageURL"){
                let profileImageURL:String =  UserDefaults.standard.string(forKey: "UserProfileImageURL")!
                imageView.downloaded(from: profileImageURL)
            } else {
               
            }
            
           

            
            
//            UserProfileImageURL
            
            cell.contentView.addSubview(imageView)
            textLable.frame = CGRect(x: 100 , y: 0, width: 200, height: 100)
            cell.contentView.addSubview(textLable)
            let identifier = UIDevice.current.identifierForVendor?.uuidString
            print(identifier!)
            if let userName = userdefaults.string(forKey: "\(identifier!)"){
                print(userName)
                textLable.text = userName


            }
            
           
            
            } else if(indexPath.section == 1) {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

            cell.textLabel?.text = settingOptions[indexPath.row]
            }
        cell.selectionStyle = .none


          // cell.textLabel?.text = "News"
           cell.backgroundColor = UIColor.white
           return cell
       }
       
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 100
        } else if(indexPath.section == 1) {
            return 50
        } else {
            return 50
        }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        let userdefaults = UserDefaults.standard
        let identifier = getUDIDofDevice()

        if let userName = userdefaults.string(forKey: "\(identifier)"){
            print(userName)
            textLable.text = userName


        }
        if let savedValue = userdefaults.string(forKey: "UserProfileImageURL"){
            let profileImageURL:String =  UserDefaults.standard.string(forKey: "UserProfileImageURL")!
            imageView.downloaded(from: profileImageURL)
        } else {
           
        }

        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBottomLine(color: UIColor.gray, height: 0.6)
        self.view.backgroundColor = UIColor.white

        if #available(iOS 13.0, *) {
                          overrideUserInterfaceStyle = .light
                      } else {
                          // Fallback on earlier versions
                      }
        setupTableView()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white

       // self.title = "Settings"
        self.navigationItem.title  = "Settings"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        APIManager.sharedInstance.getAllSettingURL(id: 0,onSuccess: { json in
                            DispatchQueue.main.async {
                                print(json)
                                for setting in json["data"].arrayValue
                                {
                                    if  setting["link"].string != nil
                                        {
                                            self.link = setting["link"].string ?? ""
                                             self.faq = setting["faq_link"].string ?? ""
                                             self.privacy_link = setting["privacy_link"].string ?? ""
                                             self.contact_us = setting["contact_us"].string ?? ""
                                             self.feedback_email = setting["feedback_email"].string ?? ""
                                            
                                        
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                }
                                
        //                        let jsonArr = json.array
        //                        let name = jsonArr?[0].dictionaryValue
        //                        print(name!)
                                
                
                //                for item in json["title"].stringValue {
                //                    print(item)
                //                }
                
                               // self.dataView?.text = String(describing: json)
                            }
                        }, onFailure: { error in
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.show(alert, sender: nil)
                        })
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VirusTrackerWebViewController") as? VirusTrackerWebViewController
         if (indexPath.section == 1){
             if (indexPath.row == 0){
                // vc?.urlString = videoURL
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewCategoryViewController") as? NewCategoryViewController
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc!, animated: true)

             }else if (indexPath.row == 1){
                 vc?.urlString = faq
                vc?.titleName = "FAQ"

                self.navigationController?.pushViewController(vc!, animated: true)


             }else if (indexPath.row == 2){
                 vc?.urlString = privacy_link
                vc?.titleName = "Privacy Policy"
                self.navigationController?.pushViewController(vc!, animated: true)


             }else if (indexPath.row == 3){
                 vc?.urlString = contact_us
                vc?.titleName = "Contact Us"
                self.navigationController?.pushViewController(vc!, animated: true)


             }else if (indexPath.row == 4){
                 let email = feedback_email
                 if let url = URL(string: "mailto:\(email)") {
                   if #available(iOS 10.0, *) {
                     UIApplication.shared.open(url)
                   } else {
                     UIApplication.shared.openURL(url)
                   }
                 }
             }
                  
                   
         }

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
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    
}

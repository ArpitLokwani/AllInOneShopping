//
//  VirusTrackerBaseViewController.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 23/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import SendBirdSDK
class VirusTrackerBaseViewController: UITabBarController,SBDChannelDelegate {
    var firstTabNavigationController : UINavigationController!
    var secondTabNavigationControoller : UINavigationController!
    var thirdTabNavigationController : UINavigationController!
    var fourthTabNavigationControoller : UINavigationController!
    var fifthTabNavigationController : UINavigationController!
    var categoryHomeTabNavigationController : UINavigationController!
    
    var selectedDiseaseID = ""
    var isRecordFounds = ""
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // getChatID()
        let selectedDiseaseIDs: Int =  UserDefaults.standard.integer(forKey: "selectedDiseaseID")
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.getChatID(withDiseaseID: selectedDiseaseIDs)
        
        
        self.navigationController?.navigationBar.isHidden = true
        categoryHomeTabNavigationController = UINavigationController.init(rootViewController: CategoryHomeViewController())
        
        
        let mainStoryboard = UIStoryboard.init(name: "OpenChannel", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "OpenChannelsViewController")
        
        secondTabNavigationControoller = UINavigationController.init(rootViewController: viewController)
        
        thirdTabNavigationController = UINavigationController.init(rootViewController: NotificationViewController())
        
        fourthTabNavigationControoller = UINavigationController.init(rootViewController: SettingsPrefViewController())
        
        //firstTabNavigationController
        //thirdTabNavigationController
        self.viewControllers = [categoryHomeTabNavigationController, secondTabNavigationControoller, fourthTabNavigationControoller]
        
        
        let item1 = UITabBarItem(title: "", image: UIImage(named: "homeIcon32"), tag: 0)
        let item2 = UITabBarItem(title: "", image:  UIImage(named: "chatIcon"), tag: 1)
        let item3 = UITabBarItem(title: "", image:  UIImage(named: "notificationIcon32"), tag: 2)
        let item4 = UITabBarItem(title: "", image:  UIImage(named: "settingIcon32"), tag: 3)
        
        let selectedHomeImage:UIImage = UIImage(named: "homefilledIcon32")!
        item1.selectedImage = selectedHomeImage.withRenderingMode(.alwaysOriginal)
        let selectedColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0)
        
        
        let selectedChatImage:UIImage = UIImage(named: "chatfilledIcon")!
        item2.selectedImage = selectedChatImage.withRenderingMode(.alwaysOriginal)
        
        let selectedFeedImage:UIImage = UIImage(named: "notificationfilledIcon32")!
        item3.selectedImage = selectedFeedImage.withRenderingMode(.alwaysOriginal)
        let selectedSettingImage:UIImage = UIImage(named: "settingfilledIcon32")!
        item4.selectedImage = selectedSettingImage.withRenderingMode(.alwaysOriginal)
        
        
        let unselectedColor = UIColor.gray
        
        if #available(iOS 13, *) {
//            let appearance = UITabBarAppearance()
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedColor]
//            tabBar.standardAppearance = appearance
        }else{
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        }
        
        //
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        
        
        categoryHomeTabNavigationController.tabBarItem = item1
        secondTabNavigationControoller.tabBarItem = item2
        thirdTabNavigationController.tabBarItem = item3
        fourthTabNavigationControoller.tabBarItem = item4
        
        
        
        // fifthTabNavigationController.tabBarItem = item5
        
       // UITabBar.appearance().tintColor = .orange
        UITabBar.appearance().barTintColor = .white
        // UITabBar.appearance().backgroundColor = UIColor.green
        
        //self.tabBarController?.tabBar.tintColor = .green
        //self.tabBarController?.tabBar.unselectedItemTintColor = .blue
        // UITabBar.appearance().barTintColor = UIColor.white // your color
        
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
    
}

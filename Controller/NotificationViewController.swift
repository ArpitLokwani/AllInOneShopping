//
//  NotificationViewController.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 07/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title  = "Notification"
        self.view.backgroundColor = UIColor.white

        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.addCustomBottomLine(color: UIColor.gray, height: 0.6)
        setupView()
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
     scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(700))

    let leftImageView = UIImageView()
    leftImageView.frame = CGRect(x: 0, y: 150, width: Int(screenWidth), height: Int(screenHeight/3))
        //leftImageView.backgroundColor = UIColor.red
        leftImageView.image = UIImage(named:"noNotificationimage")
        leftImageView.contentMode = .scaleAspectFit
    scrollView.addSubview(leftImageView)
        
        
     view.addSubview(scrollView)
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

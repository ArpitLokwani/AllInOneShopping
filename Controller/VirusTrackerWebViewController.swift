//
//  VirusTrackerWebViewController.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 23/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import WebKit

class VirusTrackerWebViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var urlString = ""
    var titleName = ""
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
   
     var loadingIndicator = UIActivityIndicatorView()
    
    @objc func backBtnTapped() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = titleName
        self.tabBarController?.tabBar.isHidden = true
        let screenSize: CGRect = UIScreen.main.bounds
        self.navigationItem.setHidesBackButton(false, animated: false)
//        let backbtn = UIBarButtonItem(title: "Setting", style:UIBarButtonItem.Style.plain, target: self, action: #selector(backBtnTapped))
//        self.navigationItem.leftBarButtonItem = backbtn
//        let backColor = UIColor(red: 164/255.0, green: 4/255.0, blue: 156/255.0, alpha: 1.0)
//        self.navigationItem.leftBarButtonItem?.tintColor = backColor

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
       // let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        loadingIndicator.frame =  CGRect(x:screenWidth/2-25, y: screenHeight/2-25, width: 50, height: 50)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        view.addSubview(loadingIndicator)
        
//        present(alert, animated: true, completion: nil)
      
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
   // title = webView.title
        DispatchQueue.main.async {
                                            
            self.loadingIndicator.stopAnimating()
            
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

}

//
//  OpenChannelsViewController.swift
//  SendBird-iOS
//
//  Created by Jed Gyeong on 10/16/18.
//  Copyright © 2018 SendBird. All rights reserved.
//

import UIKit
import SendBirdSDK
import AlamofireImage
import SwiftKeychainWrapper
class OpenChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating, CreateOpenChannelDelegate, OpenChanannelChatDelegate, NotificationDelegate {
    @IBOutlet weak var openChannelsTableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: CustomActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var channels: [SBDOpenChannel] = []
    var refreshControl: UIRefreshControl?
    var searchController: UISearchController?
    var channelListQuery: SBDOpenChannelListQuery?
    var channelNameFilter: String?
    var createChannelBarButton: UIBarButtonItem?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        refreshChannelList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        if #available(iOS 13.0, *) {
                          overrideUserInterfaceStyle = .light
                      } else {
                          // Fallback on earlier versions
                      }
        self.searchController?.searchResultsUpdater = self
       self.definesPresentationContext = true

        
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
            
            
            guard error == nil else {
                
                return
            }
            
        }

        
        
        
        // Do any additional setup after loading the view.
       // self.title = "Chat"
        self.navigationItem.title  = "Chat"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //self.tabBarController?.tabBarItem.title = "Chat"
       // self.navigationController?.title = "Open"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.createChannelBarButton = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(OpenChannelsViewController.clickCreateOpenChannel(_:)))
        self.navigationItem.rightBarButtonItem = self.createChannelBarButton
        
        
        
        self.openChannelsTableView.delegate = self
        self.openChannelsTableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(OpenChannelsViewController.refreshChannelList), for: .valueChanged)
        
        self.openChannelsTableView.refreshControl = self.refreshControl
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.searchBar.delegate = self
        self.searchController?.searchBar.placeholder = "Channel Name"
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.searchBar.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        self.loadingIndicatorView.isHidden = true
        self.view.bringSubviewToFront(self.loadingIndicatorView)
        
        self.loadChannelListNextPage(refresh: true, channelNameFilter: self.channelNameFilter)
        //self.tabBarController?.tabBarItem.title = "Chat"


    }

    @objc func textFieldDidChange(textField: UITextField) {
           self.channelNameFilter = textField.text
           
           self.refreshChannelList()
           
       }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOpenChat", let navigation = segue.destination as? UINavigationController, let destination = navigation.children.first as? OpenChannelChatViewController, let selectedChannel = sender as? SBDOpenChannel{
            destination.channel = selectedChannel
            destination.hidesBottomBarWhenPushed = true
            destination.delegate = self
        } else if segue.identifier == "CreateOpenChannel", let destination = segue.destination as? CreateOpenChannelNavigationController{
            destination.createChannelDelegate = self
        }
    }

    @objc func clickCreateOpenChannel(_ sender: AnyObject) {
        performSegue(withIdentifier: "CreateOpenChannel", sender: nil)
    }
    
    // MARK: - NotificationDelegate
    func openChat(_ channelUrl: String) {
        (navigationController?.parent as? UITabBarController)?.selectedIndex = 0
        
        if let cvc = UIViewController.currentViewController() as? NotificationDelegate {
            cvc.openChat(channelUrl)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChannelTableViewCell") as! OpenChannelTableViewCell
        cell.coverImage.image = nil
        
        let channel = self.channels[indexPath.row]
        
        cell.channelNameLabel.text = channel.name
        
        if channel.participantCount > 1 {
            cell.participantCountLabel.text = String(format: "%ld participants", channel.participantCount)
        }
        else {
            cell.participantCountLabel.text = String(format: "%ld participant", channel.participantCount)
        }
        
        var asOperator: Bool = false
        if let operators: [SBDUser] = channel.operators as? [SBDUser] {
            for op: SBDUser in operators {
                if op.userId == SBDMain.getCurrentUser()?.userId {
                    asOperator = true
                    break
                }
            }
        }
        
        cell.asOperator = asOperator
        
        DispatchQueue.main.async {
            if let updateCell: OpenChannelTableViewCell = tableView.cellForRow(at: indexPath) as? OpenChannelTableViewCell {
                var placeholderCoverImage: String?
                switch channel.name.count % 3 {
                case 0:
                    placeholderCoverImage = "img_cover_image_placeholder_1"
                    break
                case 1:
                    placeholderCoverImage = "img_cover_image_placeholder_2"
                    break
                case 2:
                    placeholderCoverImage = "img_cover_image_placeholder_3"
                    break
                default:
                    placeholderCoverImage = "img_cover_image_placeholder_1"
                    break
                }
                if let url = URL(string: channel.coverUrl!) {
                    updateCell.coverImage.af_setImage(withURL: url, placeholderImage: UIImage(named: placeholderCoverImage!))
                }
                else {
                    updateCell.coverImage.image = UIImage(named: placeholderCoverImage!)
                }
                
            }
        }
        
        if self.channels.count > 0 && indexPath.row == self.channels.count - 1 {
            self.loadChannelListNextPage(refresh: false, channelNameFilter: self.channelNameFilter)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.channels.count == 0 {
            if self.channelNameFilter == nil {
                self.emptyLabel.text = "There are no open channels"
            }
            else {
                self.emptyLabel.text = "Search results not found"
            }
            self.emptyLabel.isHidden = false
        }
        else {
            self.emptyLabel.isHidden = true
        }
        
        return self.channels.count
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChannel = self.channels[indexPath.row]
        if self.splitViewController?.displayMode == UISplitViewController.DisplayMode.allVisible {
            
        }
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicatorView.startAnimating()
        selectedChannel.enter { (error) in
            self.loadingIndicatorView.isHidden = true
            self.loadingIndicatorView.stopAnimating()
            
            if let error = error {
                Utils.showAlertController(error: error, viewController: self)
                return
            }
            
            self.performSegue(withIdentifier: "ShowOpenChat", sender: selectedChannel)
        }
    }
    
    // MARK: - Load channels
    @objc func refreshChannelList() {
        self.loadChannelListNextPage(refresh: true, channelNameFilter: self.channelNameFilter)
    }
    
    func clearSearchFilter() {
        self.channelNameFilter = nil
    }
    
    func loadChannelListNextPage(refresh: Bool, channelNameFilter: String?) {
        if refresh {
            self.channelListQuery = nil
        }
        
        if self.channelListQuery == nil {
            self.channelListQuery = SBDOpenChannel.createOpenChannelListQuery()
            self.channelListQuery?.limit = 20
            if (channelNameFilter?.count ?? 0 ) > 0 {
                self.channelListQuery?.channelNameFilter = channelNameFilter
            }
        }
        
        if self.channelListQuery?.hasNext == false {
            return
        }
        
        self.channelListQuery?.loadNextPage(completionHandler: { (channels, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
                
                return
            }
            
            DispatchQueue.main.async {
                if refresh {
                    self.channels.removeAll()
                }
                
                self.channels += channels!
                self.openChannelsTableView.reloadData()
                
                self.refreshControl?.endRefreshing()
            }
        })
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.channelNameFilter = nil
        
        self.refreshChannelList()
    }
    
   
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
       

        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.channelNameFilter = searchBar.text
        
        self.refreshChannelList()
    }
    
    // MARK: - CreateOpenChannelDelegate
    func didCreate(_ channel: SBDOpenChannel) {
        self.channelNameFilter = nil
        
        self.refreshChannelList()
    }
    
    // MARK: - OpenChannelChatDelegate
    func didUpdateOpenChannel() {
        DispatchQueue.main.async {
            self.openChannelsTableView.reloadData()
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

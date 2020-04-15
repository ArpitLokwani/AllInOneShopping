//
//  CatergoryModal.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 04/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit

/*
 "SNo": "50",
 "CategoryId": "1",
 "Name": "Yep Me",
 "OsType": "1",
 "PlayStore_Url": "https://play.google.com/store/apps/details?id=com.yepme",
 "AppleStore_Url": "",
 "Description": "yepme.png",
 "Redirect_Link_1": "http://www.yepme.com/",
 "Redirect_Link_2": "http://www.yepme.com/",
 "Actutal_Reditrect": "http://www.yepme.com/",
 "IsActive": "0",
 "Count": "0"
 */
import SwiftyJSON
class CatergoryModal: NSObject {

    var SNo = ""
    var CategoryId = ""
    var Name = ""
    var PlayStore_Url = ""
    var AppleStore_Url = ""
    var Description = ""
    var Redirect_Link_1 = ""
    var Actutal_Reditrect = ""
    var IsActive = ""
    var Count = ""
    var CategoryName = ""
    var CategoryImagePng = ""
    
    
    
    init(userJSON:JSON) {
        
        self.SNo = userJSON["SNo"].stringValue
        self.CategoryId = userJSON["CategoryId"].stringValue
        self.Name = userJSON["Name"].stringValue
        self.CategoryName = userJSON["CategoryName"].stringValue
        self.PlayStore_Url = userJSON["PlayStore_Url"].stringValue
        self.AppleStore_Url = userJSON["AppleStore_Url"].stringValue
        self.Description = userJSON["Description"].stringValue
        self.Redirect_Link_1 = userJSON["Redirect_Link_1"].stringValue
        self.Actutal_Reditrect = userJSON["Actutal_Reditrect"].stringValue
        self.IsActive = userJSON["IsActive"].stringValue
        self.Count = userJSON["Count"].stringValue
        self.CategoryImagePng = userJSON["CategoryImagePng"].stringValue
        
        
        
    }
    
    
}

class Category
{
    
    var SNo = ""
    var CategoryId = ""
    var Name = ""
    var PlayStore_Url = ""
    var AppleStore_Url = ""
    var Description = ""
    var Redirect_Link_1 = ""
    var Actutal_Reditrect = ""
    var IsActive = ""
    var Count = ""
    var CategoryName = ""
    
    init(SNo:String, CategoryId:String, Name:String, PlayStore_Url:String, AppleStore_Url:String, Description:String, Redirect_Link_1:String, Actutal_Reditrect:String,IsActive:String,Count:String,CategoryName:String )
    {
        self.SNo = SNo
        self.CategoryId = CategoryId
        self.Name = Name
        self.PlayStore_Url = PlayStore_Url
        self.AppleStore_Url = AppleStore_Url
        self.Description = Description
        self.Redirect_Link_1 = Redirect_Link_1
        self.Actutal_Reditrect = Actutal_Reditrect
        self.IsActive = IsActive
        self.Count = Count
        self.CategoryName = CategoryName
    }
    
}

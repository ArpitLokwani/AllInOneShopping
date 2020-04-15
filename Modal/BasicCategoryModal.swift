//
//  BasicCategoryModal.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 04/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit
import SwiftyJSON

class BasicCategoryModal: NSObject {
    
    var CategoryID = ""
    var CategoryName = ""
    var CategoryImage = ""
    var CategoryImageSelected = ""
    var CategoryCount = ""
    
    init(userJSON:JSON) {
           
           self.CategoryID = userJSON["CategoryID"].stringValue
           self.CategoryName = userJSON["CategoryName"].stringValue
           self.CategoryImage = userJSON["CategoryImage"].stringValue
           
           
       }
}

//
//  Person.swift
//  AllInOne
//
//  Created by Arpit Lokwani on 06/04/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import Foundation
class Person
{
    
    var name: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id:Int, name:String, age:Int)
    {
        self.id = id
        self.name = name
        self.age = age
    }
    
}

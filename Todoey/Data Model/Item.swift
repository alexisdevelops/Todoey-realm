//
//  Item.swift
//  Todoey
//
//  Created by Ivan Garza on 9/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var pacentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

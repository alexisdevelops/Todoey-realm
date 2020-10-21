//
//  Category.swift
//  Todoey
//
//  Created by Ivan Garza on 9/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String?
    var items = List<Item>()
}

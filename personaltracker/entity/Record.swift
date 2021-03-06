//
//  Record.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation

import RealmSwift

class Record: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var amount: Int = 0
    @objc dynamic var createdAt: Int = 0
    @objc dynamic var imageId: String = ""
   
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    required convenience init(
        uid: String,
        title: String,
        category: String,
        type: String,
        amount: Int,
        imageId: String,
        createdAt: Int
    ) {
        self.init()
        
        self.uid = uid
        self.title = title
        self.category = category
        self.type = type
        self.amount = amount
        self.imageId = imageId
        self.createdAt = createdAt
    }
}

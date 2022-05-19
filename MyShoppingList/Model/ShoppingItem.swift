//
//  ShoppingItem.swift
//  MyShoppingList
//
//  Created by bro on 2022/05/19.
//

import Foundation
import RealmSwift

class Shopping: Object {
    //PK(필수) : Int, String, UUID, ObjectId -> AutoIncrement
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var isChecked: Bool
    @Persisted var isFavorite: Bool
    @Persisted var category: String
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
        self.isChecked = isChecked
        self.isFavorite = isFavorite
        self.category = category
    }
    
}

//
//  RealmRepository.swift
//  MyShoppingList
//
//  Created by bro on 2022/05/20.
//

import Foundation
import RealmSwift

//@Persisted var title: String
//@Persisted var isChecked: Bool
//@Persisted var isFavorite: Bool
//@Persisted var category: String

protocol RealmRepository {
    
    func loadDatas() -> Results<ShoppingItem>
    func saveData(item: ShoppingItem)
    func deleteData(item: ShoppingItem)
    func updateData(item: ShoppingItem, title: String?, isChecked: Bool?, isFavorite: Bool?, category: String?)
    func updateBoolData(item: ShoppingItem, status: ShoopingStatus, change: Bool)
}

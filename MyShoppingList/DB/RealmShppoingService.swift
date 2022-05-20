//
//  RealmService.swift
//  MyShoppingList
//
//  Created by bro on 2022/05/20.
//

import Foundation
import RealmSwift

enum ShoopingStatus {
    case check
    case favorite
}

final class RealmShppoingService: RealmRepository {
    static let shared = RealmShppoingService()
    private let localRealm = try! Realm()
    
    func loadDatas() -> Results<ShoppingItem> {
        return localRealm.objects(ShoppingItem.self)
    }
    
    func saveData(item: ShoppingItem) {
        try! localRealm.write {
            localRealm.add(item)
        }
    }
    
    func deleteData(item: ShoppingItem) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }

    func updateData(item: ShoppingItem, title: String?, isChecked: Bool?, isFavorite: Bool?, category: String?) {
        try! localRealm.write {
            guard let guardTitle = title, let guardChecked = isChecked, let guardFavorite = isFavorite, let guardCategory = category else { return }
            item.title = guardTitle
            item.isChecked = guardChecked
            item.isFavorite = guardFavorite
            item.category = guardCategory
        }
    }
    
    func updateBoolData(item: ShoppingItem, status: ShoopingStatus, change: Bool) {
        try! localRealm.write {
            switch status {
            case .check:
                item.isChecked = change
            case .favorite:
                item.isFavorite = change
            }
        }
    }
    
}

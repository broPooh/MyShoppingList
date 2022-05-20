//
//  ShoppingTableViewController.swift
//  MyShoppingList
//
//  Created by bro on 2022/05/19.
//

import UIKit
import RealmSwift
import Zip
import MobileCoreServices

enum ShoppingSection: Int {
    case add = 0
    case item = 1
}

class ShoppingTableViewController: UITableViewController {
    
    var shoppingItemList: Results<ShoppingItem>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var category: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        loadRealmData()
    }
    
    
    func loadRealmData() {
        shoppingItemList = RealmShppoingService.shared.loadDatas()
    }
    

    @IBAction func backupButtonClicked(_ sender: UIBarButtonItem) {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmURL = documentURL.appendingPathComponent("default.realm")
        
        if FileManager.default.fileExists(atPath: realmURL.path) {
            do {
                let zipURL = try Zip.quickZipFiles([realmURL], fileName: "backup")
                presentActivityViewController(fileURL: [zipURL])
                print(zipURL)
            }
            catch {
                print("zip failed")
            }
        }
        else {
            print("File Not exist")
        }
    }
    
    @IBAction func restoreButtonClicked(_ sender: UIBarButtonItem) {
        let documentVC = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        documentVC.delegate = self
        documentVC.allowsMultipleSelection = false
        present(documentVC, animated: true, completion: nil)
    }
    
    func presentActivityViewController(fileURL: [URL]) {
        let activityVC = UIActivityViewController(activityItems: fileURL, applicationActivities: [])
        activityVC.completionWithItemsHandler = { activityType, completed, returnedItem, activityError in
            if let error = activityError {
                print("activity failed", error)
                return
            }
            else {
                if completed {
                    do {
                        try FileManager.default.removeItem(atPath: fileURL.first!.path)
                    }
                    catch {
                        print("remove zip failed")
                    }
                }
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : shoppingItemList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .none:
            print(#function)
        case .delete:
            if indexPath.section == ShoppingSection.item.rawValue {
                let deleteItem = shoppingItemList[indexPath.row]
                RealmShppoingService.shared.deleteData(item: deleteItem)
                loadRealmData()
            }
        case .insert:
            print(#function)
        @unknown default:
            print(#function)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ShoppingSection.add.rawValue:
            let addCell = tableView.dequeueReusableCell(withIdentifier: Consts.CustomCell.ShoppingAddTableViewCell, for: indexPath) as! ShoppingAddTableViewCell
            addCell.delegate = self
            return addCell
        case ShoppingSection.item.rawValue:
            let itemCell = tableView.dequeueReusableCell(withIdentifier: Consts.CustomCell.ShoppingTableViewCell, for: indexPath) as! ShoppingTableViewCell
            itemCell.delegate = self
            
            let item = shoppingItemList[indexPath.row]
            itemCell.checkButton.tag = indexPath.row
            itemCell.favoriteButton.tag = indexPath.row
            itemCell.configure(item: item)
            
            return itemCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - ShoppingAddTableViewCell Delegate
extension ShoppingTableViewController: ShoppingAddTableViewCellDelegate {
    
    func didTapAddButton(item: String) {
        let shoppingItem = ShoppingItem(title: item)
        RealmShppoingService.shared.saveData(item: shoppingItem)
        loadRealmData()
    }
}

// MARK: - ShoppingTableViewCell Delegate
extension ShoppingTableViewController: ShoppingTableViewCellDelegate {
    func didTapCheckButton(row: Int, status: Bool) {
        let updateItem = shoppingItemList[row]
        RealmShppoingService.shared.updateBoolData(item: updateItem, status: ShoopingStatus.check, change: status)
        loadRealmData()
    }
    
    func didTapFavoriteButton(row: Int, status: Bool) {
        let updateItem = shoppingItemList[row]
        RealmShppoingService.shared.updateBoolData(item: updateItem, status: ShoopingStatus.favorite, change: status)
        loadRealmData()
    }
    
}

// MARK: - UIDocumentPicker Delegate
extension ShoppingTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first,
              let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        let fileURL = documentURL.appendingPathComponent(selectedFileURL.lastPathComponent)
        do {
            try FileManager.default.copyItem(at: selectedFileURL, to: fileURL)
            try Zip.unzipFile(fileURL,
                              destination: documentURL,
                              overwrite: true,
                              password: nil,
                              progress: { progress in
                print(progress)
            },
                              fileOutputHandler: nil)
            try FileManager.default.removeItem(atPath: fileURL.path)
        }
        catch {
            print("unzip failed")
        }
    }
}

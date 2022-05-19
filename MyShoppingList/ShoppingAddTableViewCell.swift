//
//  ShoppingAddTableViewCell.swift
//  MyShoppingList
//
//  Created by bro on 2022/05/19.
//

import UIKit

class ShoppingAddTableViewCell: UITableViewCell {
    
    var delegate: ShoppingAddTableViewCellDelegate?

    @IBOutlet weak var shoppingTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func didTapAddButtoned(_ sender: UIButton) {
        guard let item = shoppingTextField.text else {
            return
        }
        
        delegate?.didTapAddButton(item: item)
        shoppingTextField.text = ""
    }
    
    
}

protocol ShoppingAddTableViewCellDelegate {
    func didTapAddButton(item: String)
}

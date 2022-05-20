//
//  ShoppingTableViewCell.swift
//  MyShoppingList
//
//  Created by bro on 2022/05/19.
//

import UIKit

protocol ShoppingTableViewCellDelegate: AnyObject {
    func didTapCheckButton(row: Int, status: Bool)
    func didTapFavoriteButton(row: Int, status:Bool)
}

class ShoppingTableViewCell: UITableViewCell {
    
    var delegate: ShoppingTableViewCellDelegate?

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var shoppingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isChecked = false {
        didSet {
            let checkButtonImage = UIImage(systemName: isChecked ? "checkmark.square.fill" : "checkmark.square")
            checkButton.setImage(checkButtonImage, for: .normal)
        }
    }
    var isFavorite = false {
        didSet {
            let favoriteButtonImage = UIImage(systemName: isFavorite ? "star.fill" : "star")
            favoriteButton.setImage(favoriteButtonImage, for: .normal)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    func configure(item: ShoppingItem) {
        print(item)
        shoppingLabel.text = item.title
        isChecked = item.isChecked
        isFavorite = item.isFavorite
    }
    
    
    @IBAction func didTapCheckButton(_ sender: UIButton) {
        print("checked", isChecked)
        isChecked.toggle()
        delegate?.didTapCheckButton(row: sender.tag, status: isChecked)
    }
    
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        print("favorite", isFavorite)
        isFavorite.toggle()
        print("favoriteChecked", isFavorite)
        delegate?.didTapFavoriteButton(row: sender.tag, status: isFavorite)
    }
    
}

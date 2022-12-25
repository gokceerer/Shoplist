//
//  ShoppingListTableViewCell.swift
//  ShoppingListApp
//
//  Created by G on 8.12.2022.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var checkbox: UIButton!
            
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(itemName: String) {
        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        
        let attributeString = NSMutableAttributedString(string: itemName)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        
        self.itemName.attributedText = attributeString
    }
    
    func updateCellWithNoImage(itemName: String) {
        checkbox.isHidden = true
        let attributeString = NSMutableAttributedString(string: itemName)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        
        self.itemName.attributedText = attributeString
    }
    
    func strikeThroughCell() {
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: itemName.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        
        itemName.attributedText = attributeString
    }
    
    @IBAction func checkboxTapped(_ sender: Any) {
        isSelected = true
    }
}

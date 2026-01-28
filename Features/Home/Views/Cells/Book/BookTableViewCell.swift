//
//  HomeCellTableViewCell.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var pages: UILabel!
    
    @IBOutlet weak var localizedAuthorLabel: UILabel!
    @IBOutlet weak var localizedPagesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizedAuthorLabel.text = String(localized: "authors")
        localizedPagesLabel.text = String(localized: "pages")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

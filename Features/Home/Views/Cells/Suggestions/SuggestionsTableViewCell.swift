//
//  SuggestionsTableViewCell.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 15/01/2026.
//

import UIKit

class SuggestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        title.text = nil
//        authorName.text = nil
//        bookImage.image = nil
//    }
    
}

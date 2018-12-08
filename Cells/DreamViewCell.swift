//
//  DreamViewCell.swift
//  DreamTracker
//
//  Created by nakama on 09/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import UIKit

class DreamViewCell: UITableViewCell {

    @IBOutlet weak var dreamImageView: UIImageView!
    @IBOutlet weak var dreamTitleLabel: UILabel!
    @IBOutlet weak var dreamDescriptionLabel: UILabel!
    @IBOutlet weak var dreamProgressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     * A function to bind data from API with table view
     */
    func bindWith(dream: Dream) {
        dreamTitleLabel.text = dream.title
        dreamDescriptionLabel.text = dream.description
        
        //Count todo and the checked list
        var checkedCount = 0;
        if let todo = dream.todo {
            for i in 0..<todo.count {
                if todo[i].is_checked {
                    checkedCount += 1
                }
            }
            dreamProgressLabel.text = "Progress \(checkedCount)/\(todo.count)"
        } else {
            dreamProgressLabel.text = ""
        }
        
        self.dreamImageView.loadImageFrom(url: URL(string: dream.image_uri ?? ""))
    }

}

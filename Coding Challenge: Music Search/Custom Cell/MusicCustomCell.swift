//
//  MusicCustomCell.swift
//  Coding Challenge: Music Search
//
//  Created by Atisha Poojary on 20/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class MusicCustomCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

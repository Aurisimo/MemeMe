//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by Aurelijus Lape on 29/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {

    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var memeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

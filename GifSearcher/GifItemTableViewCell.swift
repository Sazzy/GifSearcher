//
//  GifItemTableViewCell.swift
//  GifSearcher
//
//  Created by Eugene Sazonov on 22/04/2017.
//  Copyright © 2017 Eugene Sazonov. All rights reserved.
//

import UIKit

class GifItemTableViewCell: UITableViewCell {

    @IBOutlet weak var gifItemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

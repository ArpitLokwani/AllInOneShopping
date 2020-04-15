//
//  ListHeaderTableViewCell.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 22/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit

class ListHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var globalSuperView: UIView!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var recoverdLabel: UILabel!
    @IBOutlet weak var totalConfirmedlabel: UILabel!
    
    @IBOutlet weak var globalCountValue: UILabel!
    @IBOutlet weak var fataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        globalSuperView.layer.cornerRadius = 10
        globalSuperView.layer.borderColor = UIColor.systemBlue.cgColor
        globalSuperView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

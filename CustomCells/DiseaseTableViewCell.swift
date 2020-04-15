//
//  DiseaseTableViewCell.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 22/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit

class DiseaseTableViewCell: UITableViewCell {

    @IBOutlet weak var diseaseImageView: UIImageView!
    @IBOutlet weak var diseaseDescLabel: UILabel!
    @IBOutlet weak var DiseaseNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

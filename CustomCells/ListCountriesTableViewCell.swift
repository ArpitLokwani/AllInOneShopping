//
//  ListCountriesTableViewCell.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 22/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import UIKit

class ListCountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var countryCountLable: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countrySuperView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        countrySuperView.layer.cornerRadius = 10
        countrySuperView.layer.borderColor = UIColor.lightGray.cgColor
        //countrySuperView.layer.borderWidth = 1
        countrySuperView.layer.shadowColor = UIColor.lightGray.cgColor
        countrySuperView.layer.shadowOpacity = 0.5
        countrySuperView.layer.shadowOffset = .zero
        countrySuperView.layer.shadowRadius = 10
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  HomeTableViewCell.swift
//  DemoProject
//
//  Created by 張立 on 2017/11/28.
//  Copyright © 2017年 張立. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var HomeTableViewCellLabel: UILabel!
    @IBOutlet weak var HomeTableViewCellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

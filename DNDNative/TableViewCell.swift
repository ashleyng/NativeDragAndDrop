//
//  TableViewCell.swift
//  DNDNative
//
//  Created by Ashley Ng on 6/26/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithLabel(_ label: String) {
        self.label.text = label
    }
    
}

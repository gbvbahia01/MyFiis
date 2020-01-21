//
//  FiiHistoryViewCell.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import UIKit

class FiiHistoryViewCell: UITableViewCell {

    @IBOutlet weak var baseDtLabel: UILabel!
    @IBOutlet weak var pagtoDtLabel: UILabel!
    @IBOutlet weak var fiiValueLabel: UILabel!
    @IBOutlet weak var rentValueLabel: UILabel!
    @IBOutlet weak var yeldLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillTableCell(_ data: FiiData) {
        baseDtLabel.text = data.baseData
        pagtoDtLabel.text = data.pgtoData
        fiiValueLabel.text = data.value
        rentValueLabel.text = data.rentability
        yeldLabel.text = data.dy
    }
}

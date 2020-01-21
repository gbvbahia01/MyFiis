//
//  FiiViewCell.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import UIKit

class FiiViewCell: UITableViewCell {

    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var yeldLabel: UILabel!
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var dtPgtoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillTableCell(_ data: FiiData) {
        codeLabel.text = data.code
        yeldLabel.text = data.dy
        valueLabel.text = data.value
        rentLabel.text = data.rentability
        dateLabel.text = data.baseData
        dtPgtoLabel.text = data.pgtoData
    }
}

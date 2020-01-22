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
    @IBOutlet weak var toReceiveLabel: UILabel!
    @IBOutlet weak var dtpgtoLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    let formatter = NumberFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillTableCell(_ data: FiiData, _ amount: Int) {
        codeLabel.text = data.code
        yeldLabel.text = data.dy
        valueLabel.text = "\(data.value) x \(amount)"
        rentLabel.text = data.rentability
        dateLabel.text = data.baseData
        dtpgtoLabel.text = data.pgtoData
        var valueUnit = data.value.replacingOccurrences(of: "[R$. ]", with: "", options: [.regularExpression, .caseInsensitive])
        valueUnit = valueUnit.replacingOccurrences(of: "[,]", with: ".", options: [.regularExpression, .caseInsensitive])
        if let vu = Double(valueUnit) {
            let mktValue = vu * Double(amount)
            totalValueLabel.text = formatter.string(from: NSNumber(value: mktValue))
        }
        var toReceive = data.rentability.replacingOccurrences(of: "[R$. ]", with: "", options: [.regularExpression, .caseInsensitive])
        toReceive = toReceive.replacingOccurrences(of: "[,]", with: ".", options: [.regularExpression, .caseInsensitive])
        if let number = Double(toReceive) {
            let toReceiveAmount = number * Double(amount)
            toReceiveLabel.text = formatter.string(from: NSNumber(value: toReceiveAmount))
        }
    }
    
    
    
    
}

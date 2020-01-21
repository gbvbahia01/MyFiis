//
//  Fiis.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import Foundation
import RealmSwift

class Fiis: Object {
    @objc dynamic var codigo: String = ""
    @objc dynamic var amount: Int = 0
    
}

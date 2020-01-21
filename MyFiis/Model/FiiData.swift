//
//  FiiData.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//
/*
 from: https://fiis.com.br/btlg11/
 ÚLTIMOS REND. DO BTLG11
 (baseData)(pgtoData)(value)     (dy)   (rentability)
 Data-Base Data-Pgto Cotação-Base DY     Rendimento
 13/12/19  23/12/19  R$ 110,90    0,36%  R$ 0,40
 14/11/19  25/11/19  R$ 105,99    0,38%  R$ 0,40
 */
import Foundation

struct FiiData {
    let code: String
    let baseData: String
    let pgtoData: String
    let value: String
    let dy: String
    let rentability: String
}

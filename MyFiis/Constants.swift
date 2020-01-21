//
//  Constants.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import Foundation

struct K {
    
    static let CELL_FIIS_DATA = "ToDoItemCell"
    static let CELL_NIB_NAME = "FiiViewCell"
    static let CELL_HISTORY_DATA = "HistoryCell"
    static let CELL_HISTORY_NIB_NAME = "FiiHistoryViewCell"
    static let SEGUE_TO_HISTORY_FII_LIST = "detailFiis"
    struct HTML {
        static let SITE_URL = "https://fiis.com.br/" //btlg11/
        static let TABLE_ID = "last-revenues--table";
        static let TABLE_TAG = "td";
    }
    
    struct Persistence {
        static let FII_KEY = "FIIS_DATA"
    }
}

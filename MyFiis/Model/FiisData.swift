//
//  FiisData.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 22/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import Foundation

struct FiisData: Comparable {
    
    static func == (lhs: FiisData, rhs: FiisData) -> Bool {
         return lhs.code == rhs.code
    }
    /*
     The < function needs to accept two instances of your type,
     one of the left-hand side and one on the right, and return
     true if the left-hand object should be ordered before the
     right-hand object.
     */
    static func < (lhs: FiisData, rhs: FiisData) -> Bool {
        return lhs.code < rhs.code
    }
    
    let code: String
    let fiisHistory: [FiiData]
    
    init(code: String) {
        self.code = code
        fiisHistory = [FiiData]()
    }
    
    init(code: String, fiisHistory: [FiiData]) {
        self.code = code
        self.fiisHistory = fiisHistory
    }
}


extension Array where Element == FiisData {
    func searchBy(codeFII code: String) -> [FiiData]? {
        
        for fii in self {
            if fii.code == code {
                return fii.fiisHistory
            }
        }
        return nil
    }

    mutating func removeBy(codeFII fii: String) -> Bool {
        if let idx = firstIndex(of: FiisData(code: fii)) {
            remove(at: idx)
            return true;
        }
        return false;
    }
}

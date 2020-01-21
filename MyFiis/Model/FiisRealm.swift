//
//  FiisRealm.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//
import Foundation
import RealmSwift

extension Realm {
    var fiisResult: Results<Fiis> {
        return objects(Fiis.self).sorted(byKeyPath: "codigo")
    }
}

extension Realm {
    
    func saveFiis(fiis: Fiis) {
        print(#function)
        if fiisResult.filter("codigo = '\(fiis.codigo)' ").first != nil {
            updateFiis(codigo: fiis.codigo, amount: fiis.amount)
        } else {
            do {
                try write {
                    add(fiis)
                }
            } catch {
                print("Error saving category \(error)")
            }
        }
    }
    
    func deleteFiis(_ fiis: String) {
        deleteFiis(fiisResult.filter("codigo = '\(fiis)' ").first)
    }
    
    func deleteFiis(_ fiis: Fiis?) {
        print(#function)
        if fiis != nil, let fdel = fiisResult.filter("codigo = '\(fiis!.codigo)' ").first {
            do {
                try write {
                    delete(fdel)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    func updateFiis(codigo: String, amount: Int) {
        print(#function)
        if let oldFiis = fiisResult.filter("codigo = '\(codigo)' ").first {
            do {
                 try write {
                    oldFiis.amount = amount
                 }
             } catch {
                 print("Error deleting category, \(error)")
             }
        }
    }
    

    
}

let store = try! Realm()

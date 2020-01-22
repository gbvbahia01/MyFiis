//
//  FiisDataCollector.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import Foundation
import SwiftSoup
import RealmSwift

protocol FiiManagerDelegate {
    func didUpdateFii(_ withCollector: FiisDataCollector, forCode: String, withFii: [FiiData]);
    func didFailWithError(with error: Error);
}

struct FiisDataCollector {
    var delegate: FiiManagerDelegate?;
    
    func scheduledFiis(with fiis: [String]) {
        //print(#function)
        let queue = DispatchQueue.global(qos: .background)
        // Do somthing after i seconds
        var i = -1.0
        for fii in fiis {
            i += 1.0;
            queue.asyncAfter(deadline: .now() + i) {
                self.fetchFiis(fiiCode: fii)
            }
        }
    }
    
    func fetchFiis(fiiCode: String) {
         if let fii = fiiCode.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
             //print("Going to get: \(fii)")
             let urlString = "\(K.HTML.SITE_URL)\(fii)/";
             self.performRequest(with: urlString, fiiCode);
         }
    }
    
    fileprivate func performRequest(with urlString : String, _ fiiCode: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) { (data, response, error) in
                if (error != nil) {
                     DispatchQueue.main.async {
                        self.delegate?.didFailWithError(with: error!)
                    }
                    return;
                }
                if let safeData = data {
                    if let fii = self.parseHTML(safeData, fiiCode), !fii.isEmpty {
                        //print("Got: \(fii[0])")
                         DispatchQueue.main.async {
                            self.delegate?.didUpdateFii(self, forCode: fiiCode, withFii: fii);
                        }
                    }
                }
            }
             //print("Going to URL: \(urlString)");
            task.resume();
        } else {
            print("Invalid URL: \(urlString)");
        }
    }
    
    fileprivate func parseHTML(_ fiiData: Data, _ fiiCode: String) -> [FiiData]? {
        var fiis = [FiiData]()
        do {
            let html = String(decoding: fiiData, as: UTF8.self)
            let doc: Document = try SwiftSoup.parse(html)
            if let elementTable = try doc.getElementById(K.HTML.TABLE_ID) {
                let tds = try elementTable.getElementsByTag(K.HTML.TABLE_TAG)
                var extractedData = [String]()
                for td: Element in tds.array() {
                    extractedData.append(try td.text());
                    if (extractedData.count == 5) {
                        fiis.append(FiiData(code: fiiCode,
                                            baseData: extractedData[0],
                                            pgtoData: extractedData[1],
                                            value: extractedData[2],
                                            dy: extractedData[3],
                                            rentability: extractedData[4]))
                        extractedData.removeAll()
                    }
                }
            }
        } catch {
             DispatchQueue.main.async {
                self.delegate?.didFailWithError(with: error)
            }
        }
        return fiis
    }
}

//
//  FiiHistoryListViewController.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import UIKit


class FiiHistoryListViewController: UITableViewController {

    var fiiHistoryData = [FiiData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.register(UINib(nibName: K.CELL_HISTORY_NIB_NAME,
                           bundle: nil),
                           forCellReuseIdentifier: K.CELL_HISTORY_DATA)
    }
    
    //MARK: - Table Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiiHistoryData.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CELL_HISTORY_DATA, for: indexPath) as! FiiHistoryViewCell
        cell.fillTableCell(fiiHistoryData[indexPath.row])
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Dt.Base Dt.Pgto Cotação Valor Yeld"
    }

}

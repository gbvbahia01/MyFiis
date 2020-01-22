//
//  FiisListViewController.swift
//  MyFiis
//
//  Created by Guilherme B V Bahia on 21/01/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import UIKit
import RealmSwift

class FiisListViewController: UITableViewController {

    let fiis = store.fiisResult
    var fiisArray = [FiisData]();
    var fiiCollector = FiisDataCollector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.CELL_NIB_NAME,
                                bundle: nil),
                           forCellReuseIdentifier: K.CELL_FIIS_DATA)
        
        fiiCollector.delegate = self
        loadAllFiisData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    fileprivate func loadAllFiisData() {
        if fiis.isEmpty {
            return
        }
        var codigos = [String]()
        for fii in fiis {
            codigos.append(fii.codigo)
            fiisArray.append(FiisData(code: fii.codigo))
        }
        self.tableView.reloadData()
        self.fiiCollector.scheduledFiis(with: codigos);
    }
    
    fileprivate func deleteFii(_ forCode: String) {
        store.deleteFiis(forCode)
        let _ = fiisArray.removeBy(codeFII: forCode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FiiHistoryListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.fiiHistoryData =  fiisArray[indexPath.row].fiisHistory
            destinationVC.navigationItem.title = fiisArray[indexPath.row].code
        }
    }
    
    //MARK: - Table Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiisArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CELL_FIIS_DATA, for: indexPath) as! FiiViewCell
        let fii = fiisArray[indexPath.row];
        cell.codeLabel.text = fii.code
        if (!(fii.fiisHistory.isEmpty)) {
           
            var amount = 0;
            if let fii = fiis.filter("codigo = '\(fii.code)' ").first {
                amount = fii.amount
            }
            cell.fillTableCell(fii.fiisHistory[0], amount)
            cell.accessoryType = .disclosureIndicator
            cell.state(loading: false)
        } else {
            cell.fillTableCell(FiiData(code: fii.code,
                                       baseData: "---",
                                       pgtoData: "---",
                                       value: "---",
                                       dy: "---",
                                       rentability: "---"), 0)
            cell.accessoryType = .none
            cell.state(loading: true)
            //self.fiiCollector.fetchFiis(fiiCode: code);
        }
        
        return cell;
    }


    
    //MARK: - TableView Delegate Mathods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (fiisArray[indexPath.row].fiisHistory.isEmpty) {
            fiiCollector.fetchFiis(fiiCode: fiisArray[indexPath.row].code)
            tableView.deselectRow(at: indexPath, animated: true);
            print("Going to get \(fiisArray[indexPath.row].code)")
        } else {
            performSegue(withIdentifier: K.SEGUE_TO_HISTORY_FII_LIST, sender: self)
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
                deleteFii(fiisArray[indexPath.row].code)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var codigoField = UITextField();
        var amountField = UITextField();
        
        let alert = UIAlertController(title: "Add New Fii Item",
                                      message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Fii", style: .default) { (action) in
            if let fii = codigoField.text?.uppercased(), let amount = Int(amountField.text ?? "0") {
                if self.fiisArray.searchBy(codeFII: fii) == nil {
                    let newFiis = Fiis()
                    newFiis.codigo = fii
                    newFiis.amount = amount
                    store.saveFiis(fiis: newFiis)
                    self.fiiCollector.fetchFiis(fiiCode: fii);
                    self.tableView.reloadData()
                } else {
                    if let fii = self.fiis.filter("codigo = '\(fii)' ").first {
                        store.updateFiis(codigo: fii.codigo, amount: fii.amount + amount)
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Fii name"
            codigoField = alertTextField
        }
        
        alert.addTextField { (amountTextField) in
            amountTextField.placeholder = "Fii Amount"
            amountField = amountTextField
            amountField.keyboardType = UIKeyboardType.numberPad
        }
        
        alert.addAction(action);
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }

}

//MARK: - FiiManagerDelegate
extension FiisListViewController: FiiManagerDelegate {
        
    func didUpdateFii(_ withCollector: FiisDataCollector,
                      forCode: String,
                      withFii: [FiiData]) {
        let _ = self.fiisArray.removeBy(codeFII: forCode)
        self.fiisArray.append(FiisData(code: forCode, fiisHistory: withFii))
        self.fiisArray.sort()
        self.tableView.reloadData()
        //print(withFii)
    }
    
    func didFailWithError(with error: Error) {
        print(error);
    }
   
}


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
    var fiisDictionary = [String: [FiiData]]();
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
        }
        self.fiiCollector.scheduledFiis(with: codigos);
    }
    
    fileprivate func deleteFii(_ forCode: String) {
        store.deleteFiis(forCode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FiiHistoryListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.fiiHistoryData = fiisDictionary[Array(fiisDictionary.keys)[indexPath.row]] ?? [FiiData]()
            
            destinationVC.navigationItem.title = Array(fiisDictionary.keys)[indexPath.row]
        }
    }
    
    //MARK: - Table Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(fiisDictionary.keys).count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CELL_FIIS_DATA, for: indexPath) as! FiiViewCell
        let code = Array(fiisDictionary.keys)[indexPath.row];
        cell.codeLabel.text = code
        if (!(fiisDictionary[code]?.isEmpty ?? true)) {
            let data = fiisDictionary[code]!
            cell.fillTableCell(data[0])
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.fillTableCell(FiiData(code: code,
                                       baseData: "",
                                       pgtoData: "",
                                       value: "",
                                       dy: "",
                                       rentability: ""))
            cell.accessoryType = .none
            //self.fiiCollector.fetchFiis(fiiCode: code);
        }
        
        return cell;
    }


    
    //MARK: - TableView Delegate Mathods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (fiisDictionary[Array(fiisDictionary.keys)[indexPath.row]]?.isEmpty ?? true) {
            fiiCollector.fetchFiis(fiiCode: Array(fiisDictionary.keys)[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true);
        } else {
            performSegue(withIdentifier: K.SEGUE_TO_HISTORY_FII_LIST, sender: self)
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
                deleteFii(Array(fiisDictionary.keys)[indexPath.row])
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
                if self.fiisDictionary.keys.firstIndex(of: fii) == nil {
                    let newFiis = Fiis()
                    newFiis.codigo = fii
                    newFiis.amount = amount
                    store.saveFiis(fiis: newFiis)
                    self.fiiCollector.fetchFiis(fiiCode: fii);
                    self.tableView.reloadData()
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
        self.fiisDictionary[forCode] = withFii;
        self.tableView.reloadData()
        //print(withFii)
    }
    
    func didFailWithError(with error: Error) {
        print(error);
    }
   
}


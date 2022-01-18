//
//  GlobalGroupTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit

class GlobalGroupTableViewController: UITableViewController {
    
    let reuseIdentifierGlobalGroupCell = "GlobalGroupCell"
    
    var globalGroup = [Group]()
    
    func setupGroup() -> [Group] {
        var resultArray = [Group]()
        
        let globalGroupOne = Group(name: "FunGroup Ronaldo", avatar: UIImage(named: "1_3")!, description: nil)
        resultArray.append(globalGroupOne)
        
        let globalGroupTwo = Group(name: "FunGroup Beckham", avatar: UIImage(named: "2_2")!, description: nil)
        resultArray.append(globalGroupTwo)
        
        let globalGroupThree = Group(name: "FunGroup Messi", avatar: UIImage(named: "4_4")!, description: nil)
        resultArray.append(globalGroupThree)
        
        let globalGroupFour = Group(name: "FunGroup Ronaldinho", avatar: UIImage(named: "3_3")!, description: nil)
        resultArray.append(globalGroupFour)
        
        return resultArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierGlobalGroupCell)
        
        globalGroup = setupGroup()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierGlobalGroupCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
        cell.configure(group: globalGroup[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UniversalCell,
              let cellObject = cell.savedObject as? Group else { return }
        
        NotificationCenter.default.post(name: NSNotification.Name("sendGroup"), object: cellObject)
        self.navigationController?.popViewController(animated: true)
    }
}

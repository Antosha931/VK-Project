//
//  GlobalGroupTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit

class GlobalGroupTableViewController: UITableViewController {
    
    private let globalGroupSearchBar = UISearchBar()
    
    private let reuseIdentifierGlobalGroupCell = "GlobalGroupCell"
    
    var globalGroup = [ItemsGroup]()
    
    private let networking = NetworkService()
    private var resultSearchGrlobalGroup = [ItemsGroup]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var searchString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.globalGroupSearchBar.delegate = self
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierGlobalGroupCell)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchGrlobalGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierGlobalGroupCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
//        if let itemsGroup = Groups(itemsGroup: resultSearchGrlobalGroup[indexPath.row]) {
            cell.configure(group: Groups(itemsGroup: resultSearchGrlobalGroup[indexPath.row]))
//        }
        
        return cell
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UniversalCell,
              let cellObject = cell.savedObject as? Groups else { return }
        
        NotificationCenter.default.post(name: NSNotification.Name("sendGroup"), object: cellObject)
        self.navigationController?.popViewController(animated: true)
    }
}

extension GlobalGroupTableViewController: UISearchBarDelegate {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return globalGroupSearchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultSearchGrlobalGroup = globalGroup
        } else {
            searchString = searchText
            
            networking.fetchGlobalGroup(groupSearch: searchString, completion: { [weak self] result in
                switch result {
                case .success(let globalGroupItems):
                    self?.resultSearchGrlobalGroup = globalGroupItems
                case .failure(let error):
                    print(error)
                }
            })
            
            resultSearchGrlobalGroup = globalGroup.filter({ item in
                item.name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultSearchGrlobalGroup = globalGroup
    }
}

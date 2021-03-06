//
//  GroupTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit
import RealmSwift

final class UserGroupTableViewController: UITableViewController {
    
    private let reuseIdentifierUserGroupCell = "UserGroupCell"
    private let segueIdentifierToGlobalGroupController = "segueIdentifierToGlobalGroupController"
    
    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "operationQueue"
        operationQueue.qualityOfService = .userInteractive
        return operationQueue
    }()
    
    private var groupSearchBar = UISearchBar()
    private let networking = NetworkService()
    private var realmGroups: Results<RealmGroups>?
    private var resultSearchGroup = [RealmGroups]()
    private var groupsToken: NotificationToken?
    private var groupItems = [RealmGroups]() {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadGroups() {
        realmGroups = try? RealmService.load(typeOf: RealmGroups.self)
        
        groupItems = groupSorting()
        
        tableView.reloadData()
    }
    
    private func groupSorting() -> [RealmGroups] {
        var lettersOfName: [RealmGroups] = []
        guard let groups = realmGroups else { return lettersOfName }
        for item in groups {
            if !lettersOfName.contains(item) {
                lettersOfName.append(item)
            }
        }
        return lettersOfName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        groupSearchBar.delegate = self
        
        let getData = GetDataOperation()
        let parseData = ParseDataOperation()
        let saveRealmData = SaveDataRealmOperation(controller: self)
        
        parseData.addDependency(getData)
        saveRealmData.addDependency(parseData)
        
        operationQueue.addOperation(getData)
        operationQueue.addOperation(parseData)
        operationQueue.addOperation(saveRealmData)
        
        OperationQueue.main.addOperation {
            self.reloadGroups()
        }
        
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserGroupCell)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(addNewGroup(_:)), name: NSNotification.Name(rawValue: "sendGroup"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        groupsToken = realmGroups?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.tableView.reloadData()
                print(deletions, insertions, modifications)
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        groupsToken?.invalidate()
    }
    
//    private func isContainInArray(group: ItemsGroup) -> Bool {
//        if groupItems.contains(where: { itemGroup in itemGroup.name == group.name}) {
//            return true
//        }
//        return false
//    }
//
//    @objc func addNewGroup(_ notification: Notification) {
//
//        guard let newGroup = notification.object as? ItemsGroup else {return}
//
//        if isContainInArray(group: newGroup) {
//            return
//        }
//        groupItems.append(newGroup)
//        self.tableView.reloadData()
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchGroup.isEmpty {
            return groupItems.count
        }
        return resultSearchGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierUserGroupCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
        if resultSearchGroup.isEmpty {
            cell.configure(group: groupItems[indexPath.row])
        } else {
            cell.configure(group: resultSearchGroup[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UserGroupTableViewController: UISearchBarDelegate {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return groupSearchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultSearchGroup = groupItems
        } else {
            resultSearchGroup = groupItems.filter({ item in
                item.name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.endEditing(true)
    }
}

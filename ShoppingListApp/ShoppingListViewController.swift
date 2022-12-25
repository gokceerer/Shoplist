//
//  ViewController.swift
//  ShoppingListApp
//
//  Created by G on 8.12.2022.
//

import UIKit

class ShoppingListViewController: UITableViewController {
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var greetingArea: UIView!
    @IBOutlet private weak var shoppingListHeaderLabel: UILabel!
    
    var viewModel: ShoppingListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ShoppingListViewModel()
        setupGreetingArea()
        setupBarButtonItems()
    }
    
    func setupShoppingListHeader() {
        if viewModel.getShoppingListCount() > 0 {
            shoppingListHeaderLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
            shoppingListHeaderLabel.text = "Shopping List"
        } else {
            shoppingListHeaderLabel.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 17)
            shoppingListHeaderLabel.text = "Tap + to add new items..."
        }
    }
    
    func setupBarButtonItems() {
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        leftBarItem.tintColor = UIColor(red: 136.0/255.0, green: 165.0/255.0, blue: 134.0/255.0, alpha: 1)
        rightBarItem.tintColor = UIColor(red: 136.0/255.0, green: 165.0/255.0, blue: 134.0/255.0, alpha: 1)

        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func setupGreetingArea() {
        greetingLabel.text = viewModel.getGreetingText()
        greetingArea.layer.cornerRadius = 10
        greetingArea.layer.shadowColor = UIColor.gray.cgColor
        greetingArea.layer.shadowOpacity = 0.5
        greetingArea.layer.shadowOffset = .zero
        greetingArea.layer.shadowRadius = 10
    }
}

//UITableViewDataSource and UITableViewDelegate function implementations
extension ShoppingListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShoppingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ShoppingListTableViewCell

        if indexPath.section == 0 {
            if viewModel.getShoppingListCount() == 0 {
                cell.updateCell(itemName: "Please tap + button to add a new item...")
            }
            cell.updateCell(itemName: viewModel.getItemName(at: indexPath.row))
            cell.isUserInteractionEnabled = true
        } else if indexPath.section == 1 {
            cell.updateCell(itemName: viewModel.getPurchasedItemName(at: indexPath.row))
            cell.strikeThroughCell()
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if section == 0 {
            count = viewModel.getShoppingListCount()
        } else if section == 1 {
            count = viewModel.getPurchasedItemListCount()
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 && viewModel.getPurchasedItemListCount() > 0 ? "Purchased Items" : nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
            myLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListTableViewCell
            
            cell.strikeThroughCell()
            viewModel.removeItemShoppingList(at: indexPath.row, cause: .purchased)
            tableView.reloadData()
            self.setupShoppingListHeader()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && editingStyle == .delete {
            viewModel.removeItemShoppingList(at: indexPath.row, cause: .remove)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.setupShoppingListHeader()
        }
    }
}

//Objc functions
extension ShoppingListViewController {
    @objc func addItem() {
        let alert = UIAlertController(title: "Enter item:", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text {
                self.viewModel.addItemToList(item: text)
                self.tableView.insertRows(at: [IndexPath(row: self.viewModel.getShoppingListCount()-1, section: 0)], with: .automatic)
                self.tableView.reloadData()
                self.setupShoppingListHeader()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    
    @objc func clearList(){
        let alert = UIAlertController(title: "Choose one option", message: "Which list you want to clear?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Clear my shopping list", style: UIAlertAction.Style.default, handler:  { _ in
            self.viewModel.clearShoppingList()
            self.tableView.reloadSections([0], with: .automatic)
            self.setupShoppingListHeader()
        }))
        alert.addAction(UIAlertAction(title: "Clear my purchased list", style: UIAlertAction.Style.default, handler: { _ in
            self.viewModel.clearPurchasedList()
            self.tableView.reloadSections([1], with: .automatic)
        }))
        alert.addAction(UIAlertAction(title: "Clear all lists", style: UIAlertAction.Style.destructive, handler:  { _ in
            self.viewModel.clearShoppingList()
            self.viewModel.clearPurchasedList()
            self.tableView.reloadSections([0,1], with: .automatic)
            self.setupShoppingListHeader()

        }))
        self.present(alert, animated: true, completion: nil)
    }
}


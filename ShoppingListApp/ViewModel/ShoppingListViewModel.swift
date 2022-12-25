//
//  ShoppingListViewModel.swift
//  ShoppingListApp
//
//  Created by G on 25.12.2022.
//

import Foundation

protocol ShoppingListViewModelProtocol {
    func addItemToList(item: String)
    func clearShoppingList()
    func removeItemShoppingList(at index: Int, cause: ShoppingListDeletionCause)
    func getShoppingListCount() -> Int
    func getItemName(at index: Int) -> String
    func getPurchasedItemListCount() -> Int
    func getPurchasedItemName(at index: Int) -> String
    func clearPurchasedList()
    func getGreetingText() -> String
}

enum ShoppingListDeletionCause {
    case remove
    case purchased
}

class ShoppingListViewModel: ShoppingListViewModelProtocol {
    
    private var shoppingListArr: [String] = []
    private var purchasedItemListArr: [String] = []
        
    func addItemToList(item: String) {
        shoppingListArr.append(item)
    }
    
    func clearShoppingList() {
        shoppingListArr.removeAll()
    }
    
    func removeItemShoppingList(at index: Int, cause: ShoppingListDeletionCause) {
        let item = shoppingListArr.remove(at: index)
        if cause == .purchased {
            purchasedItemListArr.append(item)
        }
    }
    
    func clearPurchasedList() {
        purchasedItemListArr.removeAll()
    }
    
    func getShoppingListCount() -> Int {
        return shoppingListArr.count
    }
    
    func getPurchasedItemListCount() -> Int {
        return purchasedItemListArr.count
    }
    
    func getItemName(at index: Int) -> String {
        return shoppingListArr[index]
    }
    
    func getPurchasedItemName(at index: Int) -> String {
        return purchasedItemListArr[index]
    }
    
    func getGreetingText() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!
        let greetingText: String
        if hourInt >= 12 && hourInt <= 16 {
            greetingText = "Good Afternoon!"
        }
        else if hourInt >= 7 && hourInt <= 12 {
            greetingText = "Good Morning!"
        }
        else if hourInt >= 16 && hourInt <= 20 {
            greetingText = "Good Evening!"
        }
        else if hourInt >= 20 && hourInt <= 24 {
            greetingText = "Good Night!"
        }
        else if hourInt >= 0 && hourInt <= 7 {
            greetingText = "Good Night!"
        } else {
            greetingText = "Hello!"
        }
        
        return greetingText
    }
}

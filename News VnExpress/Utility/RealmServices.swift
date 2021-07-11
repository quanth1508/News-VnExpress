//
//  Realm.swift
//  News VnExpress
//
//  Created by Quan Tran on 09/07/2021.
//

import Foundation
import RealmSwift

final class RealmServices {
    
    weak var bookmarkViewController: BookMarkViewController?
    
    // Save Data Object Bookmark Model realm
    func saveData(saveObj elementResult: BookmarkModel) {
        try! Contants.realm.write({
            Contants.realm.add(elementResult, update: .modified)
            DispatchQueue.main.async { [weak self] in
                self?.bookmarkViewController?.tableViewBookMark.reloadData()
            }
            print("saved data")
        })
    }
    
    // Delete Data Object Results type realm
    func deleteData(deleteObj elementResult: Results<BookmarkModel>) {
        do {
            try Contants.realm.write({
                Contants.realm.delete(elementResult)
                DispatchQueue.main.async { [weak self] in
                    self?.bookmarkViewController?.tableViewBookMark.reloadData()
                }
                print("deleted data")
            })
        }
        catch {
            print("error delete: \(error.localizedDescription)")
        }
    }
    
    // Delete All Data
    func deleteAllData() {
        do {
            try Contants.realm.write({
                Contants.realm.deleteAll()
                DispatchQueue.main.async { [weak self] in
                    self?.bookmarkViewController?.tableViewBookMark.reloadData()
                }
                print("deleted all data")
            })
        }
        catch {
            print("error remove all: \(error.localizedDescription)")
        }
    }
}


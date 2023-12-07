//
//  CoredataController.swift
//  Booster
//
//  Created by Fy Spoti on 07/12/2023.
//

import Foundation
import CoreData
import UIKit

class CoredataController {
    
    static let share = CoredataController()
    
    
    func updateGameToCoreDataByGameID(gameID: Int, withNewStatus status: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.predicate = NSPredicate(format: "game_id == %d", gameID)
        
        do {
            let games = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let gameToUpdate = games?.first as? GameSave {
                // Cập nhật trạng thái mới
                gameToUpdate.setValue(status, forKey: "status")
                
                // Lưu thay đổi vào Core Data
                try context.save()
            }
        } catch {
            print("Error updating game: \(error)")
        }
    }

    func deleteGameFromCoreData(gameID: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.predicate = NSPredicate(format: "game_id == %d", gameID)
        
        do {
            if let games = try context.fetch(fetchRequest) as? [NSManagedObject], let gameToDelete = games.first {
                // Xoá đối tượng khỏi Core Data
                context.delete(gameToDelete)
                
                // Lưu thay đổi
                try context.save()
            }
        } catch {
            print("Error deleting game: \(error)")
        }
    }

    
    
    
    
}

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
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
//        fetchRequest.returnsObjectsAsFaults = false
              do {
            let games = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let gameToUpdate = games?.first as? GameSave {
                // Cập nhật trạng thái mới
                gameToUpdate.setValue(status, forKey: "status")
                
                // Lưu thay đổi vào Core Data
                try context.save()
            }
                  else {
                      print("game chưa có trong core data")
                      
                      
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
                print("Deleted")
            }
        } catch {
            print("Error deleting game: \(error)")
        }
    }

    
    func saveGameToCoreData(game: Game, status: String, completion: @escaping (Bool) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Kiểm tra xem trò chơi với ID đã tồn tại trong Core Data hay chưa
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.predicate = NSPredicate(format: "game_id == %d", game.gameId!)

        do {
            let existingGames = try context.fetch(fetchRequest) as! [NSManagedObject]

            if let existingGame = existingGames.first {
                // Trò chơi đã tồn tại, không thay đổi trạng thái và không thực hiện lưu
                self.updateGameToCoreDataByGameID(gameID: game.gameId!, withNewStatus: status)
            } else {
                // Trò chơi chưa tồn tại, thêm mới vào Core Data
                let gameEntity = NSEntityDescription.insertNewObject(forEntityName: "GameSave", into: context)
                gameEntity.setValue(game.gameId, forKey: "game_id")
                gameEntity.setValue(status, forKey: "status")
                gameEntity.setValue(game.sampleCover?.thumbnailImageURL, forKey: "thumbnail_image")
                gameEntity.setValue(game.title, forKey: "title")

                // Lưu thay đổi vào Core Data
                try context.save()
                print("Game saved to Core Data")
                NotificationCenter.default.post(name: NSNotification.Name("reloadProfileData"), object: nil)
                completion(true)
            }
        } catch {
            print("Error checking for existing game: \(error)")
            completion(false)
        }
    }


    
}

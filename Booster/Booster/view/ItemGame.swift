//
//  ItemGame.swift
//  Booster
//
//  Created by Fy Spoti on 18/12/2023.
//

import Foundation
import UIKit

protocol ItemGameDelegate: AnyObject {

    func imageTapped (at: IndexPath)
}


class ItemGame: UIView {
    
    var rowOfIndexPath: IndexPath?
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    
    //var gameCell: Game?

    
    weak var delegate: ItemGameDelegate?

    

    func displayRecommendGame(game: Game) {
//        self.nameGame?.text = game.title
        if let name = game.title {
            print(name)
            if let nameLabel = self.nameGame {
                nameLabel.text = name
                print(nameLabel.text)
            } else {
                print("self.nameGame is nil")
            }
        }
        MobyGamesService.share.fetchImage(from: game.sampleCover?.thumbnailImageURL) {
            result in
            switch result {
            case .success(let image):
                self.imageGame?.image = image
                
            case .failure(let error):
                print(error)
            }
        
        }
    }
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        self.delegate?.imageTapped(at: rowOfIndexPath!)
        
    }
    
}


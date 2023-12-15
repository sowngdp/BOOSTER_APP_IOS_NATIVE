//
//  CollectionItemGame.swift
//  Booster
//
//  Created by hoi on 12/11/2023.
//

import Foundation
import UIKit

protocol CollectionItemGameDelegate: AnyObject {
    func addButtonTapped( at: IndexPath)
    func imageTapped (at: IndexPath)
}


class CollectionItemGame: UICollectionViewCell {
    
    var rowOfIndexPath: IndexPath?
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    
    //var gameCell: Game?
    @IBOutlet weak var buttonAdd: UILabel!
    
    weak var delegate: CollectionItemGameDelegate?
    
    @objc func addButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        self.delegate?.addButtonTapped( at: rowOfIndexPath!)
        
    }
    

    func displayRecommendGame(game: Game) {
//        self.nameGame?.text = game.title
        if let name = game.title {
            self.nameGame?.text! = name
            print(nameGame?.text!)
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

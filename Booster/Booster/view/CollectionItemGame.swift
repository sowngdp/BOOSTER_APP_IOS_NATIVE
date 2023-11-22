//
//  CollectionItemGame.swift
//  Booster
//
//  Created by hoi on 12/11/2023.
//

import Foundation
import UIKit

protocol CollectionItemGameDelegate: AnyObject {
    func addButtonTapped( at: Game)
}


class CollectionItemGame: UICollectionViewCell {
    
    var rowOfIndexPath: Int?
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    var gameCell: Game?
    
    weak var delegate: CollectionItemGameDelegate?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        self.delegate?.addButtonTapped( at: gameCell!)
        
    }
}

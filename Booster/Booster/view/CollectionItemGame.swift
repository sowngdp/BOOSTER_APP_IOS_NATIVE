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
    


    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        self.delegate?.imageTapped(at: rowOfIndexPath!)
        
    }
    
}

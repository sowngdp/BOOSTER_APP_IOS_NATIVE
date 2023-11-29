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
    @IBOutlet weak var buttonAdd: UIButton!
    //var gameCell: Game?
    
    weak var delegate: CollectionItemGameDelegate?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        self.delegate?.addButtonTapped( at: rowOfIndexPath!)
        
    }
    


    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        self.delegate?.imageTapped(at: rowOfIndexPath!)
        
    }
    
}

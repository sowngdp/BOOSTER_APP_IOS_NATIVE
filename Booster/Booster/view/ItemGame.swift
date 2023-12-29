//
//  ItemGame.swift
//  Booster
//
//  Created by Fy Spoti on 18/12/2023.
//

import Foundation
import UIKit

protocol ItemGameDelegate: AnyObject {

    func imageTapped (at: Game)
}


class ItemGame: UIView {
    
    var gameID: Int?
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    
    var game: Game?

    
    weak var delegate: ItemGameDelegate?

    


        
    
    
    
    @objc func imageTapp(tapGestureRecognizer: UITapGestureRecognizer)
    {

        self.delegate?.imageTapped(at: game!)
        
    }
    
}


//
//  CharacterCountView.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CharacterCountView: UIView {

    @IBOutlet weak var charCountLabel: UILabel!
    let characterLimit = 140

    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    func updateCharacterCount(count: Int) {
        //update the count character label
        self.charCountLabel.text = (characterLimit - count).description
    }

}

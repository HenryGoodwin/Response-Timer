//
//  RoundedView.swift
//  Reflexes
//
//  Created by Henry Goodwin on 1/05/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }

}

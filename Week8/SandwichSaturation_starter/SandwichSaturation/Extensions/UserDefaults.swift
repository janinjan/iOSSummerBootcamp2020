//
//  UserDefaults.swift
//  SandwichSaturation
//
//  Created by Janin Culhaoglu on 17/07/2020.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

extension UserDefaults {
    var lastScopeSelection: Int {
        get { object(forKey: #function) as? Int ?? 0 }
        set { set(newValue, forKey: #function) }
    }
}

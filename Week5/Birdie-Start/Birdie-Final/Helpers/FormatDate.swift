//
//  FormatDate.swift
//  Birdie-Final
//
//  Created by Janin Culhaoglu on 10/07/2020.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

struct FormatDate {

    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"

        return dateFormatter.string(from: date)
    }
}

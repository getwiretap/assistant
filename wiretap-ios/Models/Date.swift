//
//  Date.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation


typealias FormattedDate = String


extension Date {
    
   static func getFullDate() -> FormattedDate {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
    
        let formattedDate = dateformat.string(from: Date())
    
        return formattedDate
    }
    
    static func getMonth() -> FormattedDate {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM"
    
        let formattedDate = dateformat.string(from: Date())
    
        return formattedDate
    }
    
}

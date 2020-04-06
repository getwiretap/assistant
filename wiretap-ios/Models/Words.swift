//
//  Word.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-03.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation


struct Words {
    
    let words: [String]
    
    var formatedString: String {
        words.joined(separator: " ")
    }
    
    
    init(_ string: String) {
        
        let words = string
            .split(separator: " ")
            .map { $0.lowercased() }
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }

        self.words = words
    }
    
    func substring(keepFirst: Int) -> String {
        if keepFirst >= words.count {
            return formatedString
        }
        
        let newWords = Array(words.dropLast(words.count - keepFirst))
        
        return newWords.joined(separator: " ")
    }
    
    func substring(keepLast: Int) -> String {
        if keepLast >= words.count {
            return formatedString
        }
        
        let newWords = Array(words.dropFirst(words.count - keepLast))
        
        return newWords.joined(separator: " ")
    }
    
    func substring(dropFirst: Int) -> String {
        if dropFirst >= words.count {
            return ""
        }
        
        let newWords = Array(words.dropFirst(dropFirst))
        
        return newWords.joined(separator: " ")
    }
    
    func substring(dropLast: Int) -> String {
        if dropLast >= words.count {
            return ""
        }
        
        let newWords = Array(words.dropLast(dropLast))
        
        return newWords.joined(separator: " ")
    }
  
}

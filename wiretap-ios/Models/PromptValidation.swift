//
//  PromptValidation.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-05.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation


struct PromptValidation {
    
    var progress: [SimilarityScores] = [(0, 0), (0, 0)]
    
    var isValid: Bool = false
    var willProbablyBeValid: Bool = false

    mutating func validate(_ similarityScores: SimilarityScores) {
        progress.insert(similarityScores, at: 0)
        progress.removeLast()
        
        let (full, minusOne) = similarityScores
        let (_, prevMinusOne) = progress[1]
        
        if minusOne > 85 {
            willProbablyBeValid = true
        }
        
        if full > 85 && full >= prevMinusOne {
            isValid = true
        }
        
        print(progress)
    }
    
    mutating func reset() {
        progress = [(0, 0), (0, 0)]
        isValid = false
        willProbablyBeValid = false
    }
}

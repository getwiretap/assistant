//
//  Prompt.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation

class Prompt: Identifiable {
    
    let id: String = UUID().uuidString
    let displayText: String
    var isValidated: Bool = false
    
    init(displayText: String) {
        self.displayText = displayText
    }
    
    func getConfidence(_ transcription: String) -> Int {
        let stringMetrics = StringMetrics(origin: displayText, target: transcription)
        
        return stringMetrics.confidence()
    }

    func validate(_ transcription: String) {
        let confidence = getConfidence(transcription)
        
        if confidence > 87 {
            self.isValidated = true
        }
    }
    
    func reset() {
        isValidated = false
    }
}

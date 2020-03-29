//
//  Prompts.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation


class Prompts: ObservableObject  {
    
    @Published var prompts: [Prompt]
    
    init() {
        prompts = [
            Prompt(displayText: "Good morning and welcome to Pizza Planet. My name is Nic, what can we get for you today?"),
            Prompt(displayText: "Would you like some guacamole with your quesadillas?"),
            Prompt(displayText: "Do you have your Planet+ rewards card with you today?"),
            Prompt(displayText: "Well, if you're interested, membership is completely free, and you'll earn points on every order."),
        ]
    }

    func resetAll() {
        prompts.forEach() { $0.reset() }
    }
    
    func getKeywords() -> [String] {
        var keywordSet: Set<String> = []
        
        for prompt in prompts {
            let keywordsArray = prompt.displayText
                .split(separator: " ")
                .map { String($0).normalized }
            
            for keyword in keywordsArray {
                keywordSet.insert(keyword)
            }
        }
        
        return keywordSet.sorted()
    }
}

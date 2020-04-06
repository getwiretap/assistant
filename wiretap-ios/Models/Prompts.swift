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
            Prompt(
                displayText: "Good morning and welcome to Pizza Planet. My name is Nic, what can we get for you today?",
                variants: [
                    "Hello and welcome to Pizza Planet. My name is Nic, what can we get for you today?",
                    "Greetings and welcome to Pizza Planet. My name is Nic, what can we get for you today?",
                    "Good morning and welcome to Pizza Planet. My name is Nic, what can I get for you today?",
                ]
            )
        ]
    }
}

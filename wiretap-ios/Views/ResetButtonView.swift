//
//  ResetButtonView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct ResetButtonView: View {
    
    @EnvironmentObject var prompts: Prompts
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    func doNothing() -> Void {
        
    }
    
    var body: some View {
        let validedPrompts: [Prompt] = []
        let canReset = !validedPrompts.isEmpty
        
        return (
            Text("Reset prompts")
                .padding()
                .foregroundColor(canReset ? .white : Color.init(red: 0.980, green: 0.537, blue: 0.392))
        )
    }
}

struct ResetButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ResetButtonView()
    }
}

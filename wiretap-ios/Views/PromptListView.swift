//
//  PromptListView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct PromptListView: View {
    
    @EnvironmentObject var prompts: Prompts
    
    var body: some View {
        VStack {
            ForEach(prompts.prompts) { PromptView(prompt: $0) }
        }
    }
}

struct PromptListView_Previews: PreviewProvider {
    static var previews: some View {
        PromptListView()
            .environmentObject(SpeechRecognizer())
            .environmentObject(Prompts())
    }
}

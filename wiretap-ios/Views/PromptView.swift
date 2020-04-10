//
//  PromptView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI


let emptyProgress = [
    (0, 0, 0),
    (0, 0, 0),
    (0, 0, 0)
]


struct PromptView: View {

    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    var prompt: Prompt

    
    var body: some View {
        let looksValid = prompt.willProbablyBeValid || prompt.isValid
        let imageName = looksValid ? "checkmark.circle" : "questionmark.circle"
        
        print(UIDevice.current.identifierForVendor?.uuidString)
        
        return (
            
            HStack {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .padding(.trailing)
                Text(prompt.displayText)
                    .font(.custom("Baloo2-Medium", size: 28))
                Spacer()
                
            }
            .padding()
            .padding(.horizontal, 5)
            .cornerRadius(15)
            .onReceive(speechRecognizer.objectWillChange) { _ in
                self.validate()
            }
        )
    }
    
    func validate() {
        prompt.validate(self.speechRecognizer.transcription)
    }
}


struct PromptView_Previews: PreviewProvider {
    static var prompt = Prompt(
        displayText: "How can I help you today?",
        variants: []
    )
    
    static var previews: some View {
        PromptView(prompt: prompt)
            .previewLayout(.sizeThatFits)
            .environmentObject(Prompts())
            .environmentObject(SpeechRecognizer())
    }
}

//
//  PromptView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct PromptView: View {

    let prompt: Prompt
    
    @EnvironmentObject var speechRecognizer: SpeechRecognizer

    
    func getIcon() -> String {
        prompt.isValidated ? "checkmark.circle.fill" : "questionmark.circle.fill"
    }
    
    func getBackgroundColor() -> Color {
        prompt.isValidated ? Color.white : Color.init(red: 251/255, green: 156/255, blue: 124/255)
    }
    
    func getForegroundColor() -> Color {
        prompt.isValidated ? Color.init(red: 251/255, green: 156/255, blue: 124/255) : Color.white
    }
    
    var body: some View {
        HStack {
            Image(systemName: getIcon())
                .font(.largeTitle)
                .foregroundColor(getForegroundColor())
                .padding(.trailing)
            Text(prompt.displayText)
                .font(.custom("Baloo2-Medium", size: 28))
                .foregroundColor(getForegroundColor())
            Spacer()
        }
        .padding()
        .padding(.horizontal, 5)
        .background(getBackgroundColor())
        .cornerRadius(15)
        .onReceive(speechRecognizer.objectWillChange) { _ in
            self.prompt.validate(self.speechRecognizer.transcription)
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var prompt = Prompt(displayText: "How can I help you today?")
    
    static var previews: some View {
        PromptView(prompt: prompt)
            .previewLayout(.sizeThatFits)
    }
}

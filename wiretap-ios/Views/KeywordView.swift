//
//  KeywordView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct KeywordView: View {
    
    let keyword: String
    
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    var body: some View {
        let lastWord = String(speechRecognizer.transcription.split(separator: " ").last ?? "")
        let isLastWord = keyword == lastWord.normalized
        
        return Text(keyword)
            .foregroundColor(isLastWord ? .white : .black)
            .padding()
            .frame(width: 130, height: 30, alignment: .center)
    }
}

struct KeywordView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordView(keyword: "toto")
    }
}

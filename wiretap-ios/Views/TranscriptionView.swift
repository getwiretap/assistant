//
//  TranscriptionView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct TranscriptionView: View {
    
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    var body: some View {
        Text(speechRecognizer.transcription.formatedString)
    }
}

struct TranscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptionView()
            .environmentObject(SpeechRecognizer())
    }
}

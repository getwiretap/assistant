//
//  ContentView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    var body: some View {
        VStack {
            ZStack {
                BackgroundView()
                ContentView()
            }
        }
        .onAppear {
            self.speechRecognizer.requestPermission()
            self.speechRecognizer.startRecordingHandled()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(SpeechRecognizer())
            .environmentObject(Prompts())
    }
}

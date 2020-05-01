//
//  ContentView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    var body: some View {
        VStack {
            if authentication.uid != nil {
                AuthenticatedView(uid: authentication.uid!)
            } else {
                UserLoginView()
            }
        }
        .onAppear {
            self.speechRecognizer.requestPermission()
            self.speechRecognizer.startRecordingHandled()
            self.authentication.listenToChanges()
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(Authentication())
            .environmentObject(Cashiers())
            .environmentObject(Prompts())
            .environmentObject(SpeechRecognizer())
    }
}

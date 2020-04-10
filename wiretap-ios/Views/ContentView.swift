//
//  ContentView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: Session
    
    var body: some View {
        VStack {
            Spacer()
            Text(session.isConnected ? "connected" : "not-connected")
            Spacer()
            TranscriptionView()
        }
        .padding()
    }
    
    func isAuthenticated() -> Bool {
        session.uid != "null"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SpeechRecognizer())
            .environmentObject(Session())
    }
}

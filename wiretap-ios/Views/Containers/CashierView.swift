//
//  CashierView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-29.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI


struct CashierView: View {
    
    let cashier: Cashier
    
    @EnvironmentObject var ticket: Ticket
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                PromptListView(cashier: cashier)
                Spacer()
                CashierMenuView(cashier: cashier)
            }
                .padding(30)
        }
        .onDisappear {
            self.ticket.clearData()
            self.speechRecognizer.clearTranscription()
        }
    }
}

struct CashierView_Previews: PreviewProvider {
    static var previews: some View {
        CashierView(cashier: Cashier())
    }
}

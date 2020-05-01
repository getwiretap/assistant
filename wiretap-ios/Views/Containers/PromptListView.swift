//
//  CashierConnectedView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-22.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct PromptListView: View {
    
    let cashier: Cashier

    @EnvironmentObject var user: User
    @EnvironmentObject var device: Device
    @EnvironmentObject var prompts: Prompts
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @EnvironmentObject var ticket: Ticket
    
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(getVisiblePrompts()) { prompt in
                PromptView(prompt: prompt)
            }
            
            HStack {
                Spacer()
                Button(action: submitTicket) {
                    Group {
                        Text("next ticket")
                            .font(.custom("Inconsolata-Bold", size: 24))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 3)
                            .padding(.leading, 5)
                    }
                }
            }
                .foregroundColor(.white)
                .padding(10)
        }
        .onReceive(speechRecognizer.$transcription) { t in
            let vp = self.getVisiblePrompts()
            let ci = self.cashier.id
            
            self.ticket.publishTranscription(
                cashierId: ci,
                transcription: t,
                visiblePrompts: vp
            )
        }
    }
    
    func getVisiblePrompts() -> [Prompt] {
        let userPlan = user.data!.plan
        
        let userVisiblePromptIds = user.data!.visiblePromptIds
        let deviceVisiblePromptIds = device.data!.visiblePromptIds
        
        let visiblePromptIds = userPlan == "static" ? userVisiblePromptIds : deviceVisiblePromptIds
        
        let visiblePrompts = visiblePromptIds
            .map { prompts.prompts[$0] }
            .filter { $0 != nil }
            .map { $0! }
        
        return visiblePrompts
    }
    
    func submitTicket() {
        ticket.saveStatsToCashier(cashierId: cashier.id)
    }
}


struct CashierConnectedView_Previews: PreviewProvider {
    
    static var previews: some View {
        PromptListView(cashier: Cashier())
            .environmentObject(Cashiers())
            .environmentObject(Prompts())
            .environmentObject(SpeechRecognizer())
            .environmentObject(Ticket())
    }
}

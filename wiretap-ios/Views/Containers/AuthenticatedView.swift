//
//  ConnectedDeviceView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-19.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct AuthenticatedView: View {
    
    let uid: String
    
    @EnvironmentObject var user: User
    @EnvironmentObject var device: Device
    @EnvironmentObject var cashiers: Cashiers
    @EnvironmentObject var prompts: Prompts
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    
    @State var cashierId: String?
    
    
    var body: some View {

        let cashier = getActiveCashier()
        
        return (
            VStack {
                if cashier == nil {
                    CashierLoginView()
                } else {
                    CashierView(cashier: cashier!)
                }
            }
            .onAppear {
                self.user.subscribeToUser(uid: self.uid)
                self.device.subscribeToDevice()
                self.prompts.subscribeToPrompts(uid: self.uid)
                self.cashiers.subscribeToCashiers(uid: self.uid)
            }
            .onDisappear {
                self.user.unsubscribeFromUser()
                self.device.unsubscribeFromDevice()
                self.prompts.unsubscribeFromPrompts()
                self.cashiers.unsubscribeFromCashiers()
            }
            .onReceive(cashiers.$password) { cashier in
                let cashier = self.getActiveCashier()
                let cashierId = cashier?.id
                
                if self.cashierId != cashierId {
                    self.cashierId = cashierId
                    
                    self.device.updateDeviceCashier(
                        uid: self.uid,
                        cashierId: cashierId as Any
                    )
                }
            }
        )
    }
    
    func getActiveCashier() -> Cashier? {
        let cashierPassword = cashiers.password
        let activeCashier = cashiers.cashiers[cashierPassword]
        
        return activeCashier
    }
}


struct AuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedView(uid: "123")
            .environmentObject(User())
            .environmentObject(Prompts())
            .environmentObject(Cashiers())
            
            
    }
}

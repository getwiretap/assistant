//
//  CashierLoginView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-19.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct CashierLoginView: View {

    @EnvironmentObject var cashiers: Cashiers
    
    
    var body: some View {
        return (
            ZStack {
                BackgroundView()
                
                BottomLogoView()
                
                VStack(spacing: 30) {
                    PasswordView(
                        password: cashiers.password,
                        passwordLength: cashiers.passwordLength
                    )
                        .padding(.vertical, 80)
                    
                    KeypadView(createAppendDigit: cashiers.createAppendDigit)
                }
            }
        )
    }
    
    
}

struct CashierLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CashierLoginView()
            .environmentObject(Cashiers())
    }
}

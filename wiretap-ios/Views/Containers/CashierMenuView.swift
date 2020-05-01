//
//  CashierMenuView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-29.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct CashierMenuView: View {
    
    let buttonSize: CGFloat = 70
  
    let cashier: Cashier
    
    @EnvironmentObject var cashiers: Cashiers
    
    
    var body: some View {
        HStack(alignment: .bottom) {
            
            CashierStatsView(cashier: cashier)
            
            Spacer()
            
            Button(action: cashiers.signOut) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(.white)
                    .opacity(0.8)
                    .background(WiretapColors.brandMedium)
                    .cornerRadius(300)
            }
        }
    }
}

struct CashierMenuView_Previews: PreviewProvider {
    static var previews: some View {
        CashierMenuView(cashier: Cashier())
            .environmentObject(Cashiers())
    }
}

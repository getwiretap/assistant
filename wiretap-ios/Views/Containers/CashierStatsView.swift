//
//  CashierStatsView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct CashierStatsView: View {

    
    let cashier: Cashier

    
    var body: some View {
        let todayStats = cashier.todayStats
        
        let tickets = todayStats.tickets
        let confirmations = todayStats.confirmations
        let points = todayStats.points
        
        let averageConfirmations = Float(confirmations) / Float(tickets)
        let averageConfirmationsString = String(format: "%.1f", averageConfirmations)
        let confirmationsString = "\(confirmations) (\(averageConfirmationsString))"
        
        let averagePoints = Float(points) / Float(tickets)
        let averagePointsString = String(format: "%.1f", averagePoints)
        let pointsString = "\(points) (\(averagePointsString))"
        
        
        return (
            VStack(alignment: .leading, spacing: 0) {
                
                CashierStatItemView(
                    iconName: "person.fill",
                    text: cashier.displayName,
                    borderBottom: true
                )
                
                CashierStatItemView(
                    iconName: "sun.max.fill",
                    text: Date.getFullDate(),
                    borderBottom: true
                )
                
                CashierStatItemView(
                    iconName: "grid",
                    text: String(tickets),
                    borderBottom: true
                )
                
                CashierStatItemView(
                    iconName: "checkmark",
                    text: confirmationsString,
                    borderBottom: true
                )
                
                CashierStatItemView(
                    iconName: "sparkles",
                    text: pointsString,
                    borderBottom: false
                )
                
            }
                .font(.custom("Inconsolata-Bold", size: 24))
                .padding(20)
                .padding(.horizontal, 8)
                .frame(width: 350)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(WiretapColors.brandMedium)
                )
            
        )
    }
}


struct CashierStatItemView: View {
    
    let iconName: String
    let text: String
    let borderBottom: Bool
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .frame(width: 30, height: 30)
                Text(text)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
            
            if borderBottom {
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.15)
                    .padding(.vertical, 8)
            } else {
                EmptyView()
            }
        }
    }
}


struct CashierStatsView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                CashierStatsView(cashier: Cashier())
                    .padding(30)
                Spacer()
            }
        }
            .environmentObject(Cashiers())
    }
}

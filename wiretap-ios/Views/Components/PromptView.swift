//
//  PromptView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI



struct PromptView: View {
    
    let prompt: Prompt
    
    @EnvironmentObject var ticket: Ticket
    
    
    var body: some View {
        
        let promptId = prompt.id
        let promptConfirmations = ticket.validatedPrompts[promptId] ?? 0
        let isConfirmed = promptConfirmations > 0
        let textColor = isConfirmed ? WiretapColors.neutralDark : Color.white
        
        let pointsAsString = String(prompt.points)
        let pointOrPoints = pointsAsString == "1" ? "point" : "points"
        let pointsString = "\(pointsAsString) \(pointOrPoints)"

        let autonextString = prompt.autonext ? " + auto next ticket" : ""

        let pointsAndEffects = pointsString + autonextString
        
        
        return (
            VStack(alignment: .leading, spacing: 10) {
                Text(prompt.label)
                    .font(.custom("Lato-Bold", size: 30))
                    .foregroundColor(textColor)
                    
                HStack {
                    Text(pointsAndEffects)
                        .font(.custom("Inconsolata-Bold", size: 20))
                        .opacity(0.75)
                    
                    Spacer()
                    
                    if isConfirmed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.top, 2)
                    }
                }
            }
                .padding(20)
                .padding(.leading, 10)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(textColor)
                .background(ChatBubble(isRaised: isConfirmed))
        )
    }
}

struct PromptView_Previews: PreviewProvider {    
    static var previews: some View {
        PromptView(prompt: Prompt())
            .environmentObject(Ticket())
    }
}

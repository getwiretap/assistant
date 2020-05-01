//
//  ChatBubble.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-23.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI


struct ChatBubble: View {
    
    let cornerRadius: CGFloat = 20
    let isRaised: Bool

    var body: some View {
        Group {
            if isRaised {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .modifier(WithShadowModifier())
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(WiretapColors.brandMedium)
            }
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(isRaised: true)
    }
}

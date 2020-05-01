//
//  CardViewModifier.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-17.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

// FIXME: Rename file
struct WithShadowModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 3,
                x: 2,
                y: 2
            )
    }
}

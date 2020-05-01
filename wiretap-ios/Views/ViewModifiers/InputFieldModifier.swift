//
//  InputFieldModifier.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct InputFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Bold", size: 20))
            .foregroundColor(WiretapColors.neutralDark)
            .padding(10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(500)
    }
}

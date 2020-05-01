//
//  KeypadView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-11.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct KeypadView: View {
    
    var createAppendDigit: (Int) -> () -> Void
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                KeypadButtonView(digit: 1, action: createAppendDigit(1))
                KeypadButtonView(digit: 2, action: createAppendDigit(2))
                KeypadButtonView(digit: 3, action: createAppendDigit(3))

            }
            HStack(spacing: 0) {
                KeypadButtonView(digit: 4, action: createAppendDigit(4))
                KeypadButtonView(digit: 5, action: createAppendDigit(5))
                KeypadButtonView(digit: 6, action: createAppendDigit(6))

            }
            HStack(spacing: 0) {
                KeypadButtonView(digit: 7, action: createAppendDigit(7))
                KeypadButtonView(digit: 8, action: createAppendDigit(8))
                KeypadButtonView(digit: 9, action: createAppendDigit(9))
            }
            HStack(spacing: 0) {
                KeypadButtonView(digit: 0, action: createAppendDigit(0))
            }
        }
    }
}


struct KeypadButtonView: View {
    
    let buttonSize: CGFloat = 70
    let disabled: Bool = false
    
    let digit: Int
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            Text(String(digit))
                .font(.custom("Lato-Bold", size: 36))
                .frame(width: buttonSize, height: buttonSize)
                .foregroundColor(.white)
                .background(WiretapColors.brandMedium)
                .cornerRadius(300)
                .modifier(WithShadowModifier())
        }
            .fixedSize()
            .frame(width: buttonSize, height: buttonSize)
            .padding(10)
            .disabled(disabled)
    }
}

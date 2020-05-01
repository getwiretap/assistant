//
//  PasswordView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-17.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI


struct PasswordView: View {
    
    var password: String
    var passwordLength: Int
    
    var body: some View {
        HStack {
            ForEach((0 ..< passwordLength)) { index in
                PasswordCharacterView(
                    index: index,
                    password: self.password
                )
            }
        }
    }
}


struct PasswordCharacterView: View {
    
    var index: Int
    var password: String
    
    var body: some View {
        Image(systemName: "circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 14)
            .padding(.leading, getLeftPadding())
            .foregroundColor(.white)
            .opacity(getOpacity())
    }
    
    func getLeftPadding() -> CGFloat {
        if index == 0 {
            return 0
        }
        
        return index % 4 == 0 ? 30 : 5
    }
    
    func getOpacity() -> Double {
        password.count > index ? 1 : 0.3
    }
}


struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            PasswordView(password: "123", passwordLength: 12)
        }
    }
}

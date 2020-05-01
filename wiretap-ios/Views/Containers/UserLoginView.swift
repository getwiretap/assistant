//
//  SubmitPasswordView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-10.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI


struct UserLoginView: View {
    
    @EnvironmentObject var authentication: Authentication
    
    @State var email: String = ""
    @State var password: String = ""
    
    // Allows the text fields to be centered on screen
    let mirrorHeight: CGFloat = 70
    
    
    var body: some View {
        ZStack {
            
            BackgroundView()
            
            BottomLogoView()
            
            VStack {
                Spacer()
                    .frame(height: mirrorHeight)
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .modifier(InputFieldModifier())
                    
                SecureField("Password", text: $password)
                    .modifier(InputFieldModifier())
                
                Button(action: signIn) {
                    Text("Sign in")
                        .font(.custom("Lato-Bold", size: 24))
                        .foregroundColor(.white)
                        .frame(height: mirrorHeight)
                }
            }
        }
    }
    
    func signIn() {
        authentication.signIn(email: email, password: password)
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView()
            .environmentObject(Authentication())
    }
}

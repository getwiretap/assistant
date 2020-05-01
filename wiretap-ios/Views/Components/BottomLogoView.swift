//
//  BottomLogoView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct BottomLogoView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding(.bottom, 40)
                .opacity(0.5)
        }
    }
}

struct BottomLogoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            BottomLogoView()
        }
    }
}

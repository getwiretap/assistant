//
//  Background.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    
    let isWhite: Bool
    
    
    init(isWhite: Bool = false) {
        self.isWhite = isWhite
    }
    
    var body: some View {
        Color(getFill())
            .edgesIgnoringSafeArea(.all)
    }
    
    func getFill() -> UIColor {
        return isWhite
            ? UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            : UIColor(red: 99 / 256, green: 104 / 256, blue: 210 / 256, alpha: 1)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BackgroundView()
            BackgroundView(isWhite: true)
        }
    }
}

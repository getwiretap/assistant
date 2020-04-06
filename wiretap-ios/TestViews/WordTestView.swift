//
//  WordTestView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-03.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct WordTestView: View {
    var body: some View {
        Text(Words("SUsan!?!").formatedString)
    }
}

struct WordTestView_Previews: PreviewProvider {
    static var previews: some View {
        WordTestView()
    }
}

//
//  KeywordsLineView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct KeywordsLineView: View {
    
    let keywordsLine: [String]

    var body: some View {
        HStack {
            ForEach(keywordsLine, id: \.self) { keyword in
                KeywordView(keyword: keyword)
            }
        }
    }
}

struct KeywordsLineView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordsLineView(keywordsLine: ["toto", "lolo", "popo"])
    }
}

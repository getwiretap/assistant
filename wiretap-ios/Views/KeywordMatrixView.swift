//
//  KeywordMatrixView.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI

struct KeywordMatrixView: View {
    
    @EnvironmentObject var prompts: Prompts
    
    func getKeywordsMatrix() -> [[String]] {
        let keywords = prompts.getKeywords()
        
        var keywordsLine: [String] = []
        var keywordsMatrix: [[String]] = []
        
        for keyword in keywords {
            if keywordsLine.count == 5 {
                keywordsMatrix.append(keywordsLine)
                keywordsLine = []
            }
            
            keywordsLine.append(keyword)
        }
        
        keywordsMatrix.append(keywordsLine)
        
        return keywordsMatrix
    }
    
    var body: some View {
        return (
            VStack {
                ForEach(getKeywordsMatrix(), id: \.self) { keywordsLine in
                    KeywordsLineView(keywordsLine: keywordsLine)
                }
            }
            .padding()
            .cornerRadius(15)
            .border(Color.black, width: 1)
        )
    }
}

struct KeywordMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordMatrixView()
    }
}

//
//  StringMetric.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-26.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation


struct StringMetrics {
    
    let origin: String
    let target: String


    private func getDistance() -> Int {
        let originCount = origin.count
        let targetCount = target.count

        if origin == target {
            return 0
        }
        
        if originCount == 0 {
            return targetCount
        }
        
        if targetCount == 0 {
            return originCount
        }

        // The previous row of distances
        var v0 = [Int](repeating: 0, count: targetCount + 1)
        // Current row of distances.
        var v1 = [Int](repeating: 0, count: targetCount + 1)
        // Initialize v0.
        // Edit distance for empty self.
        for i in 0..<v0.count {
            v0[i] = i
        }

        for (i, selfCharacter) in origin.enumerated() {
            // Calculate v1 (current row distances) from previous row v0
            // Edit distance is delete (i + 1) chars from self to match empty t.
            v1[0] = i + 1

            // Use formula to fill rest of the row.
            for (j, targetCharacter) in target.enumerated() {
                let cost = selfCharacter == targetCharacter ? 0 : 1
                v1[j + 1] = Swift.min(
                    v1[j] + 1,
                    v0[j + 1] + 1,
                    v0[j] + cost
                )
            }

            // Copy current row to previous row for next iteration.
            for j in 0..<v0.count {
                v0[j] = v1[j]
            }
        }

        return v1[targetCount]
    }
    
    private func getRelativeDistance() -> Float {
       
        let distance = getDistance()
        
        let longestStringCount = max(origin.count, target.count)
        
        return Float(distance) / Float(longestStringCount)
    }
    
    
    func getSimilarity() -> Int {
        let similarityFloat = 1.0 - getRelativeDistance()
        let similarityPercentage = Int(100 * similarityFloat)
        
        return similarityPercentage
    }
}


extension String {
    func index(_ i: Int) -> String.Index {
        if i >= 0 {
            return self.index(self.startIndex, offsetBy: i)
        } else {
            return self.index(self.endIndex, offsetBy: i)
        }
    }
    
    subscript(i: Int) -> Character? {
        if i >= count || i < -count {
            return nil
        }
        
        return self[index(i)]
    }
    
    subscript(r: Range<Int>) -> String {
        return String(self[index(r.lowerBound)..<index(r.upperBound)])
    }
}

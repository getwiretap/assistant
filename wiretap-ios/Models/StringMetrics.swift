//
//  StringMetric.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-26.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation



extension String {
    var normalized: String {
        let words = self.split(separator: " ")
        let lowercasedWords = words.map { $0.lowercased() }
        let normalizedWords = lowercasedWords.map { $0.trimmingCharacters(in: .punctuationCharacters) }
        
        return normalizedWords.joined(separator: " ")
    }
}



class StringMetrics {
    
    let origin: String
    let target: String
    
    
    init(origin: String, target: String) {
        self.origin = origin.normalized
        self.target = target.normalized
    }

    
    public func distance() -> Double {
        return distanceJaroWinkler()
    }


    public func distanceDamerauLevenshtein() -> Int {
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

        var da: [Character: Int] = [:]

        var d = Array(repeating: Array(repeating: 0, count: targetCount + 2), count: originCount + 2)

        let maxdist = originCount + targetCount
        
        d[0][0] = maxdist
        
        for i in 1...originCount + 1 {
            d[i][0] = maxdist
            d[i][1] = i - 1
        }
        
        for j in 1...targetCount + 1 {
            d[0][j] = maxdist
            d[1][j] = j - 1
        }

        for i in 2...originCount + 1 {
            var db = 1

            for j in 2...targetCount + 1 {
                let k = da[target[j - 2]!] ?? 1
                let l = db

                var cost = 1
                if origin[i - 2] == target[j - 2] {
                    cost = 0
                    db = j
                }

                let substition = d[i - 1][j - 1] + cost
                let injection = d[i][j - 1] + 1
                let deletion = d[i - 1][j] + 1
                let selfIdx = i - k - 1
                let targetIdx = j - l - 1
                let transposition = d[k - 1][l - 1] + selfIdx + 1 + targetIdx

                d[i][j] = Swift.min(
                    substition,
                    injection,
                    deletion,
                    transposition
                )
            }

            da[origin[i - 2]!] = i
        }

        return d[originCount + 1][targetCount + 1]
    }


    public func distanceJaroWinkler() -> Double {
        var stringOne = origin
        var stringTwo = target
        
        if stringOne.count > stringTwo.count {
            stringTwo = origin
            stringOne = target
        }

        let stringOneCount = stringOne.count
        let stringTwoCount = stringTwo.count

        if stringOneCount == 0 && stringTwoCount == 0 {
            return 1.0
        }

        let matchingDistance = stringTwoCount / 2
        var matchingCharactersCount: Double = 0
        var transpositionsCount: Double = 0
        var previousPosition = -1

        // Count matching characters and transpositions.
        for (i, stringOneChar) in stringOne.enumerated() {
            for (j, stringTwoChar) in stringTwo.enumerated() {
                if max(0, i - matchingDistance)..<min(stringTwoCount, i + matchingDistance) ~= j {
                    if stringOneChar == stringTwoChar {
                        matchingCharactersCount += 1
                        if previousPosition != -1 && j < previousPosition {
                            transpositionsCount += 1
                        }
                        previousPosition = j
                        break
                    }
                }
            }
        }

        if matchingCharactersCount == 0.0 {
            return 0.0
        }

        // Count common prefix (up to a maximum of 4 characters)
        let commonPrefixCount = min(max(Double(origin.commonPrefix(with: target).count), 0), 4)

        let jaroSimilarity = (matchingCharactersCount / Double(stringOneCount) + matchingCharactersCount / Double(stringTwoCount) + (matchingCharactersCount - transpositionsCount) / matchingCharactersCount) / 3

        // Default is 0.1, should never exceed 0.25 (otherwise similarity score could exceed 1.0)
        let commonPrefixScalingFactor = 0.1

        return jaroSimilarity + commonPrefixCount * commonPrefixScalingFactor * (1 - jaroSimilarity)
    }

    public func distanceLevenshtein() -> Int {
        let origiCount = origin.count
        let targetCount = target.count

        if origin == target {
            return 0
        }
        
        if origiCount == 0 {
            return targetCount
        }
        
        if targetCount == 0 {
            return origiCount
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
    
    public func relativeLevenshtein() -> Double {
        
        let originCount = origin.count
        let targetCount = target.count
        let totalCount = originCount + targetCount
        
        let levenshteinDistance = distanceLevenshtein()
        
        let relativeDistance = Double(levenshteinDistance) / Double(totalCount)
        
        let score = 1.0 - relativeDistance
        
        return score
    }
    
    public func relativeDamerauLevenshtein() -> Double {
        
        let originCount = origin.count
        let targetCount = target.count
        let totalCount = originCount + targetCount
        
        let damerauLevenshteinDistance = distanceDamerauLevenshtein()
        
        let relativeDistance = Double(damerauLevenshteinDistance) / Double(totalCount)
        
        let score = 1.0 - relativeDistance
        
        return score
    }
    
    public func confidence() -> Int {

        let scores = [
            distance(),
            relativeLevenshtein(),
            relativeDamerauLevenshtein(),
        ]
        
        let totalScore = scores.reduce(0, +)
        let averageScore = totalScore / Double(scores.count)
        
        let confidencePercentage = Int(averageScore * 100)
        
        return confidencePercentage
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

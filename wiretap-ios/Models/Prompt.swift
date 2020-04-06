//
//  Prompt.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Foundation


class Prompt: Identifiable {
    
    let id: String = UUID().uuidString
    let displayText: String
    let variants: [Words]
    
    var similarityProgress: [SimilarityScores] = [(0, 0), (0, 0)]
    
    var isValid: Bool = false
    var willProbablyBeValid: Bool = false
    
    
    init(displayText: String, variants: [String]) {
        self.displayText = displayText
        self.variants = variants.map { Words($0) }
    }

    
    private func getIncompletePromptSimilarity(_ transcription: Words, wordsToRemove: Int) -> Int {
        
        var highestSimilarityScore: Int = 0
        
        variants.forEach { variant in
            let incompleteVariantText = variant.substring(dropLast: wordsToRemove)
            let transcriptionText = transcription.substring(keepLast: incompleteVariantText.count)
            
            let stringMetrics = StringMetrics(origin: incompleteVariantText, target: transcriptionText)
            let similarity = stringMetrics.getSimilarity()

            highestSimilarityScore = max(highestSimilarityScore, similarity)
        }
        
        return highestSimilarityScore
    }
    
    
    private func getSimilarityScores(_ transcription: Words) -> (SimilarityScores) {
        
        let fullSimilarity = getIncompletePromptSimilarity(transcription, wordsToRemove: 0)
        let minusOneSimilarity = getIncompletePromptSimilarity(transcription, wordsToRemove: 1)
        
        return (fullSimilarity, minusOneSimilarity)
    }
    
    
    func validate(_ transcription: Words) {
        let similarityScores = getSimilarityScores(transcription)
        
        similarityProgress.insert(similarityScores, at: 0)
        similarityProgress.removeLast()
        
        let (full, minusOne) = similarityScores
        let (_, prevMinusOne) = similarityProgress[1]
        
        if minusOne > 85 {
            willProbablyBeValid = true
        }
        
        if full > 85 && full >= prevMinusOne {
            isValid = true
        }
    }
}


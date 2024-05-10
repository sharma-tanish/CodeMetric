//
//  CodeScoreExtractor.swift
//  GenerativeAICompiler
//
//  Created by Abhiraj on 09/05/24.
//

import Foundation

func extractFirstThreeNumbers(from input: String) -> [Int] {
    // Regular expression to find numbers
    let regex = try! NSRegularExpression(pattern: "\\d+")
    let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

    // Convert the found matches into Integers
    let numbers = results.compactMap {
        Int((input as NSString).substring(with: $0.range))
    }

    // Return the first three numbers
    return Array(numbers.prefix(3))
}

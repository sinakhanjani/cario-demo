//
//  GoogleSearch.swift
//  Cario
//
//  Created by Teodik Abrami on 10/20/18.
//  Copyright © 2018 iPersianDeveloper. All rights reserved.
//

import Foundation

struct GoogleSearch: Decodable {
    let predictions: [Prediction]
    let status: String
}

struct Prediction: Decodable {
    let description, id: String
    let matchedSubstrings: [MatchedSubstring]
    let placeID, reference: String
    let structuredFormatting: StructuredFormatting
    let terms: [Term]
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case description, id
        case matchedSubstrings = "matched_substrings"
        case placeID = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
        case terms, types
    }
}

struct MatchedSubstring: Decodable {
    let length, offset: Int
}

struct StructuredFormatting: Decodable {
    let mainText: String
    let mainTextMatchedSubstrings: [MatchedSubstring]
    let secondaryText: String
    
    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
    }
}

struct Term: Decodable {
    let offset: Int
    let value: String
}


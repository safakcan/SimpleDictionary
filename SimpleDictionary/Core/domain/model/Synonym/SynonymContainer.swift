//
//  SynonymContainer.swift
//  SimpleDictionary
//
//  Created by Can Bas on 30.04.2023.
//

import Foundation

typealias SynonymContainer = [Synonym]

struct Synonym: Codable {

    let word: String
    let score: Int
}

extension Synonym: Identifiable {
    var id : String {
        UUID().uuidString
    }
}

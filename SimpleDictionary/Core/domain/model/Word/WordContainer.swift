//
//  WordContainer.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import Foundation

typealias WordContainer = [Word]

struct Word: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]
    let license: License?
    let sourceUrls: [String]?
    var synonyms: SynonymContainer?
}

struct License: Codable {
    let name: String
    let url: String
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
//    let synonyms, antonyms: [String]?
}

struct Definition: Codable {
    let definition: String
//    let synonyms, antonyms: [String]?
    let example: String?
}

struct Phonetic: Codable {
    let text: String
    let audio: String?
    let sourceURL: String?
    let license: License?

    enum CodingKeys: String, CodingKey {
        case text, audio
        case sourceURL = "sourceUrl"
        case license
    }
}

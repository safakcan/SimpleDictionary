//
//  DetailViewModel.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import Foundation

class DetailViewModel {
    var word: WordContainer
    var requestManager = RequestManager()
    private let wordFetcher: WordFetcher

    init(word: WordContainer, wordFetcher: WordFetcher) {
        self.word = word
        self.wordFetcher = wordFetcher

    }

    var title: String {
        return word.first?.word ?? ""
    }

    var phonetic: String {
        return word.first?.phonetic ?? ""
    }

    var synonyms: SynonymContainer {
        return word.first?.synonyms?.sorted {$0.score > $1.score} ?? []
    }


    var partOfSpeeches: [String] {
        var speeches = Set<String>()
        for word in word {
            for meaning in word.meanings {
                speeches.insert(meaning.partOfSpeech)
            }
        }
        return Array(speeches)
    }

    var definitionsBySpeech: [(speech: String, definitions: [Definition], index: Int)] {
        var result: [(speech: String, definitions: [Definition], index: Int)] = []
        var countDict: [String: Int] = [:]
        for word in word {
            for meaning in word.meanings {
                let partOfSpeech = meaning.partOfSpeech
                let definitions = meaning.definitions
                let count = countDict[partOfSpeech, default: 0] + 1
                countDict[partOfSpeech] = count
                result.append((partOfSpeech, definitions, count))
            }
        }
        return result
    }

    func fetchWord(_ word: String) async -> WordContainer {
        let wordContainer = await wordFetcher.fetchWordAndSynonyms(word)
        return wordContainer
    }

}

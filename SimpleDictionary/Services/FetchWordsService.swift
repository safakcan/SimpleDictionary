//
//  FetchWordsService.swift
//  SimpleDictionary
//
//  Created by Can Bas on 1.05.2023.
//

import Foundation

protocol WordFetcher {
    func fetchWordAndSynonyms(_ word: String) async -> WordContainer
}

struct FetchWordsService {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
      self.requestManager = requestManager
    }
}

extension FetchWordsService: WordFetcher {
    func fetchWordAndSynonyms(_ word: String) async -> WordContainer {

        async let fetchedWord: WordContainer = searchWord(word)
        async let fetchedSynonyms: SynonymContainer = synonymWord(word)

        do {
            var words = try await fetchedWord
            let synonyms = try await fetchedSynonyms

            if !words.isEmpty {
                words[0].synonyms = synonyms
            }

            return words
        } catch {
            print(error.localizedDescription)
            return []
        }
    }


    func searchWord(_ word: String) async throws -> WordContainer {
        let requestData = WordsRequest.getWordBy(search: word)

        do {
            let wordContainer: WordContainer = try await
            requestManager.perform(requestData)
            return wordContainer
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }

    func synonymWord(_ word: String) async throws -> SynonymContainer {
        let requestData = WordsRequest.getSynonym(word: word)

        do {
            let synonymContainer: SynonymContainer = try await
            requestManager.perform(requestData)
            return synonymContainer
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

}

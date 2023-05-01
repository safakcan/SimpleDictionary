//
//  SearchViewModel.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import Foundation

class SearchViewModel {
    private let recentSearchesKey = "recentSearches"
    private let wordFetcher: WordFetcher

    init( wordFetcher: WordFetcher) {
        self.wordFetcher = wordFetcher
    }

    var recentSearches: [String] {
        get {
            return UserDefaults.standard.array(forKey: recentSearchesKey) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: recentSearchesKey)
        }
    }

    func addSearchWord(_ word: String) {
        var searches = recentSearches
        if !searches.contains(word) {
            searches.insert(word, at: 0)
            // We only want to keep the last 5 searches
            if searches.count > 5 {
                searches.removeLast()
            }
            recentSearches = searches
        }
    }

    func fetchWord(_ word: String) async -> WordContainer {
        let wordContainer = await wordFetcher.fetchWordAndSynonyms(word)
        return wordContainer
    }

}

//
//  WordRequest.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import Foundation

enum WordsRequest: RequestProtocol {

    case getWordBy(search: String)
    case getSynonym(word: String)

    var host: String {
        switch self {
        case .getSynonym(word: _):
            return APIConstants.synonymHost
        default:
            return APIConstants.wordHost
        }
    }

    var path: String {
        switch self {
        case .getWordBy(_):
            return "/api/v2/entries/en"
        case .getSynonym(word: _):
            return "/words"
        }
    }
    
    var query: String {
        switch self {
        case .getWordBy(let search):
            return "/\(search)"
        case .getSynonym(word: _):
            return ""
        }
    }

    var urlParams: [String: String?] {
        switch self {
        case let .getSynonym(word):
            var params: [String: String] = [:]

            if !word.isEmpty {
                params["rel_syn"] = word
            }

            return params
        case .getWordBy(search: _):
            return ["":""]
        }
    }
    var requestType: RequestType {
        .GET
    }


}

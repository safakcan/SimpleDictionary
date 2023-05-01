//
//  SynonymRow.swift
//  SimpleDictionary
//
//  Created by Can Bas on 30.04.2023.
//

import SwiftUI

struct SynonymRow: View {
    let synonym: Synonym
    let onSynonymSelected: () -> Void

    var body: some View {
        Button(action: onSynonymSelected) {
            Text(synonym.word)
            .foregroundColor(Color.black)
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.black, lineWidth: 1))
        }
        .frame(height: 70)
    }
}

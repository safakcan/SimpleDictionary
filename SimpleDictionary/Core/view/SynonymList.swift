//
//  SynonymList.swift
//  SimpleDictionary
//
//  Created by Can Bas on 30.04.2023.
//

import SwiftUI

struct SynonymList: View {
    let synonyms: SynonymContainer
    let onSynonymSelected: (Synonym) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Synonym Words")
                .font(.title)
                .padding(.top, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 5) {
                    ForEach(self.synonyms.prefix(5)) { synonym in
                        SynonymRow(synonym: synonym, onSynonymSelected: { onSynonymSelected(synonym) })
                    }
                }
                .padding(.leading, 5)
            }
        }
        .frame(height: 150)
        .padding(.leading, 5)
        .padding(.top, 20)
    }
}

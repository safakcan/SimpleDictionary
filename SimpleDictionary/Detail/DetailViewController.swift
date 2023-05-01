//
//  DetailViewController.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import UIKit
import SwiftUI

class DetailViewController: UIViewController {

    @IBOutlet weak var synonymListContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    @IBOutlet weak var definitionTableView: UITableView!

    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()

        let synonymList = SynonymList(synonyms: viewModel.synonyms) { selectedSynonym in
            Task {
                do {
                    let newWord = await self.viewModel.fetchWord(selectedSynonym.word)
                    if let newWord = newWord.first {
                        DispatchQueue.main.async {
                            self.viewModel = DetailViewModel(word: [newWord], wordFetcher: FetchWordsService(requestManager: RequestManager()))
                            self.configureUI()
                            self.definitionTableView.reloadData()
                        }
                    }
                }
            }
        }
        configureBottomView(synonymList: synonymList)
        configureUI()
    }

    func configureTableView() {
        let nib = UINib(nibName: "DefinitionCell", bundle: nil)

        definitionTableView.register(nib, forCellReuseIdentifier: "DefinitionCell")
        definitionTableView.delegate = self
        definitionTableView.dataSource = self
    }

    func configureBottomView(synonymList: SynonymList) {
        let hostingController = UIHostingController(rootView: synonymList)
        addChild(hostingController)
        synonymListContainerView.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: synonymListContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: synonymListContainerView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: synonymListContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: synonymListContainerView.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

    func configureUI() {
        titleLabel.text = viewModel.title
        phoneticLabel.text = viewModel.phonetic
        partOfSpeechLabel.text = viewModel.partOfSpeeches.joined(separator: ", ")
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.definitionsBySpeech.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionCell", for: indexPath) as? DefinitionCell else { return UITableViewCell()}
        let (speech, definitions, count) = viewModel.definitionsBySpeech[indexPath.row]
        cell.titleLabel.text = "\(count) - \(speech.capitalized)"

        cell.definitionLabel.text = definitions.map { $0.definition }.joined(separator: "\n")
        return cell
    }

}

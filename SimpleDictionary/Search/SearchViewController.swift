//
//  ViewController.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentSearchesLabel: UILabel!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchForWord()
    }

    var searchViewModel = SearchViewModel(wordFetcher: FetchWordsService(requestManager: RequestManager()))

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        searchBar.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    private func searchForWord() {
        guard let word = searchBar.text, !word.isEmpty else { return }
        searchViewModel.addSearchWord(word)
        recentSearchesTableView.reloadData()

        Task.init {
            let wordContainer = await searchViewModel.fetchWord(word)
            let detailViewModel = DetailViewModel(word: wordContainer, wordFetcher: FetchWordsService(requestManager: RequestManager()))
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.viewModel = detailViewModel
            self.navigationController?.pushViewController(detailVC, animated: true)

        }
    }

    func configureTableView() {
        let nib = UINib(nibName: "RecentSearchCellTableViewCell", bundle: nil)
        recentSearchesTableView.register(nib, forCellReuseIdentifier: "RecentSearchCellTableViewCell")
        recentSearchesTableView.delegate = self
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.separatorStyle = .none
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomButtonConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomButtonConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForWord()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCellTableViewCell", for: indexPath) as? RecentSearchCellTableViewCell else {return UITableViewCell()}

        cell.wordLabel.text = searchViewModel.recentSearches[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = searchViewModel.recentSearches[indexPath.row]
        searchForWord()
    }
}


//
//  ViewController.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 24.02.21.
//

import UIKit
import Combine

// Searchview for finding repositories by name from GitHub API.
class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Data objects
    let viewModel = RepositorySearchViewModel()
    var data:[Repository] = []
    var saved:[Repository] = []
    var cancellables = Set<AnyCancellable>()
    var page = 1
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
                
        searchBar.delegate = self
        tableView.delegate = self
        observeViewModel()
        
    }
    
    // Observing viewmodel publisher.
    private func observeViewModel() {
        viewModel.repositoriesSubject
            .sink { (resultCompletion) in
            switch resultCompletion {
                case .failure(let error):
                    print(error.localizedDescription)
                default: break
            }
        } receiveValue: { (repositories) in
            self.data = repositories
            self.tableView.reloadData()
        }
            .store(in: &cancellables)
        viewModel.savedRepositories
            .sink { (resultCompletion) in
            switch resultCompletion {
                case .failure(let error):
                    print(error.localizedDescription)
                default: break
            }
        } receiveValue: { (repositories) in
            self.saved = repositories
            self.tableView.reloadData()
        }
            .store(in: &cancellables)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let repo = self.data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell")
        
        guard let correctCell = cell as? TableViewCell else {
            cell?.textLabel?.text = repo.full_name
            return cell!
        }
        
        correctCell.configure(with: repo, saved: isSaved(repo: repo))
        correctCell.repository = repo
        correctCell.saveActionBlock = (self.saveButtonAction(repository:))
        
        return correctCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.data.count >= 100 {
            if indexPath.row == self.data.count-1 {
                self.page += 1
                self.viewModel.searchRepository(by: self.searchText, at: self.page)
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Fetch data
        if !searchText.isEmpty {
            self.page = 1
            self.searchText = searchText
            viewModel.searchRepository(by: searchText, at: self.page)
        }
        
    }
    
    private func saveButtonAction(repository: Repository) -> Void {
        if isSaved(repo: repository) {
            self.viewModel.delete(repository)
        } else {
            self.viewModel.save(repository)
        }
    }
    
    private func isSaved(repo: Repository) -> Bool {
        
        return self.saved.contains { (repository) -> Bool in
            repository == repo
        }
    }
}

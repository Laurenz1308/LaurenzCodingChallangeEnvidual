//
//  SavedTableViewTableViewController.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 25.02.21.
//

import UIKit
import Combine

/// Saved repository table view. Displays all saved repositories in RealmDB.
class SavedTableViewTableViewController: UITableViewController {
    
    // Data objects
    let viewModel = RepositorySearchViewModel()
    var saved:[Repository] = []
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        observeViewModel()
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch()
    }

    // Observing viewmodel publisher.
    private func observeViewModel() {
        viewModel.savedRepositories
            .sink { (resultCompletion) in
            switch resultCompletion {
                case .failure(let error):
                    print(error.localizedDescription)
                default: break
            }
        } receiveValue: { (repositories) in
            print("\(repositories.count)")
            self.saved = repositories
            self.tableView.reloadData()
        }
            .store(in: &cancellables)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = self.saved[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell")
        
        guard let correctCell = cell as? TableViewCell else {
            cell?.textLabel?.text = repo.full_name
            return cell!
        }
        
        correctCell.configure(with: repo, saved: true)
        correctCell.repository = repo
        correctCell.saveActionBlock = (self.buttonAction(repository:))
        
        return correctCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.saved.count
    }
    
    private func buttonAction(repository: Repository) -> Void {
        self.viewModel.delete(repository)
    }

}

//
//  RepositorySearchViewModel.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 24.02.21.
//

import Foundation
import Combine
import Moya

final class RepositorySearchViewModel {
    
    let repositoryNetwork = RepositoryNetwork()
                    
    var repositoriesSubject = PassthroughSubject<[Repository], Error>()
    
    var savedRepositories = PassthroughSubject<[Repository], Error>()
    
    var cancellables: Set<AnyCancellable> = []
          
    // Initialize viewmodel by connecting publishers from network to own publishers.
    init() {
        repositoryNetwork.repositoriesSubject
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                default: break
                }
            } receiveValue: { (results) in
                self.repositoriesSubject.send(results)
            }
            .store(in: &cancellables)
        
        repositoryNetwork.savedRepositories
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                default: break
                }
            } receiveValue: { (results) in
                self.savedRepositories.send(results)
            }
            .store(in: &cancellables)
    }
    
    public func searchRepository(by name: String, at page: Int) {
                
        self.repositoryNetwork.getResults(for: name, at: page)
    }
    
    public func save(_ repo: Repository){
        self.repositoryNetwork.save(repository: repo)
    }
    
    public func delete(_ repo: Repository){
        self.repositoryNetwork.delete(repository: repo)
    }
    
    public func fetch() {
        self.repositoryNetwork.fetch()
    }
}


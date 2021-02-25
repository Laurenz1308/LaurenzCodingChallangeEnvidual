//
//  RepositoryNetwork.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 24.02.21.
//

import Foundation
import Moya
import Combine
import RealmSwift

final class RepositoryNetwork: ObservableObject {
    
    let provider = MoyaProvider<MoyaRequests>()
    let realm = try! Realm(configuration: .defaultConfiguration)
    
    var repositoriesSubject = PassthroughSubject<[Repository], Error>()
    var savedRepositories = PassthroughSubject<[Repository], Error>()
    
    var results: [Repository] = []
    var saved: [Repository] {
        var array:[Repository] = []
        for item in fetched {
            array.append(Repository(id: item.id, name: item.name, full_name: item.full_name, description: item.repositoryDescription, stargazers_count: item.stargazers_count, updated_at: item.updated_at))
        }
        return array
    }
    lazy var fetched: Results<RealmRepository> = self.realm.objects(RealmRepository.self)
    
    init() {
        fetch()
    }
    
    // Fetch data from GitHub API with Moya
    func getResults(for name: String, at page: Int) {
        self.provider.request(.repositories(name: name, page: page)) { [weak self] repsonse in
            guard let self = self else { return }
            
            switch repsonse {
            case .success(let result):
                DispatchQueue.main.async {
                    do {
                        if page == 1 {
                            self.results = []
                        }
                        let data = try result.map(RepositoryResults<Repository>.self).items
                        self.results.append(contentsOf: data)
                        self.repositoriesSubject.send(self.results)
                    } catch {
                        print(error.localizedDescription)
                        return
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.repositoriesSubject.send(completion: .failure(error))
                return
            }
        }
    }
    
    /// Saving a repository to RealmDB
    func save(repository: Repository){
        // Save repository to realm
        
        let realmRepo = RealmRepository(from: repository)
        
        do {
            try realm.write {
                realm.add(realmRepo)
                print(saved)
                self.savedRepositories.send(self.saved)
            }
        } catch {
            print("Ssaving failed")
        }
    }
    
    ///Delete a repository from RealmDB
    func delete(repository: Repository){
                
        do {
            try realm.write {
                realm.delete(fetched.filter("id=%@", repository.id))
                print("deleted")
                self.savedRepositories.send(self.saved)
            }
        } catch {
            print("Deleting failed")
        }
    }
    
    /// Fetching all repositorys saved in RealmDB
    func fetch() {
        let fetchedObjects = realm.objects(RealmRepository.self)
        
        if !fetchedObjects.isEmpty  {
            var result: [Repository] = []
            
            for element in fetchedObjects {
                let new = Repository(id: element.id,
                                     name: element.name,
                                     full_name: element.full_name,
                                     description: element.description,
                                     stargazers_count: element.stargazers_count,
                                     updated_at: element.updated_at)
                result.append(new)
            }
            
            self.savedRepositories.send(self.saved)
            
        }
    }
    
}

//
//  RepositoryRealm.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Laurenz Hill on 24.02.21.
//

import Foundation
import RealmSwift

/// Model to store a repository in RealmDB.
class RealmRepository: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var full_name: String = ""
    @objc dynamic var repositoryDescription: String?
    @objc dynamic var stargazers_count: Int = 0
    @objc dynamic var updated_at: String = ""
    
    override init() {
        
    }
    
    init(from repo: Repository) {
        self.id = repo.id
        self.name = repo.name
        self.full_name = repo.full_name
        self.repositoryDescription = repo.description
        self.stargazers_count = repo.stargazers_count
        self.updated_at = repo.updated_at
    }
    
}

//
//  Repository.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 24.02.21.
//

import Foundation

/// Struct of a repository from GitHub Api
struct Repository: Codable, Equatable {
    
    let id:Int
    let name: String
    let full_name: String
    let description: String?
    let stargazers_count: Int
    let updated_at: String
    
}

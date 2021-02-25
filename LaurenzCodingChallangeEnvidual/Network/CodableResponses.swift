//
//  CodableResponses.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 24.02.21.
//

import Foundation

struct RepositoryResults<T: Codable>: Codable {
    let items: [T]
}

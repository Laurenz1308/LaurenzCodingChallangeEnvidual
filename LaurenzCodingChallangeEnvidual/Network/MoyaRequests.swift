//
//  RepositoryMoya.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Lori Hill on 24.02.21.
//

import Moya
import Foundation


public enum MoyaRequests {
    
    case repositories(name: String, page: Int)
    
}

extension MoyaRequests: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com/search")!
    }
    
    public var path: String {
        switch self {
        case .repositories:
            return "/repositories"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .repositories:
            return .get
        }
    }
    
    public var sampleData: Data {
        Data()
    }
    
    public var task: Task {
        
        switch self {
        case .repositories(let name, let page):
            return .requestParameters(parameters:
                                        ["q":"\(name) in:name,description",
                                         "page":"\(page)",
                                         "per_page": "100"],
                                      encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}

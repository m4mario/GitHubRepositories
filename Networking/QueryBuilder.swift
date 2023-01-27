//
//  File.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/25/23.
//

import Foundation

protocol QueryBuilder {
    static func initialRequest() -> URLRequest
    static func moreRequest(after cursor: String) -> URLRequest
}

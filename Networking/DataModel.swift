//
//  Model.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/27/23.
//

import Foundation

struct GitHubGraphQLResponse: Decodable {
    var data: DataClass?
}

struct DataClass: Decodable {
    var search: SearchResult
}

struct SearchResult: Decodable {
    var repositoryCount: Int
    var pageInfo: PageInfo
    var edges: [Edge]
}

struct PageInfo: Decodable {
    var startCursor: String
    var endCursor: String
    var hasNextPage: Bool
    var hasPreviousPage: Bool
}

struct Edge: Decodable {
    var node: EdgeNode?
    var cursor: String?
}

struct EdgeNode: Decodable {
    var name: String?
    var description: String?
    var url: String?
    var openGraphImageUrl: String?
    var primaryLanguage: PrimaryLanguage?
    var owner: Owner?
}

struct PrimaryLanguage: Decodable {
    var name: String?
}

struct Owner: Decodable {
    var login: String?
    var avatarUrl: String?
}


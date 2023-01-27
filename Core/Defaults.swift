//
//  Defaults.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import Foundation

// Should be of type RepositoryPresenter
typealias DefaultRepositoryPresenter = MainPresenter

// Should be of type QueryBuilder
typealias DefaultQueryBuilder = GraphQLQueryBuilder

enum Defaults {
    static let pageSize: Int = 20
    static let maxRecords: Int = 1000
}

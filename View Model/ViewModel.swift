//
//  Repository.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/25/23.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    var totalCount = 1000
    var startIndex = 0
    var endIndex = 0
    var repositoryCellData: [RepositoryCellData] = []
    
    var currentCount: Int {
        repositoryCellData.count
    }
}

@MainActor
final class RepositoryCellData: ObservableObject {
    @Published var name: String?
    @Published var imageURL: String?
    @Published var isLoadingComplete: Bool = false
    let rowIndex: Int
    var repositoryDetailData: RepositoryDetailData = RepositoryDetailData()
    
    init(rowIndex: Int) {
        self.rowIndex = rowIndex
    }
}

@MainActor
final class RepositoryDetailData: ObservableObject {
    @Published var name: String?
    @Published var imageURL: String?
}

//
//  Repository.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/25/23.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    var totalCount = 0 {
        didSet {
            totalCount = min(totalCount, Defaults.maxRecords)
        }
    }
    var endIndex = -1
    var RepositoryItemData: [RepositoryItemData] = []
    var loadingState: LoadingState = .loading
    
    var currentCount: Int {
        RepositoryItemData.count
    }
}

@MainActor
final class RepositoryItemData: ObservableObject {
    @Published var name: String?
    @Published var imageURL: String?
    @Published var description: String?
    @Published var language: String?
    @Published var detailImageURL: String?
    @Published var authorLogin: String?
    @Published var isLoadingComplete: Bool = false
    let rowIndex: Int
    
    init(rowIndex: Int) {
        self.rowIndex = rowIndex
    }
    
    init(rowIndex: Int, name: String?, imageURL: String? = nil, description: String?, language: String?, detailImageURL: String? = nil, authorLogin: String? = nil, isLoadingComplete: Bool) {
        self.rowIndex = rowIndex
        self.name = name
        self.imageURL = imageURL
        self.description = description
        self.language = language
        self.detailImageURL = detailImageURL
        self.authorLogin = authorLogin
        self.isLoadingComplete = isLoadingComplete
    }
}

enum LoadingState {
    case loading
    case failed(Error)
    case loadingComplete
}

//
//  File.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/27/23.
//

import Foundation

enum DataMapper {
    @MainActor
    static func map(dataModel: GitHubGraphQLResponse, to viewModel: ViewModel) {
        print("RepositoryCount \(dataModel.data?.search.repositoryCount ?? -45)")
        viewModel.totalCount = dataModel.data?.search.repositoryCount ?? 0
        let edges = dataModel.data?.search.edges
        var index = viewModel.endIndex
        for edge in edges ?? [] {
            let node = edge.node
            index += 1
            let itemData = itemData(for: index, viewModel: viewModel)
            itemData.name = node?.name
            itemData.imageURL = node?.owner?.avatarUrl
            itemData.description = node?.description
            itemData.language = node?.primaryLanguage?.name
            itemData.detailImageURL = node?.openGraphImageUrl
            itemData.authorLogin = node?.owner?.login
            itemData.isLoadingComplete = true
        }
        viewModel.endIndex = index
    }
    
    @MainActor
    static func itemData(for index: Int, viewModel: ViewModel) -> RepositoryItemData {
        if viewModel.currentCount > index { return viewModel.RepositoryItemData[index] }
        let newitemData = RepositoryItemData(rowIndex: index)
        viewModel.RepositoryItemData.append(newitemData)
        return newitemData
    }
    
    static func lastCursor(from dataModel: GitHubGraphQLResponse) -> String? {
        return dataModel.data?.search.pageInfo.endCursor
    }
}

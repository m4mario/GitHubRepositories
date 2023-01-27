//
//  File.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/27/23.
//

import Foundation


actor ModelInteractor {
    var  lastCursor: String?
    
    func fetchInitialData(into viewModel: ViewModel) async throws  {
        let request = DefaultQueryBuilder.initialRequest()
        try await fetchData(into: viewModel, with: request)
    }
    
    func fetchMoreData(into viewModel: ViewModel) async throws  {
        guard let lastCursor else {
            throw GitHubError.request
        }
        
        let request = DefaultQueryBuilder.moreRequest(after: lastCursor)
        try await fetchData(into: viewModel, with: request)
    }
    
    func mapData(from dataModel: GitHubGraphQLResponse?, into viewModel: ViewModel) async {
        guard let dataModel else { return }
        lastCursor = DataMapper.lastCursor(from: dataModel)
        await DataMapper.map(dataModel: dataModel, to: viewModel)
    }
}

private extension ModelInteractor {
    func fetchData(into viewModel: ViewModel, with request: URLRequest) async throws {
        var dataModel: GitHubGraphQLResponse? = nil
        dataModel = try? await sharedDataDetcher.fetchRepositories(for: request)
        
        guard dataModel?.data != nil else {
            throw GitHubError.network
        }
        await mapData(from: dataModel, into: viewModel)
    }
    
    @MainActor
    func setError(_ error: Error, on viewModel: ViewModel) throws {
        viewModel.loadingState = .failed(error)
        throw error
    }
}

//
//  File.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import Foundation

protocol RepositoryPresenter {
    var viewModel: ViewModel { get }
    func cellData(for indexPath: IndexPath) async -> RepositoryCellData
    func prefetch(for indexPaths: [IndexPath])
}

@MainActor
final class MainPresenter: RepositoryPresenter {
    let viewModel = ViewModel()
    
    
    func cellData(for indexPath: IndexPath) -> RepositoryCellData {
        let index = indexPath.row
        if viewModel.currentCount > index {
            return viewModel.repositoryCellData[index]
        }
        populateEmptyData(uptill: index)
//        print("populated Empty Data uptill \(index), current count \(viewModel.currentCount)")
        return viewModel.repositoryCellData[index]
    }
    
    nonisolated func prefetch(for indexPaths: [IndexPath]) {
        guard let maxIndex = (indexPaths.map { $0.row }).max() else { return }
//        print("max index : \(maxIndex)")
        Task {
            guard await viewModel.currentCount < maxIndex else { return }
            print("populateEmptyData for max index : \(maxIndex)")
            await populateEmptyData(uptill: maxIndex)
        }
    }
}

private extension MainPresenter {
    func populateEmptyData(uptill index: Int) {
        let totalRepoCountNeeded = totalItemCount(for: index)
//        print("totalRepoCountNeeded \(totalRepoCountNeeded)")
        var additionalRepos: [RepositoryCellData] = []
        for i in viewModel.currentCount..<totalRepoCountNeeded {
            additionalRepos.append(RepositoryCellData(rowIndex: i))
        }
        viewModel.repositoryCellData.append(contentsOf: additionalRepos)
    }
    
    func totalItemCount(for index: Int) -> Int {
//        print("totalItemCount for \(index)")
        var total = 0
        var pageCount = 0
        repeat {
            pageCount = pageCount + 1
            total = pageCount * Defaults.pageSize
        } while total < index
        return total + 1
    }
}

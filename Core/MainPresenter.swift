//
//  File.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import Foundation

protocol DataUpdateReceiver: AnyObject {
    @MainActor func onUpdate()
}

protocol RepositoryPresenter {
    var viewModel: ViewModel { get }
    func cellData(for indexPath: IndexPath) async -> RepositoryItemData
    func prefetch(for indexPaths: [IndexPath])
    func loadData()
    func set(dataUpdateReceiver: DataUpdateReceiver)
}

@MainActor
final class MainPresenter: RepositoryPresenter {
    
    let viewModel = ViewModel()
    let modelInteractor = ModelInteractor()
    var dataUpdateReceiver: DataUpdateReceiver?
    
    nonisolated func loadData() {
        Task(priority: .userInitiated) {
            do {
                try await modelInteractor.fetchInitialData(into: viewModel)
            }
            catch {
                Task {
                    await initialLoadFailure(error: error)
                }
            }
            Task {
                await initialLoadSuccess()
            }
        }
    }
    
    nonisolated func set(dataUpdateReceiver: DataUpdateReceiver) {
        Task {
            await setdataUpdateReceiver(to: dataUpdateReceiver)
        }
    }

    func cellData(for indexPath: IndexPath) -> RepositoryItemData {
        let index = indexPath.row
        if viewModel.currentCount > index {
            return viewModel.RepositoryItemData[index]
        }
        populateEmptyData(uptill: index)
        return viewModel.RepositoryItemData[index]
    }
    
    nonisolated func prefetch(for indexPaths: [IndexPath]) {
        guard let maxIndex = (indexPaths.map { $0.row }).max() else { return }
        Task {
            guard await viewModel.currentCount < maxIndex else { return }
            await populateEmptyData(uptill: maxIndex)
        }
    }
}

private extension MainPresenter {
    func populateEmptyData(uptill index: Int) {
        let totalRepoCountNeeded = totalItemCount(for: index)
        var additionalRepos: [RepositoryItemData] = []
        for i in viewModel.currentCount..<totalRepoCountNeeded {
            additionalRepos.append(RepositoryItemData(rowIndex: i))
        }
        viewModel.RepositoryItemData.append(contentsOf: additionalRepos)
        loadMoreData()
    }
    
    func loadMoreData() {
        Task(priority: .userInitiated) {
            do {
                try await modelInteractor.fetchMoreData(into: viewModel)
            }
            catch {
                initialLoadFailure(error: error)
            }
        }
    }

    func totalItemCount(for index: Int) -> Int {
        var total = 0
        var pageCount = 0
        repeat {
            pageCount = pageCount + 1
            total = pageCount * Defaults.pageSize
        } while total < index
        return total + 1
    }
    
     func setdataUpdateReceiver(to dataUpdateReceiver: DataUpdateReceiver) {
        self.dataUpdateReceiver = dataUpdateReceiver
    }
    
    func initialLoadSuccess() {
        viewModel.loadingState = .loadingComplete
        dataUpdateReceiver?.onUpdate()
    }
    
    func initialLoadFailure(error: Error) {
        viewModel.loadingState = .failed(error)
        dataUpdateReceiver?.onUpdate()
    }

}

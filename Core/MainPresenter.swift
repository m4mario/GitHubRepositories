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
//    func set(onUpdate: @escaping () -> Void)
}

@MainActor
final class MainPresenter: RepositoryPresenter {
    nonisolated func set(dataUpdateReceiver: DataUpdateReceiver) {
        Task {
            await setdataUpdateReceiver(to: dataUpdateReceiver)
        }
    }
    
//    nonisolated func set(onUpdate: @escaping () -> Void) {
//        Task {
//            await setOnUpdate(to: onUpdate)
//        }
//    }
    
    let viewModel = ViewModel()
    let modelInteractor = ModelInteractor()
//    var onUpdate: (() -> Void)?
    var dataUpdateReceiver: DataUpdateReceiver?
    
    nonisolated func loadData() {
        Task(priority: .userInitiated) {
            do {
                try await modelInteractor.fetchInitialData(into: viewModel)
            }
            catch {
                print("Error: \(error)")
            }
            Task {
                await dataUpdateReceiver?.onUpdate()
            }
        }
    }
   
//    private func setOnUpdate(to onUpdate: @escaping () -> Void) {
//        self.onUpdate = onUpdate
//    }
    
    private func setdataUpdateReceiver(to dataUpdateReceiver: DataUpdateReceiver) {
        self.dataUpdateReceiver = dataUpdateReceiver
    }

    
    func cellData(for indexPath: IndexPath) -> RepositoryItemData {
        let index = indexPath.row
        if viewModel.currentCount > index {
            return viewModel.RepositoryItemData[index]
        }
        populateEmptyData(uptill: index)
//        print("populated Empty Data uptill \(index), current count \(viewModel.currentCount)")
        return viewModel.RepositoryItemData[index]
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
                print("Error: \(error)")
            }
//            Task {
//                dataUpdateReceiver?.onUpdate()
//            }
        }
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

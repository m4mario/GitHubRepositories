//
//  MasterViewController.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import UIKit
import SwiftUI

class MasterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let presenter: RepositoryPresenter = DefaultRepositoryPresenter()
    
    var viewModel: ViewModel {
        presenter.viewModel
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.set(dataUpdateReceiver: self)
        presenter.loadData()
        setTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedRow()
    }
}


// MARK: - Table view data source
extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.repoCell, for: indexPath)
        
        Task {
            let cellData = await presenter.cellData(for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration {
                CellView(data: cellData)
            }
        }
        return cell
    }
}


// MARK: - Table view delegate
extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.currentCount > indexPath.row else {
            deselectSelectedRow()
            return
        }
        let data = viewModel.RepositoryItemData[indexPath.row]
        let detailView = DetailView(data: data)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}


 //MARK: - Table view Prefetching delegate
extension MasterViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      presenter.prefetch(for: indexPaths)
  }
}


// MARK: - Data Update Receiver
extension MasterViewController: DataUpdateReceiver {
    @MainActor func onUpdate() {
        setTitle()
        tableView.reloadData()
    }
}


// MARK: - Private Functions
private extension MasterViewController {
    enum CellIdentifiers {
      static let repoCell = "repoCell"
    }

    func deselectSelectedRow() {
        guard let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setTitle() {
        switch viewModel.loadingState {
        case .loading:
            self.title = "Loading Repositories..."
        case .failed(_):
            self.title = "Loading Failed"
        case .loadingComplete:
            self.title = "GitHub Repositories"
        }
    }
}

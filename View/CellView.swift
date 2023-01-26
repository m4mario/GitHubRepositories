//
//  SwiftUIView.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import SwiftUI

struct CellView: View {
    @ObservedObject var data: RepositoryCellData
    
    var body: some View {
        VStack {
            Text("\(data.rowIndex) Repo Data")
//            Text("Repo Data")

        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(data: RepositoryCellData(rowIndex: 0))
//        CellView()
    }
}

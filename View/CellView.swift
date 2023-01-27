//
//  SwiftUIView.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import SwiftUI

struct CellView: View {
    @ObservedObject var data: RepositoryItemData
    
    var body: some View {
        HStack {
            if let imageURL = data.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }  else {
                Circle()
                    .foregroundColor(.secondary)
                    .frame(width: 50, height: 50)
            }
            
            if data.isLoadingComplete {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(data.name ?? "No Name")")
                    Text("\(data.description ?? "")").foregroundColor(.secondary).font(.footnote)
                    if let language = data.language {
                        HStack {
                            Text("Language: ").foregroundColor(.secondary)
                            Text("\(language)")
                        }.font(.body)
                    }
                }
            } else {
                Text("Loading...")
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(data: RepositoryItemData(rowIndex: 0,
                                          name: "My Repo",
                                          imageURL: "https://hws.dev/paul.jpg",
                                          description: "It Just Worls",
                                          language: "Swift",
                                          isLoadingComplete: true))
        
    }
}

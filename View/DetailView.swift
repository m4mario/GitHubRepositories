//
//  DetailView.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var data: RepositoryItemData

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                if let imageURL = data.detailImageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: 1000, maxHeight: 200)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 3.0, x: 2.0, y: 2.0)
                }
                Text("\(data.name ?? "No Name")").font(.title.bold())
                    .padding(.vertical)
                Text("\(data.description ?? "")")
                    .padding(.bottom)
                
                if let authorLogin = data.authorLogin {
                    HStack {
                        Text("author: ").foregroundColor(.secondary)
                        Text("\(authorLogin)")
                    }
                    .font(.body)
                    .padding(.bottom)
                }
                
                if let language = data.language {
                    HStack {
                        Text("language: ").foregroundColor(.secondary)
                        Text("\(language)")
                    }
                    .font(.body)
                    .padding(.bottom)
                }

                
                
            }
            .padding()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(data: RepositoryItemData(rowIndex: 0,
                                          name: "My Repo",
                                          imageURL: "https://hws.dev/paul.jpg",
                                          description: "It Just Worls",
                                          language: "Swift",
                                          isLoadingComplete: true))

    }
}

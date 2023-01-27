//
//  GraphQLFetcher.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/25/23.
//

import Foundation

let sharedDataDetcher = DataFetcher()

final class DataFetcher {
    func fetchRepositories(for request: URLRequest) async throws -> GitHubGraphQLResponse {
        let response = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let jsonData = response.0
        
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print("Printing JSON Data")
            print(String(decoding: jsonData, as: UTF8.self))
        }
        
        let model = try jsonDecoder.decode(GitHubGraphQLResponse.self, from: jsonData)
        return model
    }
    
    func fetchRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
        let request = GraphQLQueryBuilder.initialRequest()
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }
//            do {
//                let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                if let nodes = responseJSON?["data"]?["search"]?["nodes"] as? [[String: Any]] {
//                    let repositories = nodes.compactMap { node in
//                        Repository(name: node["name"] as? String, url: node["url"] as? String)
//                    }
//                    completion(.success(repositories))
//                } else {
//                    completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
//                }
//            } catch {
//                completion(.failure(error))
//            }
        })
        task.resume()
    }
}


//static let query = """
//    query {
//        search(query: "is:public", type: REPOSITORY, last: 20, before: "Y3Vyc29yOjIx") {
//          repositoryCount
//          pageInfo {
//            endCursor
//            startCursor
//            hasNextPage
//            hasPreviousPage
//          }
//          edges {
//            node {
//              ... on Repository {
//                name
//                description
//                url
//                languages
//                owner {
//                    login
//                    avatarUrl
//                }
//              }
//            }
//        cursor
//          }
//        }
//    }
//"""

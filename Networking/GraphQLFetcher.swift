//
//  GraphQLFetcher.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/25/23.
//

import Foundation

class GraphQLFetcher {
    func fetchRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
        let request = GraphQLQueryBuilder.request()
        
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

enum GraphQLQueryBuilder: QueryBuilder {
    static let url = URL(string: "https://api.github.com/graphql")!
//    static let url = URL(string: "https://api.github.com/repositories")!
    
    static let query = """
    query {
        search(query: "is:public", type: REPOSITORY, last: 20, before: "Y3Vyc29yOjIx") {
          repositoryCount
          pageInfo {
            endCursor
            startCursor
            hasNextPage
            hasPreviousPage
          }
          edges {
            node {
              ... on Repository {
                name
                description
                url
                languages
                owner {
                    login
                    avatarUrl
                }
              }
            }
        cursor
          }
        }
    }
    """

    static func request() -> URLRequest {
        let json: [String: Any] = ["query": query]
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}


//static let query = """
//query {
//  search(query: "is:public", type: REPOSITORY, first: 20) {
//      repositoryCount
//      pageInfo {
//        endCursor
//        startCursor
//        hasNextPage
//        hasPreviousPage
//      }
//      edges {
//        node {
//          ... on Repository {
//            name
//            description
//            url
//            owner {
//                login
//                avatarUrl
//            }
//          }
//        }
//    cursor
//      }
//    }
//}
//"""

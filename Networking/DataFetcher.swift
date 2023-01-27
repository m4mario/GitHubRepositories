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
  
    //Print json for debugging if needed.
    /*
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print("Printing JSON Data")
            print(String(decoding: jsonData, as: UTF8.self))
        }
     */
        
        let model = try jsonDecoder.decode(GitHubGraphQLResponse.self, from: jsonData)
        return model
    }
}

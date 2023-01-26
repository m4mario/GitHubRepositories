//
//  File.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/25/23.
//

import Foundation




struct Payload: Codable {
    var variables: String = "{}"
    var query: String
}

// MARK: - GitHubGraphQLResponse
struct GitHubGraphQLResponse: Codable {
    var data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var repository: Repository?
}

// MARK: - Repository
struct Repository: Codable {
    var stargazerCount: Int?
    var nameWithOwner, name: String?
    var url: String?
    var releases: Releases?
    var refs: Refs?
}

// MARK: - Refs
struct Refs: Codable {
    var edges: [Edge]?
}

// MARK: - Edge
struct Edge: Codable {
    var node: EdgeNode?
}

// MARK: - EdgeNode
struct EdgeNode: Codable {
    var name: String?
    var target: Target?
}

// MARK: - Target
struct Target: Codable {
    var committedDate: Date?
    let tagger: Tagger?
}

// MARK: - Tagger

struct Tagger: Codable {
    let date: Date?
}

// MARK: - Releases
struct Releases: Codable {
    var nodes: [NodeElement]?
}

// MARK: - NodeElement
struct NodeElement: Codable {
    var isDraft, isLatest, isPrerelease: Bool?
    var createdAt: Date?
    var tagName: String?
}


func querySpecificRepositoryWithGraphQLQuery() async throws -> GitHubGraphQLResponse {
    let username = "m4mario"
    let pat = "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"
    let base64EncodedCredentials = "\(username):\(pat)".data(using: .utf8)!.base64EncodedString()
    
    var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // `Authorization` header required for GitHub GraphQL API
    request.addValue("Basic \(base64EncodedCredentials)", forHTTPHeaderField: "Authorization")
    
    let query =
                """
                {
                  repository(owner: "MarcoEidinger", name: "SwiftPlantUML") {
                    stargazerCount
                    nameWithOwner
                    name
                    url
                    releases(orderBy: {direction: ASC, field: CREATED_AT}, last: 2) {
                      nodes {
                        isDraft
                        isLatest
                        isPrerelease
                        createdAt
                        tagName
                      }
                    }
                    refs(
                      refPrefix: "refs/tags/"
                      last: 2
                      orderBy: {field: TAG_COMMIT_DATE, direction: ASC}
                    ) {
                      edges {
                        node {
                          name
                          target {
                            ... on Commit {
                              committedDate
                            }
                            ... on Tag {
                              tagger {
                                date
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
                """
    
    let payload = Payload(query: query)
    let postData = try! JSONEncoder().encode(payload)
    request.httpBody = postData
    
    let response = try await URLSession.shared.data(for: request)
    
    // GitHub returns dates according to the ISO 8601 standard so let's use the appropiate stragegy. Otherwise the decoding will fail and an error gets thrown
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601
    
    let jsonData = response.0
    
    // Decode to the generated types by quicktype.io
    let gitHubGraphQLResponse = try jsonDecoder.decode(GitHubGraphQLResponse.self, from: jsonData)
    
    if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
        print("Printing JSON Data")
        print(String(decoding: jsonData, as: UTF8.self))
    }
        
        return gitHubGraphQLResponse
}



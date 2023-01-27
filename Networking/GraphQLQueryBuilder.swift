//
//  GraphQLQueryBuilder.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/27/23.
//

import Foundation

enum GraphQLQueryBuilder: QueryBuilder {
    static func moreRequest(after cursor: String) -> URLRequest {
        let json: [String: Any] = ["query": moreQuery(after: cursor)]
        return requestWith(jsonDictionary: json)
    }
    
    static func initialRequest() -> URLRequest {
        let json: [String: Any] = ["query": initialQuery]
        return requestWith(jsonDictionary: json)
    }
}

private extension GraphQLQueryBuilder {
    static let url = URL(string: "https://api.github.com/graphql")!
    static let token = "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"
    
    static func requestWith(jsonDictionary: [String: Any]) -> URLRequest {
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDictionary)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private static let initialQuery = """
    query {
            search(query: "is:public", type: REPOSITORY, first: 20) {
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
                    openGraphImageUrl
                    primaryLanguage {
                      name
                    }
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
    
    private static func moreQuery(after cursor: String) -> String {
        """
        query {
                search(query: "is:public", type: REPOSITORY, first: 20, after: "\(cursor)") {
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
                        openGraphImageUrl
                        primaryLanguage {
                          name
                        }
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
    }
}

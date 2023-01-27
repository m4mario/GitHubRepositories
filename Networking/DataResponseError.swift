//
//  DataResponseError.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/27/23.
//

import Foundation

enum GitHubError: Error {
  case network
  case decoding
  case request
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data."
    case .decoding:
      return "An error occurred while decoding data."
    case .request:
      return "An error occurred while sending request."
    }
  }
}

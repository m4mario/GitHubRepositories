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
  
  var localizedDescription: String {
    switch self {
    case .network:
      return "Error fetching Records. Try with new Token from Code"
    case .decoding:
      return "An error occurred while decoding data."
    case .request:
      return "An error occurred while sending request."
    }
  }
}

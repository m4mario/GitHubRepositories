//
//  DetailView.swift
//  GitHubRepositories
//
//  Created by Domnic Mario Francis Lewellynn on 1/26/23.
//

import SwiftUI

struct DetailView: View {
    var testString: String?
    
    var body: some View {
        Text(testString ?? "Hello world")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

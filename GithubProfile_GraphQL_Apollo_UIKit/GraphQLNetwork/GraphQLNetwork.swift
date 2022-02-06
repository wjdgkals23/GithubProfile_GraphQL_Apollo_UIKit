//
//  GraphQLNetwork.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/06.
//

import Foundation
import Apollo

class GraphQLNetwork {
  static let shared = GraphQLNetwork()

    let apollo: ApolloClient
    
    init() {
        let store : ApolloStore = ApolloStore()
        let network = RequestChainNetworkTransport(
            interceptorProvider: DefaultInterceptorProvider(store: store),
            endpointURL: URL(string: "https://api.github.com/graphql")!,
            additionalHeaders: ["Authorization" : "bearer Github Personal Token"])
        self.apollo = ApolloClient(networkTransport: network, store: store)
    }
}

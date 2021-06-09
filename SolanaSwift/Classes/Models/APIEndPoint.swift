//
//  APIEndPoint.swift
//  SolanaSwift
//
//  Created by Chung Tran on 26/04/2021.
//

import Foundation

extension SolanaSDK {
    public struct APIEndPoint: Hashable, Codable {
        public init(url: String, network: SolanaSDK.Network, socketUrl: String? = nil) {
            self.url = url
            self.network = network
            self.socketUrl = socketUrl ?? url.replacingOccurrences(of: "http", with: "ws")
        }
        
        public let url: String
        public var network: Network
        public var socketUrl: String
        
        public static var definedEndpoints: [Self] {
            [
                .init(url: "https://api.mainnet-beta.solana.com", network: .mainnetBeta),
                .init(url: "https://datahub-proxy.p2p.org", network: .mainnetBeta),
                .init(url: "https://solana-api.projectserum.com", network: .mainnetBeta),
                .init(url: "https://devnet.solana.com", network: .devnet),
                .init(url: "https://testnet.solana.com", network: .testnet)
            ]
        }
    }
}
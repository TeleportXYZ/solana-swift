//
//  ParsedTransaction.swift
//  SolanaSwift
//
//  Created by Chung Tran on 05/04/2021.
//

import Foundation

public extension SolanaSDK {
    struct AnyTransaction: Hashable {
        public init(signature: String, value: AnyHashable?) {
            self.signature = signature
            self.value = value
        }
        
        public let signature: String
        public let value: AnyHashable?
    }
    
    struct CreateAccountTransaction: Hashable {
        public let fee: Double? // in SOL
        public let newToken: Token?
        
        static var empty: Self {
            CreateAccountTransaction(fee: nil, newToken: nil)
        }
    }
    
    struct CloseAccountTransaction: Hashable {
        public let reimbursedAmount: Double?
        public let closedToken: Token?
    }
    
    struct TransferTransaction: Hashable {
        public let source: Token?
        public let destination: Token?
        public let amount: Double?
    }
    
    struct SwapTransaction: Hashable {
        // source
        public let source: Token?
        public let sourceAmount: Double?
        
        // destination
        public let destination: Token?
        public let destinationAmount: Double?
        
        static var empty: Self {
            SwapTransaction(source: nil, sourceAmount: nil, destination: nil, destinationAmount: nil)
        }
    }
}

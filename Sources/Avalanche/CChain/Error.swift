//
//  Error.swift
//  
//
//  Created by Yehor Popovych on 10/27/20.
//

import Foundation

public struct CChainError: Decodable, Equatable, Hashable {
    public let code: Int
    public let message: String
    public let data: Array<CChainError>?
}

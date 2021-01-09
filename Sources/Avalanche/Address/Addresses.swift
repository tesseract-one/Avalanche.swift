//
//  File.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation

public struct Addresses {
    public let xMain: [Address]
    public let xChange: [Address]
    public let pMain: [Address]
    public let pChange: [Address]
    public let c: [Address]
    
    public init(xMain: [Address], xChange: [Address], pMain: [Address], pChange: [Address], c: [Address]) {
        self.xMain = xMain
        self.xChange = xChange
        self.pMain = pMain
        self.pChange = pChange
        self.c = c
    }
}

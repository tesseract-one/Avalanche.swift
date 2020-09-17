//
//  File.swift
//  
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public protocol AvalancheAPI {
    var avalanche: AvalancheCore { get }
    
    init(avalanche: AvalancheCore);
    
    static var id: String { get }
}

extension AvalancheAPI {
    static var id: String {
        return String(describing: self)
    }
}

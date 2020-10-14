//
//  Currency.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation
import BigInt

extension BigUInt {
    public static let oneAVAX = BigUInt(1000000000)
    public static let deciAVAX = oneAVAX / 10
    public static let centiAVAX = oneAVAX / 100
    public static let milliAVAX = oneAVAX / 1000
    public static let microAVAX = oneAVAX / 1000000
    public static let nanoAVAX = oneAVAX / 1000000000
    public static let wei = BigUInt(1)
    public static let gwei = wei * 1000000000
    public static let gweiAVAX = nanoAVAX
    public static let AVAXStakeCap = oneAVAX * 3000000
}

extension UnsignedInteger {
    public var AVAX: BigUInt {
        return BigUInt.oneAVAX * BigUInt(self)
    }
    
    public var deciAVAX: BigUInt {
        return BigUInt.deciAVAX * BigUInt(self)
    }
    
    public var centiAVAX: BigUInt {
        return BigUInt.centiAVAX * BigUInt(self)
    }
    
    public var milliAVAX: BigUInt {
        return BigUInt.milliAVAX * BigUInt(self)
    }
    
    public var microAVAX: BigUInt {
        return BigUInt.microAVAX * BigUInt(self)
    }
    
    public var nanoAVAX: BigUInt {
        return BigUInt.nanoAVAX * BigUInt(self)
    }
    
    public var wei: BigUInt {
        return BigUInt.wei * BigUInt(self)
    }
    
    public var gwei: BigUInt {
        return BigUInt.wei * BigUInt(self)
    }
    
    public var gweiAVAX: BigUInt {
        return BigUInt.gweiAVAX * BigUInt(self)
    }
}

extension SignedInteger {
    public var AVAX: BigUInt {
        return BigUInt.oneAVAX * BigUInt(self)
    }
    
    public var deciAVAX: BigUInt {
        return BigUInt.deciAVAX * BigUInt(self)
    }
    
    public var centiAVAX: BigUInt {
        return BigUInt.centiAVAX * BigUInt(self)
    }
    
    public var milliAVAX: BigUInt {
        return BigUInt.milliAVAX * BigUInt(self)
    }
    
    public var microAVAX: BigUInt {
        return BigUInt.microAVAX * BigUInt(self)
    }
    
    public var nanoAVAX: BigUInt {
        return BigUInt.nanoAVAX * BigUInt(self)
    }
    
    public var wei: BigUInt {
        return BigUInt.wei * BigUInt(self)
    }
    
    public var gwei: BigUInt {
        return BigUInt.wei * BigUInt(self)
    }
    
    public var gweiAVAX: BigUInt {
        return BigUInt.gweiAVAX * BigUInt(self)
    }
}

//
//  File.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import XCTest
import Avalanche


final class AddressTests: XCTestCase {
    func testBech32() {
        let address = try! AvalancheAddress(b32: "X-avax1len9mtl469gfkcphxt4fja8jrpngrm5am3dqqf")
        print("Address", address.address as NSData)
        let bech32 = address.bech32!
        print("Bech32", bech32)
    }
}

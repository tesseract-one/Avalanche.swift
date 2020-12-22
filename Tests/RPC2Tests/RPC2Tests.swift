//
//  File.swift
//  
//
//  Created by Daniel Leping on 14/12/2020.
//

import Foundation

import XCTest
#if !COCOAPODS
@testable import RPC2
#else
@testable import Avalanche
#endif

struct TestReq: Encodable {
}

struct TestResponse: Decodable {
    let message: String
}

struct TestError: Decodable {
    let scary: String
}

struct DummySingleShotConnection: SingleShotConnection {
    func request(data: Data?, response: @escaping ConnectionCallback) {
        response(.success(nil))
    }
}

struct DummyPersistentConnection: PersistentConnection {
    var sink: ConnectionSink
    
    func send(data: Data) {
    }
    
}

extension String : Error {
}

/*class SSS<Ser: ClientService> where Ser : ServiceProtocol {
    let ser: Ser
    
    init(ser: Ser) {
        self.ser = ser
    }
}

extension SSS where Ser.Connection: SingleShotConnection {
    func a() {}
}

extension SSS where Ser.Connection: PersistentConnection {
    func a() {}
}*/

protocol SSSP {
    
}

/*class Cont {
    let sss: SSSP
    
    init<Factory: ConnectionFactory>(_ cfp: ConnectionFactoryProvider<Factory>) {
        sss = SSS(ser: JsonRpc2(cfp, queue: .main, encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc))
    }
}*/




class RPC2Tests: XCTestCase {
    func testPlayground() {
        #if swift(>=5.3)
        print("Hello, Swift 5.3")

        #elseif swift(>=5.2)
        print("Hello, Swift 5.2")

        #elseif swift(>=5.1)
        print("Hello, Swift 5.1")

        #elseif swift(>=5.0)
        print("Hello, Swift 5.0")

        #elseif swift(>=4.2)
        print("Hello, Swift 4.2")

        #elseif swift(>=4.1)
        print("Hello, Swift 4.1")

        #elseif swift(>=4.0)
        print("Hello, Swift 4.0")

        #elseif swift(>=3.2)
        print("Hello, Swift 3.2")

        #elseif swift(>=3.0)
        print("Hello, Swift 3.0")

        #elseif swift(>=2.2)
        print("Hello, Swift 2.2")

        #elseif swift(>=2.1)
        print("Hello, Swift 2.1")

        #elseif swift(>=2.0)
        print("Hello, Swift 2.0")

        #elseif swift(>=1.2)
        print("Hello, Swift 1.2")

        #elseif swift(>=1.1)
        print("Hello, Swift 1.1")

        #elseif swift(>=1.0)
        print("Hello, Swift 1.0")

        #endif

        let queue = DispatchQueue.main
        let encoder = JSONEncoder.rpc
        let decoder = JSONDecoder.rpc
        let session = URLSession.shared
        
        //let ser = SSS(ser: JsonRpc(.http(url: URL(string: "http://google.com/")!), queue: queue, encoder: encoder, decoder: decoder))
        
        //let ssszzzz:SingleShotConnectionFactory = .http(url: URL(string: "http://google.com/")!)
        let service = JsonRpc(.http(url: URL(string: "https://api.avax-test.network/ext/bc/C/rpc")!), queue: queue, encoder: encoder, decoder: decoder)
        //let service = JsonRpc(.http(url: URL(string: "https://main-rpc.linkpool.io/")!), queue: queue, encoder: encoder, decoder: decoder)
        let expectationWeb3 = self.expectation(description: "http")
        
        var res1: String = ""
        
        service.call(method: "web3_clientVersion", params: Nil.nil, String.self, String.self) { res in
            print(res)
            switch res {
            case .success(let ver): res1 = ver
            default:break
            }
            
            expectationWeb3.fulfill()
        }
        var sss = ""
        
        //let dummySS = DummySingleShotConnection()
        //let httpConnection = HttpConnection(url: URL(string: "http://google.com/")!, queue: queue, headers: [:], session: session)
        /*let wsConnection = WsConnection(url: URL(string: "ws://google.com/")!, queue: queue) { message in
            switch message {
            case .success(let data):
                print("things are good:", data ?? "no data")
            case .failure(let error): break
            }
        }*/
        //let base = Service(queue: queue, connection: (), encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc, delegate: ())
        var ss: Client & Delegator & Connectable = JsonRpc(.ws(url: URL(string: "wss://api.avax-test.network/ext/bc/C/ws")!, autoconnect: false, pool: .global()), queue: queue, encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc)
        //var ss: Client & Delegator = JsonRpc(.ws(url: URL(string: "wss://main-rpc.linkpool.io/ws")!), queue: queue, encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc)
//        base.call(method: "", params: "", String.self) { (res:Result<String, ServiceError<String,String>>) in
//        }
        
        XCTAssertEqual(ss.connected, ConnectableState.disconnected)
        
        ss.connect()
        
        XCTAssertEqual(ss.connected, ConnectableState.connecting)
        
        let expectation = self.expectation(description: "ws")
        
        ss.delegate = expectation
        
        var res2 = ""
        
        ss.call(method: "web3_clientVersion", params: Nil.nil, String.self, String.self) { res in
            XCTAssertEqual(ss.connected, .connected)
            print("!!!all is good!!!")
            print(res)
            switch res {
            case .success(let ver): res2 = ver
            default:break
            }
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            print("I'm fine")
        }
        
        for n in 0...100 {
            print("About to launch #", n)
            ss.call(method: "web3_clientVersion", params: Nil.nil, String.self, String.self) { res in
                print("returned #", n)
            }
        }
        
        DispatchQueue.global().async {
            print("I'm still fine")
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(res1, res2)
        
        ss.disconnect()
        XCTAssertEqual(ss.connected, .disconnecting)
        
        let disconnect = self.expectation(description: "disconnect")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            disconnect.fulfill()
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertEqual(ss.connected, .disconnected)
    }
    
    static var allTests = [
        ("Playground", testPlayground),
    ]
}

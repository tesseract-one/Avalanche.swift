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
    var sink: ConnectionCallback
    
    func send(data: Data) {
    }
    
}

extension String : Error {
}

class RPC2Tests: XCTestCase {
    func testPlayground() {
        let queue = DispatchQueue.main
        let encoder = JSONEncoder.rpc
        let decoder = JSONDecoder.rpc
        let session = URLSession.shared
        
        //let ssszzzz:SingleShotConnectionFactory = .http(url: URL(string: "http://google.com/")!)
        let service = Service(.http(url: URL(string: "http://google.com/")!), queue: queue, encoder: encoder, decoder: decoder)
        service.call(method: "test", params: "wtf", String.self, String.self) { res in
            print(res)
        }
        var sss = ""
        
        
        let dummySS = DummySingleShotConnection()
        let httpConnection = HttpConnection(url: URL(string: "http://google.com/")!, queue: queue, headers: [:], session: session)
        let wsConnection = WsConnection(url: URL(string: "ws://google.com/")!, queue: queue) { message in
            switch message {
            case .success(let data):
                print("things are good:", data ?? "no data")
            case .failure(let error): break
            }
        }
        let base = Service(queue: queue, connection: (), encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc, delegate: ())
        let ss = Service(.ws(url: URL(string: "ws://google.com/")!), queue: queue, encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc, delegate: ())
//        base.call(method: "", params: "", String.self) { (res:Result<String, ServiceError<String,String>>) in
//        }
        
        let expectation = self.expectation(description: "call")
        
        ss.call(method: "test", params: TestReq(), TestResponse.self, TestError.self) { res in
            print("!!!all is good!!!")
            switch res {
            case .failure(let e): print(e); break
            case .success(let response): print(response.message); break
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    static var allTests = [
        ("Playground", testPlayground),
    ]
}

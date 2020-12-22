//
//  RestConnection.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import Foundation

public class AvalancheDefaultRestConnection: AvalancheRestConnection {
    public let url: URL
    public let responseQueue: DispatchQueue
    public let defaultHeaders: Dictionary<String, String>
    public let session: URLSession
    public let encoder: RpcMessageEncoder
    public let decoder: RpcMessageDecoder
    
    public init(
        url: URL, headers: Dictionary<String, String>,
        session: URLSession, responseQueue: DispatchQueue,
        encoder: RpcMessageEncoder, decoder: RpcMessageDecoder
    ) {
        var headers = headers
        headers["Content-Type"] = type(of: encoder).httpContentType
        headers["Accept"] = type(of: decoder).httpContentType
        self.url = url; self.defaultHeaders = headers; self.responseQueue = responseQueue
        self.session = session; self.encoder = encoder; self.decoder = decoder
    }
    
    public func get<Res: Decodable>(
        _ path: String, headers: Dictionary<String, String>?, _ type: Res.Type,
        response: @escaping AvalancheConnectionCallback<Res>
    ) {
        request(path: path, method: "GET", body: nil, headers: headers) { result in
            response(self.decode(from: result))
        }
    }
    
    public func post<Req: Encodable, Res: Decodable>(
        _ path: String, data: Req, headers: Dictionary<String, String>?, _ type: Res.Type,
        response: @escaping AvalancheConnectionCallback<Res>
    ) {
        guard let reqData = encode(value: data, response: response) else { return }
        request(path: path, method: "POST", body: reqData, headers: headers) { result in
            response(self.decode(from: result))
        }
    }
    
    private func encode<Req: Encodable, Res: Decodable>(
        value: Req, response: @escaping AvalancheConnectionCallback<Res>
    ) -> Data? {
        do {
            return try encoder.encode(value)
        } catch let error as EncodingError {
            responseQueue.async { response(.failure(.encoding(error: error))) }
            return nil
        } catch {
            responseQueue.async { response(.failure(.unknown(error: error))) }
            return nil
        }
    }
    
    private func decode<Res: Decodable>(
        from result: Result<Data, RequestError>
    ) -> Result<Res, RequestError> {
        return result.flatMap {
            do {
                return try .success(self.decoder.decode(Res.self, from: $0))
            } catch let error as DecodingError {
                return .failure(.decoding(error: error))
            } catch {
                return .failure(.unknown(error: error))
            }
        }
    }
    
    private func request(
        path: String, method: String, body: Data?, headers: Dictionary<String, String>?,
        response: @escaping (Result<Data, RequestError>) -> Void
    ) {
        var combinedHeaders = self.defaultHeaders
        if let headers = headers {
            combinedHeaders = combinedHeaders.merging(headers){ (_, last) in last }
        }
        var req = URLRequest(url: self.url.appendingPathExtension(path))
        req.httpMethod = method
        req.httpBody = body
        for (k, v) in combinedHeaders {
            req.addValue(v, forHTTPHeaderField: k)
        }
        session.dataTask(with: req) { data, urlResponse, error in
            guard let urlResponse = urlResponse as? HTTPURLResponse, let data = data, error == nil else {
                let err: RequestError = error != nil
                    ? .network(error: error!)
                    : .unknown(error: nil)
                self.responseQueue.async { response(.failure(err)) }
                return
            }
            
            let status = urlResponse.statusCode
            guard status >= 200 && status < 300 else {
                self.responseQueue.async {
                    response(.failure(.http(code: status, message: data)))
                }
                return
            }
            self.responseQueue.async { response(.success(data)) }
        }.resume()
    }
}
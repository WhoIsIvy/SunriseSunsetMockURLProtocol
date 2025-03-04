//
//  CustomURLProtocol.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/2/25.
//

import Foundation

class CustomURLProtocol: URLProtocol {
    override class func canInit(with task: URLSessionTask) -> Bool { true }
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: CustomError.badURL)
            return
        }

        do {
            let data = try Website.data(from: url)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .allowed)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URLSessionConfiguration {
    static var custom: URLSessionConfiguration {
        URLProtocol.registerClass(CustomURLProtocol.self)
        let customConfiguration = URLSessionConfiguration.default
        customConfiguration.protocolClasses?.insert(CustomURLProtocol.self, at: 0)
        return customConfiguration
    }
}

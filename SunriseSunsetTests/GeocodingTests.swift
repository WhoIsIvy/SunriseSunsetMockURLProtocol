//
//  GeocodingTests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 3/3/25.
//

import XCTest
@testable import SunriseSunset

final class GeocodingTests: XCTestCase {
    func testGeoDataDecoding() throws {
        let testData = try XCTUnwrap(MockConstant.geoTestData)
        let results = try JSONDecoder().decode(GeoData.self, from: testData)
        XCTAssertEqual(results.name, MockConstant.name)
        XCTAssertEqual(results.lat, MockConstant.latitude)
        XCTAssertEqual(results.lon, MockConstant.longitude)
        XCTAssertEqual(results.country, MockConstant.country)
    }
    
    func testGeoDataWithInvalidNullValue() throws {
        let data = try XCTUnwrap(MockConstant.geoTestDataNull)
        
        var foundResult: GeoData?
        var foundError: Error?
        
        do {
            foundResult = try JSONDecoder().decode(GeoData.self, from: data)
        } catch {
            foundError = error
        }
        
        XCTAssertNil(foundResult)
        XCTAssertNotNil(foundError)
    }
    
    func testAPICall() throws {
        let testData = try XCTUnwrap(MockConstant.geoTestData)
        let zipcode = MockConstant.zipcode
        let geoURL = GeocodingAPI.geoURL(for: zipcode, appID: APIKey.geoKey)
        MockURLProtocol.mockData[geoURL] = testData
        
        URLProtocol.registerClass(MockURLProtocol.self)
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        let urlSession = URLSession(configuration: mockConfiguration)
        
        let expectation = XCTestExpectation(description: "Wait for mock session")
        
        var foundData: GeoData?
        var foundError: Error?
        
        do {
            try fetch(zipCode: zipcode, urlSession: urlSession) { geoData in
                foundData = geoData
            }
        } catch {
            foundError = error
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNil(foundError)
        XCTAssertEqual(foundData?.name, MockConstant.name)
        XCTAssertEqual(foundData?.country, MockConstant.country)
        XCTAssertEqual(foundData?.lat, MockConstant.latitude)
        XCTAssertEqual(foundData?.lon, MockConstant.longitude)
    }
    
    private func fetch(zipCode: Int, urlSession: URLSession, completion: @escaping (GeoData) -> Void) throws {
        Task {
            do {
                let data = try await GeocodingAPI.fetchCoordinates(forZip: zipCode, urlSession: urlSession)
                completion(data)
            } catch {
                throw error
            }
        }
    }
}

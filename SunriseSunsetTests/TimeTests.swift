//
//  TimeTests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 3/3/25.
//

import XCTest
@testable import SunriseSunset

final class TimeTests: XCTestCase {
    func testTimeResultsDecoding() throws {
        let testData = try XCTUnwrap(MockConstant.timeResults)
        let results = try JSONDecoder().decode(TimeResults.self, from: testData)
        print(results)
        XCTAssertEqual(results.sunrise, MockConstant.sunrise)
        XCTAssertEqual(results.sunset, MockConstant.sunset)
    }
    
    func testTimeResultsWithInvalidNullValue() throws {
        let data = try XCTUnwrap(MockConstant.timeResultsNull)
        
        var foundResult: TimeResults?
        var foundError: Error?
        
        do {
            foundResult = try JSONDecoder().decode(TimeResults.self, from: data)
        } catch {
            foundError = error
        }
        
        XCTAssertNil(foundResult)
        XCTAssertNotNil(foundError)
    }
    
    func testTimeData() throws {
        let testData = try XCTUnwrap(MockConstant.timeData)
        let results = try JSONDecoder().decode(TimeData.self, from: testData).results
        XCTAssertEqual(results.sunrise, MockConstant.sunrise)
        XCTAssertEqual(results.sunset, MockConstant.sunset)
    }
    
    func testTimeDataWithInvalidNullValue() throws {
        let data = try XCTUnwrap(MockConstant.timeDataNull)
        
        var foundResult: TimeData?
        var foundError: Error?
        
        do {
            foundResult = try JSONDecoder().decode(TimeData.self, from: data)
        } catch {
            foundError = error
        }
        
        XCTAssertNil(foundResult)
        XCTAssertNotNil(foundError)
    }
    
    func testAPICall() throws {
        let testData = try XCTUnwrap(MockConstant.timeData)
        let lat = MockConstant.latitude
        let lon = MockConstant.longitude
        let timeURL = TimeAPI.timeURL(lat: lat, lon: lon)
        MockURLProtocol.mockData[timeURL] = testData
        
        URLProtocol.registerClass(MockURLProtocol.self)
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        let urlSession = URLSession(configuration: mockConfiguration)
        
        let expectation = XCTestExpectation(description: "Wait for mock session")

        var foundData: TimeData?
        var foundError: Error?
        
        do {
            try fetch(lat: lat, lon: lon, urlSession: urlSession, completion: { timeData in
                foundData = timeData
            })
        } catch {
            foundError = error
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)

        XCTAssertNil(foundError)
        XCTAssertEqual(foundData?.results.sunrise, MockConstant.sunrise)
        XCTAssertEqual(foundData?.results.sunset, MockConstant.sunset)
    }

    private func fetch(lat: Float, lon: Float, urlSession: URLSession, completion: @escaping (TimeData) -> Void) throws {
        Task {
            do {
                let timeData = try await TimeAPI.fetchTimeInfo(forLat: lat, lon: lon, urlSession: urlSession)
                completion(timeData)
            } catch {
                throw error
            }
        }
    }
}

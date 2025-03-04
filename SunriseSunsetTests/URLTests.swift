//
//  URLTests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 3/3/25.
//

import XCTest
@testable import SunriseSunset

final class URLTests: XCTestCase {
    func testGeoURL() throws {
        let goodURL = try XCTUnwrap(URL(string: GeocodingAPI.geoURL(for: City.mockCityInfo.zipCode, appID: APIKey.geoKey)))
        var foundData: Data?
        var foundError: Error?
        do {
            foundData = try Website.getGeoData(from: goodURL)
        } catch {
            foundError = error
        }
        XCTAssertNotNil(foundData)
        XCTAssertNil(foundError)
    }

    func testInvalidGeoURL() throws {
        let badURL = try XCTUnwrap(URL(string: GeocodingAPI.geoURL(for: City.mockCityInfo.zipCode, appID: "badAPIKey")))
        var foundData: Data?
        var foundError: Error?
        do {
            foundData = try Website.getGeoData(from: badURL)
        } catch {
            foundError = error
        }
        XCTAssertEqual(foundError as? CustomError, .invalidLocation)
        XCTAssertNil(foundData)
    }

    func testTimeURL() throws {
        let goodURL = try XCTUnwrap(URL(string: TimeAPI.timeURL(lat: City.mockCityInfo.latitude, lon: City.mockCityInfo.longitude)))
        var foundData: Data?
        var foundError: Error?
        do {
            foundData = try Website.getSunData(from: goodURL)
        } catch {
            foundError = error
        }
        XCTAssertNotNil(foundData)
        XCTAssertNil(foundError)
    }

    func testInvalidTimeURL() throws {
        let badURL = try XCTUnwrap(URL(string: TimeAPI.timeURL(lat: -1111, lon: -1111)))
        var foundData: Data?
        var foundError: Error?
        do {
            foundData = try Website.getSunData(from: badURL)
        } catch {
            foundError = error
        }
        XCTAssertEqual(foundError as? CustomError, .invalidTimes)
        XCTAssertNil(foundData)
    }
}

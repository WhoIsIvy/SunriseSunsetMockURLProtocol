//
//  ViewModelTests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 3/3/25.
//

import XCTest
@testable import SunriseSunset

final class ViewModelTests: XCTestCase {
    func testZipCodeValidation() {
        let viewModel = ViewModel()
        
        let firstAttempt = viewModel.testZipCodeValidation("")
        let secondAttempt = viewModel.testZipCodeValidation("84")
        let thirdAttempt = viewModel.testZipCodeValidation("4f444")
        let validZip = viewModel.testZipCodeValidation("84121")
        
        XCTAssertEqual(firstAttempt.1?.description, String.localization(key: .emptyZip))
        XCTAssertEqual(secondAttempt.1?.description, String.localization(key: .zipInvalidDigitCount))
        XCTAssertEqual(thirdAttempt.1?.description, String.localization(key: .zipInvalidDigit))
        XCTAssertEqual(validZip.0, 84121)
    }
    
    func testAPICalls() throws {
        let geoTestData = try XCTUnwrap(MockConstant.geoTestData)
        let zipcode = MockConstant.zipcode
        let geoURL = GeocodingAPI.geoURL(for: zipcode, appID: APIKey.geoKey)
        
        let timeTestData = try XCTUnwrap(MockConstant.timeData)
        let timeURL = TimeAPI.timeURL(lat: MockConstant.latitude, lon: MockConstant.longitude)
        
        MockURLProtocol.mockData[geoURL] = geoTestData
        MockURLProtocol.mockData[timeURL] = timeTestData
        
        URLProtocol.registerClass(MockURLProtocol.self)
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        
        let urlSession = URLSession(configuration: mockConfiguration)
        
        let expectation = XCTestExpectation(description: "Wait for mock session")
        
        var foundErrorAttributed: NSAttributedString?
        var foundModel: SunModel?
        
        let viewModel = ViewModel()
        viewModel.displayError = { attributed in
            foundErrorAttributed = attributed
        }
        
        viewModel.retrieveSunTimes(for: "\(zipcode)", urlSession: urlSession) { sunModel in
            foundModel = sunModel
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNil(foundErrorAttributed)
        XCTAssertEqual(foundModel?.cityAndCountryAttributed.string, "\(MockConstant.name), \(MockConstant.country)")
        XCTAssertEqual(foundModel?.sunriseTimeAttributed.string, "Sunrise: \(MockConstant.sunrise)")
        XCTAssertEqual(foundModel?.sunsetTimeAttributed.string, "Sunset: \(MockConstant.sunset)")
    }
}

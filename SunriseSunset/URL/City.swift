//
//  City.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

enum City: CaseIterable {
    case aurora
    case dallas
    case losAngeles
    case saltLake
    case mock

    var info: CityInfo {
        switch self {
        case .aurora: return Self.auroraInfo
        case .dallas: return Self.dallasInfo
        case .losAngeles: return Self.losAngelesInfo
        case .saltLake: return Self.saltLakeInfo
        case .mock: return Self.mockCityInfo
        }
    }

    static let auroraInfo = CityInfo(
        zipCode: 13026,
        name: "Aurora",
        latitude: 42.768059,
        longitude: -78.625786,
        country: "US",
        sunrise: "10:00:00 AM",
        sunset: "10:00:00 PM"
    )

    static let dallasInfo = CityInfo(
        zipCode: 75217,
        name: "Dallas",
        latitude: 32.7240145,
        longitude: -96.67407946,
        country: "US",
        sunrise: "09:00:00 AM",
        sunset: "09:00:00 PM"
    )
    
    static let losAngelesInfo = CityInfo(
        zipCode: 90185,
        name: "Los Angeles",
        latitude: 34.052235,
        longitude: -118.243683,
        country: "US",
        sunrise: "07:00:00 AM",
        sunset: "07:00:00 PM"
    )
    
    static let saltLakeInfo = CityInfo(
        zipCode: 84121,
        name: "Salt Lake City",
        latitude: 40.758701,
        longitude: 111.876183,
        country: "US",
        sunrise: "08:00:00 AM",
        sunset: "08:00:00 PM"
    )

    static let mockCityInfo = CityInfo(
        zipCode: 11111,
        name: "MockCity",
        latitude: 1,
        longitude: 2,
        country: "US",
        sunrise: "08:00:00 AM",
        sunset: "08:00:00 PM"
    )
}

struct CityInfo: Encodable {
    let zipCode: Int
    let name: String
    let latitude: Float
    let longitude: Float
    let country: String
    let sunrise: String
    let sunset: String

    func data() throws -> Data {
        try JSONEncoder().encode(self)
    }

    func isEqualToCoordinates(_ coordinates: (lat: Float, lon: Float)) -> Bool {
        coordinates.lat == latitude &&
        coordinates.lon == longitude
    }

    func isEqualToZip(_ zip: Int) -> Bool {
        zipCode == zip
    }
}

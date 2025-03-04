//
//  Website.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

enum Website: String, CaseIterable {
    case sunData = "api.sunrise-sunset.org"
    case geoData = "api.openweathermap.org"

    static func data(from url: URL) throws -> Data {
        guard let host = Website(rawValue: url.host() ?? "") else {
            throw CustomError.badURL
        }
        switch host {
        case .sunData:
            return try Self.getSunData(from: url)
        case .geoData:
            return try Self.getGeoData(from: url)
        }
    }

    static func getGeoData(from url: URL) throws -> Data {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            throw CustomError.badURL
        }

        var appid: String?
        var zip: Int?

        for item in queryItems {
            if item.name == "appid" {
                appid = item.value ?? ""
            }
            if item.name == "zip" {
                zip = Int(item.value ?? "")
            }
        }

        guard let appid = appid, 
              appid == APIKey.geoKey,
              let zip = zip,
              let city = City.allCases.first(where: { $0.info.isEqualToZip(zip) })
        else {
            throw CustomError.invalidLocation
        }

        let info = city.info
        return try JSONEncoder().encode(GeoData(name: info.name, lat: info.latitude, lon: info.longitude, country: info.country))
    }

    static func getSunData(from url: URL) throws -> Data {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            throw CustomError.badURL
        }
        

        var lat: Float?
        var lon: Float?
        for item in queryItems {
            guard let value = item.value else { continue }
            if item.name == "lat" {
                lat = Float(value)
            } else if item.name == "lon" {
                lon = Float(value)
            }
        }

        guard let lat = lat,
              let lon = lon,
              let city = City.allCases.first(where: { $0.info.isEqualToCoordinates((lat, lon)) })
        else {
            throw CustomError.invalidTimes
        }

        let info = city.info
        return try JSONEncoder().encode(TimeData(results: TimeResults(sunrise: info.sunrise, sunset: info.sunset)))
    }
}

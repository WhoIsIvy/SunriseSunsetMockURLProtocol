//
//  TimeAPI.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

struct TimeData: Codable {
    let results: TimeResults
}

struct TimeResults: Codable {
    let sunrise: String
    let sunset: String
}

enum TimeAPI {
    static let baseURL = "https://api.sunrise-sunset.org/json"
    static func timeURL(lat: Float, lon: Float) -> String {
        "\(baseURL)?lat=\(lat)&lon=\(lon)"
    }

    static func fetchTimeInfo(forLat lat: Float, lon: Float, urlSession: URLSession) async throws -> TimeData {
        guard let url = URL(string: timeURL(lat: lat, lon: lon)) else {
            throw CustomError.badURL
        }

        do {
            let (data, _) = try await urlSession.data(from: url)
            let timeData = try JSONDecoder().decode(TimeData.self, from: data)
            return timeData
        } catch {
            throw CustomError.invalidTimes
        }
    }
}

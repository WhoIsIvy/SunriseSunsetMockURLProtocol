//
//  GeocodingAPI.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

struct GeoData: Codable {
    let name: String
    let lat: Float
    let lon: Float
    let country: String
}

enum GeocodingAPI {
    static let baseURL = "https://api.openweathermap.org/geo/1.0/"
    static func geoURL(for zip: Int, appID: String) -> String {
        "\(baseURL)zip?zip=\(zip)&appid=\(appID)"
    }

    static func fetchCoordinates(forZip zip: Int, urlSession: URLSession) async throws -> GeoData {
        guard let url = URL(string: Self.geoURL(for: zip, appID: APIKey.geoKey)) else {
            throw CustomError.badURL
        }

        do {
            let (data, _) = try await urlSession.data(from: url)
            let geoData = try JSONDecoder().decode(GeoData.self, from: data)
            return geoData
        } catch {
            throw CustomError.invalidLocation
        }
    }
}

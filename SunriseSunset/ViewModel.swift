//
//  ViewModel.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import UIKit

struct SunModel {
    let city: String
    let country: String
    let sunrise: String
    let sunset: String

    var cityAndCountryAttributed: NSAttributedString {
        Attributed.additional.attributed("\(city), \(country)")
    }

    var sunriseTimeAttributed: NSAttributedString {
        Attributed.sun.attributed("\(String.localization(key: .sunrise)): \(sunrise)")
    }

    var sunsetTimeAttributed: NSAttributedString {
        Attributed.sun.attributed("\(String.localization(key: .sunset)): \(sunset)")
    }
}

class ViewModel {
    let backgroundImage = Constant.backgroundAsset

    var sunriseTitleAttributed: NSAttributedString {
        Attributed.title.attributed(.localization(key: .sunrise))
    }

    var sunsetTitleAttributed: NSAttributedString {
        Attributed.title.attributed(.localization(key: .sunset))
    }

    var zipPlaceholderAttributed: NSAttributedString {
        Attributed.placeholder.attributed(.localization(key: .zipPlaceholder))
    }

    var disclaimerAttributed: NSAttributedString {
        Attributed.disclaimer.attributed(.localization(key: .disclaimer))
    }

    var displayError: ((NSAttributedString) -> Void)?

    func retrieveSunTimes(for zipString: String, urlSession: URLSession = .init(configuration: .custom), completion: @escaping (SunModel) -> Void) {
        Task {
            do {
                let validZipCode = try getValidZipcode(from: zipString)
                let geoData = try await GeocodingAPI.fetchCoordinates(forZip: validZipCode, urlSession: urlSession)
                let timeData = try await TimeAPI.fetchTimeInfo(forLat: geoData.lat, lon: geoData.lon, urlSession: urlSession)
                DispatchQueue.main.async {
                    completion(SunModel(city: geoData.name,
                                        country: geoData.country,
                                        sunrise: timeData.results.sunrise,
                                        sunset: timeData.results.sunset)
                    )
                }
            } catch {
                DispatchQueue.main.async {
                    let customError = error as? CustomError ?? .badURL
                    self.displayError?(Attributed.additional.attributed(customError.description))
                }
            }
        }
    }

    private func getValidZipcode(from string: String) throws -> Int {
        guard !string.isEmpty else {
            throw CustomError.zipEmpty
        }

        guard let zipCode = Int(string) else {
            throw CustomError.zipInvalidCharacter
        }

        guard string.count == 5 else {
            throw CustomError.zipInvalidCount
        }

        return zipCode
    }
}

#if DEBUG
extension ViewModel {
    func testZipCodeValidation(_ zipString: String) -> (Int?, CustomError?) {
        do {
            let zip = try getValidZipcode(from: zipString)
            return (zip, nil)
        } catch {
            return (nil, error as? CustomError)
        }
    }
}
#endif

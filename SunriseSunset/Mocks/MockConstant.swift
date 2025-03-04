//
//  MockConstant.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

enum MockConstant {
    static let zipcode = 84121
    static let name = "Salt Lake City"
    static let latitude: Float = 40.758701
    static let longitude: Float = 111.876183
    static let country = "US"
    static let sunrise = "08:00:00 AM"
    static let sunset = "08:00:00 PM"

    static let timeResults = """
    {
        "sunrise": "\(MockConstant.sunrise)",
        "sunset": "\(MockConstant.sunset)"
    }
    """.data(using: .utf8)

    static let timeResultsNull = """
    {
        "sunrise": null,
        "sunset": "\(MockConstant.sunset)"
    }
    """.data(using: .utf8)

    static let timeData = """
    {
        "results": {
            "sunrise": "\(MockConstant.sunrise)",
            "sunset": "\(MockConstant.sunset)"
        }
    }
    """.data(using: .utf8)
    
    static let timeDataNull = """
    {
        "results": {
            "sunrise": "\(MockConstant.sunrise)",
            "sunset": null
        }
    }
    """.data(using: .utf8)

    static let geoTestData =
        """
        {
            "name": "\(MockConstant.name)",
            "lat": \(MockConstant.latitude),
            "lon": \(MockConstant.longitude),
            "country": "\(MockConstant.country)"
        }
        """.data(using: .utf8)

    static let geoTestDataNull = """
           {
               "name": "A name",
               "lat": 04.43,
               "lon": null,
               "country": "US"
           }
           """.data(using: .utf8)
}

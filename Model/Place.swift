//
//  Place.swift
//  EmergencyLocator
//
//  Created by Hasan Tahir on 19/02/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//
import Foundation

struct PlacesType: Codable {
    let htmlAttributions: [String]?
    let results: [Result]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case results, status
    }
}

struct Result: Codable {
    let geometry: Geometry
    let icon: String
    let id: String?
    let name, placeID: String
    let plusCode: PlusCode?
    let reference: String
    let scope: String?

   // let types: [TypeElement]
    let vicinity: String
    let rating: Double?
    let userRatingsTotal: Int?
    let openingHours: OpeningHours?
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case geometry, icon, id, name
        case placeID = "place_id"
        case plusCode = "plus_code"
        case reference, scope, //types,
         vicinity, rating
        case userRatingsTotal = "user_ratings_total"
        case openingHours = "opening_hours"
        case photos
    }
}

struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

struct Location: Codable {
    let lat, lng: Double
}

struct Viewport: Codable {
    let northeast, southwest: Location
}

struct OpeningHours: Codable {
    let openNow: Bool
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

struct PlusCode: Codable {
    let compoundCode, globalCode: String
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

enum Scope: String, Codable {
    case google = "GOOGLE"
}

enum TypeElement: String, Codable {
    case establishment = "establishment"
    case health = "health"
    case hospital = "hospital"
    case pointOfInterest = "point_of_interest"
}




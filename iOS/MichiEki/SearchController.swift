//
//  SearchController.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

import Foundation
import CoreLocation
import MapKit

class SearchController: LocationService {
    
    // MARK: - Properties
    private lazy var geocoder = CLGeocoder()
    
    // MARK: - Location Service
    func getCoordinate(address: String, completion: @escaping AddressLocationDataResult) {
        guard !address.isEmpty else {
            return
        }
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                completion(.failure(.requestFailed(error!)))
                return
            }
            if let placemarks = placemarks {
                let locations = placemarks.compactMap({ (placemark) -> Location? in
                    guard let name = placemark.name else { return nil }
                    guard let location = placemark.location else { return nil }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                })
                completion(.success(locations))
            }
        }
    }
    
    func getCoordinate(facility: String, prefecture: String, city: String, location: Location, completion: @escaping EkiLocationDataResult) {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: center, span: span)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = facility
        request.region = region
        let localSearch: MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start() { (result, error) in
            guard error == nil,
                  let searchResult = result else {
                completion(.failure(.requestFailed(error!)))
                return
            }
            var data:[EkiLocation] = []
            for placemark in searchResult.mapItems {
                let ekiLocation = EkiLocation(name: facility + ":" + (placemark.name ?? ""),
                                              prefecture: prefecture,
                                              long: placemark.placemark.coordinate.longitude,
                                              lati: placemark.placemark.coordinate.latitude)
                data.append(ekiLocation)
            }
            completion(.success(data))
        }
    }
    
}

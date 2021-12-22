//
//  MapViewModel.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/22.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel {
    
    let searchController = SearchController()
    
    func search(keyword: String, completion: @escaping (Result<[EkiLocation],Error>) -> () ) {
        searchController.getCoordinate(address: keyword) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let locations):
                locations.forEach {
                    self?.searchController.getFacility(location: $0) { result in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let locations):
                            completion(.success(locations))
                            
                        }
                    }
                }
            }
        }
    }
    
    func getCenter(locations: [EkiLocation]) -> CLLocationCoordinate2D {
        let latSorted:[Double] = locations.map{ $0.lati }.sorted(by: { $0 > $1 })
        let longSorted:[Double] = locations.map{ $0.long }.sorted(by: { $0 > $1 })
        let averLong = (longSorted.first! + longSorted.last!) / 2
        let averLati = (latSorted.first! + latSorted.last!) / 2
        let center = CLLocationCoordinate2D(latitude: averLati,
                                            longitude: averLong)
        return center
    }
    
    func convertPin(location: EkiLocation) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = location.name
        pin.subtitle = "lati:\(location.lati), long:\(location.long)"
        let coordinate = CLLocationCoordinate2D(latitude: location.lati, longitude: location.long)
        pin.coordinate = coordinate
        return pin
    }
}

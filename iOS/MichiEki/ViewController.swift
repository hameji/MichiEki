//
//  ViewController.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let searchController = SearchController()

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func addPin(facility: [EkiLocation]) {
        if facility.count == 1 { return }
        facility.forEach {
            let pin = MKPointAnnotation()
            pin.title = $0.name
            pin.subtitle = "lati:\($0.lati), long:\($0.long)"
            let coordinate = CLLocationCoordinate2D(latitude: $0.lati, longitude: $0.long)
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
        }
    }
    
    private func setCenter(coordinate: CLLocationCoordinate2D) {
        mapView.camera.centerCoordinate = coordinate
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchWord = searchBar.text,
              !searchWord.isEmpty else { return }
        search(keyword: searchWord)
    }
    
    private func search(keyword: String) {
        searchController.getCoordinate(address: keyword) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let locations):
                locations.forEach {
                    self?.searchController.getFacility(location: $0) { [weak self] result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let locations):
                            guard !locations.isEmpty else {
                                return
                            }
                            let latSorted:[Double] = locations.map{ $0.lati }.sorted(by: { $0 > $1 })
                            let longSorted:[Double] = locations.map{ $0.long }.sorted(by: { $0 > $1 })
                            let averLong = (longSorted.first! + longSorted.last!) / 2
                            let averLati = (latSorted.first! + latSorted.last!) / 2
                            let center = CLLocationCoordinate2D(latitude: averLati,
                                                                longitude: averLong)
                            self?.setCenter(coordinate: center)
                            self?.addPin(facility: locations)
                        }
                    }
                }
            }
        }
    }
}


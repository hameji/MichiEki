//
//  ViewController.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
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
        ApiController.shared.fetchFacility(prefecture: searchWord) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let eki):
                print(eki)
            }
        }
    }
}


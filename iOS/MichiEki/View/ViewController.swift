//
//  ViewController.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var mapViewModel: MapViewModel!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapViewModel = MapViewModel()
    }
    
    private func addPin(facility: [EkiLocation]) {
        facility.forEach {
            let pin = mapViewModel.convertPin(location: $0)
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
        mapViewModel.search(keyword: searchWord) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let locations):
                guard let self = self else { return }
                let center = self.mapViewModel.getCenter(locations: locations)
                self.setCenter(coordinate: center)
                self.addPin(facility: locations)
            }
        }
    }
}


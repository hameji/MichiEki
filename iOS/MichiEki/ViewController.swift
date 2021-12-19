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


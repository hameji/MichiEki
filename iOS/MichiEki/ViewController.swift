//
//  ViewController.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ApiController.shared.fetchFacility(prefecture: "埼玉県") { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let eki):
                print(eki)
            }
        }
    }


}


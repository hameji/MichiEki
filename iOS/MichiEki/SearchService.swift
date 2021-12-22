//
//  LocationService.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

protocol SearchService {

    // MARK: - Type Aliases
    typealias AddressLocationDataResult = (Result<[Location], LocationServiceError>) -> Void
    typealias EkiLocationDataResult = (Result<[EkiLocation], LocationServiceError>) -> Void

    // MARK: - Methods
    func getCoordinate(address: String, completion: @escaping AddressLocationDataResult)

}

// MARK: - Types

enum LocationServiceError: Error {
    
    // MARK: - Cases
    
    case invalidAddressString
    case requestFailed(Error)
    
}

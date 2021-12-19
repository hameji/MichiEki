//
//  ApiController.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

import Foundation

enum ApiError: Error {
    case urlError
    case queryError
    case responseError
    case unknown
}

class ApiController {
    
    static let shared = ApiController()

    static let urlString = "http://52.69.132.129/"
    typealias EkiDataResult = (Result<[Eki], Error>) -> ()

    func fetchFacility(prefecture: String, completion: @escaping EkiDataResult) {
        getSession(prefecture: prefecture, completion: completion)
    }
    
    private func getSession(prefecture: String, completion: @escaping EkiDataResult) {
        guard let encodedPrefecture = prefecture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(ApiError.queryError))
            return
        }
        guard let rawUrl = URL(string: Self.urlString + encodedPrefecture) else {
            completion(.failure(ApiError.urlError))
            return
        }
        let task = URLSession.shared.dataTask(with: rawUrl) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let httpResponse = response as? HTTPURLResponse {
                let code = httpResponse.statusCode
                if code != 200 {
                    completion(.failure(ApiError.responseError))
                }
                if let safeData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let ekiData = try decoder.decode(EkiData.self, from: safeData)
                        completion(.success(ekiData.data))
                    } catch let err {
                        completion(.failure(err))
                    }
                }
            } else {
                completion(.failure(ApiError.unknown))
            }
        }.resume()
    }
    
}

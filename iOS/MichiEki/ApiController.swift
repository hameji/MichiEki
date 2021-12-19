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
    case responseError(Int)
    case resultError
    case unknown
}

class ApiController {
    
    static let shared = ApiController()
    
    static let urlString = "http://52.69.132.129/Prefecture="
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
        URLSession.shared.dataTask(with: rawUrl) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ApiError.unknown))
                return
            }
            let code = httpResponse.statusCode
            guard code == 200,
                  let safeData = data else {
                completion(.failure(ApiError.responseError(code)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let ekiData = try decoder.decode(EkiData.self, from: safeData)
                if ekiData.result {
                    completion(.success(ekiData.data))
                } else {
                    completion(.failure(ApiError.resultError))
                }
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
}

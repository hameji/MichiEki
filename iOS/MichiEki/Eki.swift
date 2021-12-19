//
//  Eki.swift
//  MichiEki
//
//  Created by Hajime Taniguchi on 2021/12/19.
//

struct Eki: Decodable {
    let name: String
    let prefecture: String
    let registerYear: Int
    let registerMonth: Int
    let city: String
    let url: String
}

struct EkiData: Decodable {
    let result: Bool
    let data: [Eki]
}

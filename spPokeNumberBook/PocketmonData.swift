//
//  NetworkService.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/20/25.
//

import Foundation

struct PocketmonData: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: SpritesData
}

struct SpritesData: Decodable {
    let versions: VersionsData
}

struct VersionsData: Decodable {
    let generationSecond: GenerationData

    enum CodingKeys: String, CodingKey {
        case generationSecond = "generation-ii"
    }
}

struct GenerationData: Decodable {
    let gold: GoldData
}

struct GoldData: Decodable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

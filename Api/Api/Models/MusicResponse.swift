//
//  MusicResponse.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

/// Response Model from GET music api
public struct MusicResponse: Codable {
    public var results: [Music] = []
}

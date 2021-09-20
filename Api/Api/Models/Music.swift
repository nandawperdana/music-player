//
//  Music.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

/// Music model from api
public struct Music: Codable {
    public var trackId: Int64?
    public var artistName: String?
    public var trackName: String?
    public var previewUrl: String?
    public var collectionName: String?
    public var artworkUrl60: String?
    public var artworkUrl100: String?
    public var trackViewUrl: String?
    public var trackTimeMillis: Int64?
    
    private enum CodingKeys: String, CodingKey {
        case trackId
        case artistName
        case trackName
        case previewUrl
        case collectionName
        case artworkUrl60
        case artworkUrl100
        case trackViewUrl
        case trackTimeMillis
    }
}

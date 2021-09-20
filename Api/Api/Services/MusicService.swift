//
//  MusicService.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Alamofire

/// Music services
public struct MusicService {
    
    /**
     Get Search Music
     Path: /search
     */
    public static func getSearchMusic(
        query: String,
        limit: Int? = nil,
        progress: ((Double) -> ())? = nil,
        onSuccess: ((MusicResponse) -> ())? = nil,
        onFailure: ((ErrorResponse) -> ())? = nil) -> ApiRequest<MusicResponse> {
        var params = Api.shared.createParams()
        params["media"] = "music"
        params["term"] = query
        if let limit = limit {
            params["limit"] = limit
        }
        
        return ApiRequest<MusicResponse>(
            path: "/search",
            params: params,
            method: .get,
            progress: progress,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
}

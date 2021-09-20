//
//  ApiRequest.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Alamofire

/// Request implementation to let us create a request value
/// This struct require generic type of `Codable` response model
public struct ApiRequest<T>: ApiRequestInterface where T: Codable {
    public typealias ModelResponse = T
    public var path: String
    public var params: Parameters?
    public var method: HTTPMethod
    public var progress: ((Double) -> ())?
    public var onSuccess: ((ModelResponse) -> ())?
    public var onFailure: ((ErrorResponse) -> ())?
}

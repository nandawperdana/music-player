//
//  ApiRequestInterface.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Alamofire

public protocol ApiRequestInterface {
    associatedtype ModelResponse: Codable
    var path: String { get }
    var params: Parameters? { get }
    var method: Alamofire.HTTPMethod { get }
    var progress: ((Double) -> ())? { get }
    var onSuccess: ((ModelResponse) -> ())? { get }
    var onFailure: ((ErrorResponse) -> ())? { get }
}

fileprivate struct ErrorStackResponse: Codable {
    var errors: [String]?
    var status_message: String?
}

extension ApiRequestInterface {
    @discardableResult
    /// Call ApiRequest value
    ///
    /// - Returns: DataRequest object will be returned with optional just in case we
    /// need to implement cancel or pause operation in our app
    public func call() -> DataRequest {
        return Alamofire.request(Api.shared.apiBasePath + path,
                                 method: method,
                                 parameters: params,
                                 headers: Api.shared.headers)
            .downloadProgress(closure: { prg in
                self.progress?(prg.fractionCompleted)
            })
            .responseData(completionHandler: { response in
                let decoder = JSONDecoder()
                let result: Result<ModelResponse> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let object):
                    self.onSuccess?(object)
                case .failure(let error):
                    self.handleAlamofireError(decoder: decoder,
                                              response: response,
                                              error: error)
                }
            }
        )
    }
    
    /// Handle Request Error
    ///
    /// - Parameters:
    ///   - decoder: current decoder
    ///   - response: response from Alamofire
    ///   - error: Error type from failure result
    private func handleAlamofireError(decoder: JSONDecoder,
                                      response: DataResponse<Data>,
                                      error: Error) {
        var message = error.localizedDescription
        let statusCode: Int = response.response?.statusCode ?? 520
        if let data = response.result.value {
            do {
                let errorStack = try decoder.decode(ErrorStackResponse.self, from: data)
                if let errors = errorStack.errors, let errorMessage = errors.first {
                    message = errorMessage
                }
                if let errorMessage = errorStack.status_message {
                    message = errorMessage
                }
            } catch {
                message = error.localizedDescription
            }
        }
        let error: ErrorResponse = ErrorResponse(
            status: statusCode,
            message: message)
        onFailure?(error)
    }
}

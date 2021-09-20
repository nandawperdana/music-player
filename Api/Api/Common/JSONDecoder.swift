//
//  JSONDecoder.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Alamofire

extension JSONDecoder {
    /// Simplify decoding process of object response from Alamofire function
    ///
    /// - Parameter response: Object response from Alamofire
    /// - Returns: Result with our Model generic type
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            return .failure(NSError(domain: "Did not get data in response",
                                    code: response.response?.statusCode ?? 520,
                                    userInfo: nil))
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            return .failure(error)
        }
    }
}

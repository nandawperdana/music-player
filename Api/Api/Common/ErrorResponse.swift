//
//  ErrorResponse.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

/// Error model from api, to simplify high level information
public struct ErrorResponse {
    public var status: Int
    public var message: String

    public init(status: Int, message: String) {
        self.status = status
        self.message = message
    }
}

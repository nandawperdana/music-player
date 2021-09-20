//
//  Api.swift
//  Api
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Alamofire

/// Api is an internal shared instance that
/// contains base information to request api
public struct Api {
    
    //MARK: - Getter Configs
    var headers: [String: String]? {
        return nil
    }
    
    var apiBasePath: String {
        return pApiBasePath
    }
    
    static var shared: Api {
        return instance
    }
    
    //MARK: - Private properties
    private static var instance: Api!
    private var pApiBasePath: String
    
    /// Api constructor,
    /// api base path is initiated from outside to accomodate backend environment for each target
    /// - Parameters:
    ///   - apiBasePath: base path for api request
    init(apiBasePath: String) {
        pApiBasePath = apiBasePath
    }
    
    /// Construct Api object
    ///
    /// - Parameter apiBasePath: base path for api call
    public static func initInstance(apiBasePath: String) {
        instance = Api(apiBasePath: apiBasePath)
    }
    
    //MARK: - Helper
    /// To create initial parameters
    ///
    /// - Returns: initial parameters
    func createParams() -> Parameters {
        return [:]
    }
}


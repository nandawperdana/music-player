//
//  Connectivity.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Alamofire
import Api

/// All about connectivity helper
class Connectivity {
    
    /// Check wether device is connected to internet
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    /// Error model `No internet connection`
    class var error: ErrorResponse {
        return ErrorResponse(status: 502,
                             message: "Internet connection appears to be offline")
    }
}

//
//  MusicServiceStubTest.swift
//  ApiTests
//
//  Created by Nanda Wisnu Tampan on 21/09/21.
//

import XCTest
import OHHTTPStubs
@testable import Api

class MusicServiceStubTest: XCTestCase {
    
    let stubURL: String = "itunes.apple.com"
    
    override func setUp() {
        super.setUp()
        
        Api.initInstance(apiBasePath: "http://itunes.apple.com")
    }
    
    func testGetSearchMusicSuccess() {
        let expectation = self.expectation(description: "Search Music Called")
        
        stub(condition: isHost(stubURL)) { urlRequest in
            let obj: [String : Any] = ["results": []]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        
        MusicService.getSearchMusic(
            query: "bruno",
            limit: 1,
            onSuccess: { musicResponse in
                XCTAssertTrue(musicResponse.results.count != 0)
                expectation.fulfill()
            },
            onFailure: { error in
                XCTFail()
            }).call()
        
        waitForExpectations(timeout: 3) { error in
            XCTAssertTrue(error == nil)
        }
    }
    
    func testGetSearchMusicNotFound() {
        let statusCode: Int32 = 404
        let message: String = "The resource you requested could not be found."
        
        requestError(statusCode: statusCode,
                     message: message,
                     errors: nil)
    }
    
    func testGetSearchMusicUnauthorized() {
        let statusCode: Int32 = 401
        let message: String = "Invalid API key: You must be granted a valid key."
        
        requestError(statusCode: statusCode,
                     message: message,
                     errors: nil)
        
    }
    
    func testGetSearchMusicUnaccessibleEntity() {
        let statusCode: Int32 = 422
        let errors: [String] = ["query must be provided"]
        
        requestError(statusCode: statusCode,
                     message: nil,
                     errors: errors)
        
    }
    
    private func requestError(statusCode: Int32,
                              message: String?,
                              errors: [String]?) {
        let expectation = self.expectation(description: "Search Music Called")
        
        stub(condition: isHost(stubURL)) { urlRequest in
            var obj: [String : Any] = [:]
            if let errors = errors {
                obj["errors"] = errors
            }
            if let message = message {
                obj["status_message"] = message
            }
            return HTTPStubsResponse(jsonObject: obj,
                                     statusCode: statusCode,
                                     headers: nil)
        }
        
        MusicService.getSearchMusic(
            query: "bruno",
            limit: 25,
            onSuccess: { musicResponse in
                XCTFail()
            },
            onFailure: { error in
                XCTAssertTrue(
                    (error.message == message ?? "" ||
                        error.message == errors?.first ?? "") &&
                        error.status == Int(statusCode))
                expectation.fulfill()
            }
        ).call()
        
        waitForExpectations(timeout: 3) { error in
            XCTAssertTrue(error == nil)
        }
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
}

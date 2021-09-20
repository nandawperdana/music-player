//
//  MusicSearchTest.swift
//  ApiTests
//
//  Created by Nanda Wisnu Tampan on 21/09/21.
//

import XCTest
@testable import Api

class MusicSearchTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Api.initInstance(apiBasePath: "https://itunes.apple.com")
    }
    
    //Test real API get search music
    func testGetSearchMusic() {
        let expectation = self.expectation(description: "Search Music Called")
        MusicService.getSearchMusic(
            query: "bruno",
            limit: 1,
            progress: { progress in
                XCTAssertTrue(progress <= 1.0)
            },
            onSuccess: { response in
                expectation.fulfill()
            },
            onFailure: { errorResponse in
                XCTFail("Error Api Call= \(errorResponse)")
            }
        ).call()
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertTrue(error == nil)
        }
    }
}

//
//  PhotoSearchGallaryTests.swift
//  PhotoSearchGallaryTests
//
//  Created by Geetha on 25/02/22.
//

import XCTest
@testable import PhotoSearchGallary

class PhotoSearchGallaryTests: XCTestCase {
    
    var viewModel:PhotoSearchViewModel!
    var serviceManager:MockServiceManager!
    
    override func setUpWithError() throws {
        
        serviceManager = MockServiceManager()
        
        viewModel = PhotoSearchViewModel(serviceManager: serviceManager)
    }


    override func tearDownWithError() throws {
        viewModel = nil
    
    }

    func testSearchPhotos_success() {

        let request = Request(baseUrl: APIEndPoints.baseUrl, path:"", params: ["method":APIEndPoints.photoMethod, "text":"cat", "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])

        viewModel.search(request: request)
        
        XCTAssertEqual(viewModel.photoDetailsCount, 100)

        XCTAssertEqual(viewModel.photoDetails.first?.title, "cat rider")

    }
    
    func testSearchPhotos_failure() {

        let request = Request(baseUrl: APIEndPoints.baseUrl, path:"failedResonce", params: ["method":APIEndPoints.photoMethod, "text":"cat", "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])

        viewModel.search(request: request)

        XCTAssertEqual(viewModel.photoDetailsCount, 0)

    }
    

}

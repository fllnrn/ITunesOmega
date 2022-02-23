//
//  ITunesOmegaTests.swift
//  ITunesOmegaTests
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import XCTest
@testable import ITunesOmega

class ITunesOmegaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAlbumsExample() throws {
        let client = ITunesSearchClient()
        let expectation = XCTestExpectation()
        client.fetchAlbums(with: "maroon") { result in
            switch result {
            case .success(let albums):
                XCTAssertEqual(albums.count, 50)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testFetchTracksExample() throws {
        let client = ITunesSearchClient()
        let expectation = XCTestExpectation()
        client.fetchTracks(with: 1570664444) { result in
            switch result {
            case .success(let list):
                let trackCount = list.reduce(0) { partialResult, entity in
                    if entity.wrapperType == .track {
                        return partialResult + 1
                    } else {
                        return partialResult
                    }
                }
                XCTAssertEqual(trackCount, 7)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 5)
    }

//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

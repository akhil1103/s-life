//
//  SSIDTests.swift
//  S-Life
//
//  Created by AKHIL MITTAL on 07/05/22.
//

import XCTest

@testable import S_Life

class SSIDTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testfetchNetworkInfo() throws {
        let networkInfo = SSID.fetchNetworkInfo()
        #if targetEnvironment(simulator)
            XCTAssertNil(networkInfo)
        #else
            XCTAssertNotNil(networkInfo)
        #endif
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

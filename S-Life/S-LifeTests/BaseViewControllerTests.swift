//
//  BaseViewControllerTests.swift
//  S-Life
//
//  Created by AKHIL MITTAL on 07/05/22.
//

import XCTest

@testable import S_Life

class BaseViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConnectedToInternet() throws {
        let baseVC = BaseViewController()
        let connected = baseVC.connectedToInternet()
        XCTAssertEqual(connected, Validate.isConnectedToInternet())
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

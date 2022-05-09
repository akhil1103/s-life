//
//  ValidatorTests.swift
//  S-Life
//
//  Created by AKHIL MITTAL on 07/05/22.
//

import XCTest

@testable import S_Life

class ValidatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmail() throws {
        let inValidEmail = Validate.email(email: "bue.com")
        XCTAssertFalse(inValidEmail)
        
        let validEmail = Validate.email(email: "bue@ba.com")
        XCTAssertTrue(validEmail)
    }
    
    func testPassword() throws {
        let invalidPassword = Validate.password(password: "ueu")
        XCTAssertFalse(invalidPassword)
        
        let validPassword = Validate.password(password: "akhil1245")
        XCTAssertTrue(validPassword)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

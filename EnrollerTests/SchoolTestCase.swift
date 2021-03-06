//
//  SchoolTestCase.swift
//  Enroller
//
//
/*
    Created by John Boyer on 5/9/16.
	Copyright © 2016 Rodax Software, Inc. All rights reserved.
 
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
 
	http://www.apache.org/licenses/LICENSE-2.0
 
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */


import XCTest
import CocoaLumberjack

/// School test case
class SchoolTestCase: XCTestCase {

    /// School object
    var school: School?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.school = School()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test School.catalog property
    func testCatalog() {
        XCTAssertNotNil(school?.catalog)
        XCTAssertTrue(school?.catalog.count == 4, "catalog.count != 4")
    }
    
    /// Test School.withdraw()
    func testWithdraw() {
        if let student = school?.findStudent("jennifer@example.com") {
            XCTAssertTrue(school!.withdraw(student))
            XCTAssertFalse(school!.withdraw(student))
        } else {
            XCTFail("Failed to find student")
        }
    }
    
    /// Test School.enroll(_:)
    func testEnroll() {
        DDLogInfo("Enroll")
        
        let alex = Student(email: "alex@example.com",
                           firstName: "Alex",
                           lastName: "Brown",
                           birthday: "1998-04-04")
        
        XCTAssertTrue(school!.enroll(alex))
        XCTAssertFalse(school!.enroll(alex))
    }
    
    /// Test School.findStudent(_:)
    func testFindStudent() {
        DDLogInfo("Finding student")
    
        XCTAssertNil(school?.findStudent("john@example"))
        XCTAssertNotNil(school?.findStudent("jane@example.com"))
        XCTAssertNotNil(school?.findStudent("jennifer@example.com"))
    }
    
    /// Test School.findCourse(_:)
    func testFindCourse() {
        XCTAssertNotNil(school?.findCourse("CS101"))
        XCTAssertNil(school?.findCourse("CS102"))
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

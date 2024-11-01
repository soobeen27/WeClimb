//
//  WeClimbTests.swift
//  WeClimbTests
//
//  Created by Soobeen Jang on 11/1/24.
//

import XCTest
import RxBlocking
@testable import WeClimb

final class WeClimbTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testFollow() {
        let myUID = "Y4RTWOB4EvZRpvFb1I3dpo1Qw9b2"
        let targetUID = "XPPzfgD5GISJIRFffVlzej8yoym1"
        
//        guard let followList = try? FirebaseManager.shared.follow(myUID: myUID, targetUID: targetUID)
//            .toBlocking(timeout: 5).first() else {
//            print("팔로우 중 오류")
//            return
//        }
        let single = FirebaseManager.shared.follow(myUID: myUID, targetUID: targetUID)
            .toBlocking(timeout: 5)
        let followList = try! single.toArray()
                
        
        XCTAssertNotNil(followList, "팔로우 안됐음")
        print(followList)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

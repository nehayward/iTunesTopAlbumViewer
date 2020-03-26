//
//  iTunesTopAlbumViewerUITests.swift
//  iTunesTopAlbumViewerUITests
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import XCTest

class iTunesTopAlbumViewerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // MARK: Mock Network Calls
        app.launchArguments.append("-MockNetwork")
        app.launchArguments.append("YES")
    }
    
    func testDetailSegue() {
        app.launch()
        
        let element = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["After Hours"]
        element.tap()
        
        XCTAssertTrue(app.images["Album Cover Image"].exists)
    }
    
    func testOpeningAlbum() {
        app.launch()

        let element = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["After Hours"]
        element.tap()
        app.buttons["Apple Music Link"].tap()
        app.activate()
        XCTAssertTrue(app.buttons["Apple Music Link"].waitForExistence(timeout: 1))
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                app.launch()
            }
        }
    }
}

//
//  reLovedUITestsLaunchTests.swift
//  reLovedUITests
//
//  Created by 이찬 on 2/5/23.
//

import XCTest

final class reLovedUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let usernameField = app.textFields["Email"]
        XCTAssertTrue(usernameField.exists)
        usernameField.tap()
        usernameField.typeText("Cl@wustl.edu")

        let pwdField = app.secureTextFields["Password"]
        XCTAssertTrue(pwdField.exists)
        pwdField.tap()
        pwdField.typeText("123456")
        pwdField.typeText(XCUIKeyboardKey.return.rawValue)

        let signin = app.buttons["Sign In"]
        XCTAssertTrue(signin.exists)
        signin.tap()

        let tabBar = app.tabBars

        let chatButton = tabBar.buttons["Chat"]
        XCTAssertTrue(chatButton.exists)
        chatButton.tap()

        let likedButton = tabBar.buttons["Liked"]
        XCTAssertTrue(likedButton.exists)
        likedButton.tap()

        let profileButton = tabBar.buttons["Profile"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()

        let editButton = app.buttons["Edit Profile"]
        XCTAssertTrue(editButton.exists)
        editButton.tap()
        let editNav = app.navigationBars["Edit Profile"]
        XCTAssertTrue(editNav.exists)

        let backbtn = editNav.buttons.element(boundBy: 0)
        XCTAssertTrue(backbtn.exists)
        backbtn.tap()
        let homeButton = tabBar.buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        let post = app.scrollViews.otherElements.buttons["food, Leftover Pizza, p5duqy9YfWQViuUL3P7ryCnFaU63"]
        XCTAssertTrue(post.exists)
        post.tap()
        let likeBtn = app.buttons["Like"]
        XCTAssertTrue(likeBtn.exists)
        likeBtn.tap()
        let startMsg = app.buttons["Start Messaging"]
        XCTAssertTrue(startMsg.exists)
        startMsg.tap()
        let msg = app.textFields["message"]
        msg.tap()
        XCTAssertTrue(msg.exists)
        msg.typeText("hello")
        let send = app.buttons["Send"]
        XCTAssertTrue(send.exists)
        send.tap()
        let backbtn2 = app.navigationBars.element.buttons.element(boundBy: 0)
        XCTAssertTrue(backbtn2.exists)
        backbtn2.tap()
        let backbtn3 = app.navigationBars.element.buttons.element(boundBy: 0)
        XCTAssertTrue(backbtn3.exists)
        backbtn3.tap()
        likedButton.tap()
        post.tap()
        backbtn3.tap()
        profileButton.tap()
        let logout = app.buttons["Log out"]
        XCTAssertTrue(logout.exists)
        logout.tap()

        
        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

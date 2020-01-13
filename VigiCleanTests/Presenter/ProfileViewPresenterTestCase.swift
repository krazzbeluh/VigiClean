//
//  ProfileViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class ProfileViewPresenterTestCase: XCTestCase {
    var view: FakeProfileView!
    
    override func setUp() {
        self.view = FakeProfileView()
    }
    
    func testInitShouldCallDisplayAvatarIfDefined() {
        let user = VigiCleanUserFake(username: "", error: nil)
        user.isConnectedWithEmail = true
        user.avatar = Data()
        VigiCleanUser.currentUser = user
        _ = ProfilePresenter(view: view)
        
        XCTAssertTrue(view.didCallDisplayAvatar)
    }
    
    func testIsConnectedAnonymouslyShouldReturnAccountManagerIsConnectedWithEmailInverted() {
        let presenter = ProfilePresenter(view: view)
        
        let user = VigiCleanUserFake(username: "", error: nil)
        user.isConnectedWithEmail = false
        VigiCleanUser.currentUser = user
        XCTAssertTrue(presenter.isConnectedAnonymously)
        
        user.isConnectedWithEmail = true
        XCTAssertFalse(presenter.isConnectedAnonymously)
    }
    
    func testSignOutShouldCallUserSignedOutIfNoError() {
        let presenter = ProfilePresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: nil)
        
        presenter.signOut()
        
        XCTAssertTrue(view.didCallUserSignedOut)
    }
    
    func testSignOutShouldCallDisplayErrorIfError() {
        let presenter = ProfilePresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: EasyError())
        
        presenter.signOut()
        
        XCTAssertFalse(view.didCallUserSignedOut)
    }
    
    func testUpdatePseudoShouldCallDisplayUsernameIfNoError() {
        let presenter = ProfilePresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: nil)
        
        presenter.updatePseudo(to: "username", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayUsername)
    }
    
    func testUpdatePseudoShouldCallDisplayErrorIfError() {
        let presenter = ProfilePresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: EasyError())
        
        presenter.updatePseudo(to: "username", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePseudoShouldCallDisplayErrorIfEmptyTextField() {
        let presenter = ProfilePresenter(view: view)
        
        presenter.updatePseudo(to: "", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdateEmailShouldCallDisplayEmailIfNoError() {
        let presenter = ProfilePresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: nil)
        
        presenter.updateEmail(to: "email@vigiclean.com", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayEmail)
    }
    
    func testUpdateEmailShouldCallDisplayErrorIfError() {
        let presenter = ProfilePresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: EasyError())
        
        presenter.updateEmail(to: "email@vigiclean.com", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdateEmailShouldCallDisplayErrorIfNilInTextField() {
        let presenter = ProfilePresenter(view: view)
        
        presenter.updateEmail(to: "", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdateAvatarShouldCallDisplayAvatarIfNoError() {
        let accountManager = AccountManagerFake(resultData: .success(Data()))
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updateAvatar(to: Data(), with: "")
        
        XCTAssertTrue(view.didCallDisplayAvatar)
    }
    
    func testUpdateAvatarShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(resultData: .failure(EasyError()))
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updateAvatar(to: Data(), with: "")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdateAvatarShouldCallDisplayErrorIfNoPassword() {
        let presenter = ProfilePresenter(view: view)
        
        presenter.updateAvatar(to: Data(), with: nil)
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePasswordShouldCallPasswordChangedIfNoError() {
        let user = VigiCleanUserFake(username: nil, error: nil)
        
        VigiCleanUser.currentUser = user
        
        let presenter = ProfilePresenter(view: view)
        
        presenter.updatePassword(to: "", confirm: "", with: "")
        
        XCTAssertTrue(view.didCallPasswordChanged)
    }
    
    func testUpdatePasswordShouldCallDisplayErrorIfError() {
        let user = VigiCleanUserFake(username: nil, error: EasyError())
        
        VigiCleanUser.currentUser = user
        
        let presenter = ProfilePresenter(view: view)
        
        presenter.updatePassword(to: "", confirm: "", with: "")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePasswordShouldCallDisplayErrorIfNilInTextField() {
        let presenter = ProfilePresenter(view: view)
        
        presenter.updatePassword(to: nil, confirm: "", with: "")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePasswordShouldCallDisplayErrorIfPasswordMismatches() {
        let presenter = ProfilePresenter(view: view)
        
        presenter.updatePassword(to: "azertyuiop", confirm: "poiuytreza", with: "")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}

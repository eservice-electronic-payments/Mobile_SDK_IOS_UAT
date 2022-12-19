//
//  ThreeDS2VerificationServiceTests.swift
//  EvoPaymentsTests
//
//  Created by Adrian Zyga on 22/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import XCTest
import ipworks3ds_sdk
@testable import EvoPayments

/**
 * Tests for `ThreeDS2VerificationService`
 * - Warning: This class is initialized as many times as the quantity of test methods.
 * Each test method has a separate instance of this class, just as in xUnit framework
 */
class ThreeDS2VerificationServiceTests: XCTestCase {

    /// Main mock that spies and validates correctness of each test
    var transactionBuilderMock: TransactionBuilderMock!

    /// Fake instance, not used in tests
    var viewControllerFake: ViewControllerProtocol!

    /// Data used for tests. Same for each test.
    var verificationData: Verification3DServiceData!

    /// System under test
    var sut: ThreeDS2VerificationService!

    override func setUp() {
        transactionBuilderMock = TransactionBuilderMock()
        viewControllerFake = UIViewController()
        verificationData = Verification3DServiceData(
            RID: "fakeRID",
            publicKey: "fakePublicKey",
            CA: "fakeCA",
            clientConfigs: ["fakeConfig", "fakeConfig2"],
            runtimeLicense: "fakeLicense",
            configParameters: ["fakeKey": "fakeValue"],
            directoryServerID: "fakeDirectoryServerID",
            messageVersion: "fakeMessageVersion"
        )
    }

    /// Checks if initializing SUT works correctly
    func testInitializingServiceCreatesAValidThreeDS2VerificationService() throws {

        //  WHEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        //  THEN
        try transactionBuilderMock.verifyInitialization(
            initializeCount: 1,
            configParameters: verificationData.configParameters,
            locale: Locale.preferredLanguages.first,
            clientEventListener: sut
        )
    }

    /// Checks if initializing SUT returns `nil` when transactionBuilder throws errors
    func testInitializingWithErrorThrowsError() throws {
        //  GIVEN
        transactionBuilderMock.shouldThrowOnInitialize = true

        //  WHEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        //  THEN
        XCTAssertNil(sut)
        try transactionBuilderMock.verifyInitialization(initializeCount: 1)
    }

    /// Checks if generating requests works correctly
    func testGeneratingRequestWhenDataIsValidProducesValidRequest() {
        //  GIVEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        //  WHEN
        let request = try? sut.generateRequest()

        //  THEN
        do {
            try transactionBuilderMock.verifyGeneratingRequest(paymentRequest: request, createTransactionCount: 1)
        } catch {
            XCTFail("This should always succeed, but there's error: \(error)")
        }
    }

    /// Checks if generating request handles correctly error triggered by close sourced binary
    func testGeneratingRequestWhenRequestThrowsErrorDoesThrowError() {
        //  GIVEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        transactionBuilderMock.shouldThrowOnGeneratingTransaction = true

        //  WHEN
        let request = try? sut.generateRequest()

        //  THEN
        do {
            try transactionBuilderMock.verifyGeneratingRequest(paymentRequest: request, createTransactionCount: 1)
        } catch {
            XCTFail("This should always succeed, but there's error: \(error)")
        }
    }

    /// Check if starting the challange with currect data is handling timeout correctly
    func testStartingChallangeWithChallangeTimeoutIsStartingTransactionAndClosingTransactionWithTimeout() {
        //  GIVEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        let challange = ThreeDS2Challenge(
            threeDSServerTransactionID: "testServerTransactionID_success",
            acsTransactionID: "testACSTransactionID_success",
            acsRefNumber: "testACSRefNumber_success",
            acsSignedContent: "testACSSignedContent_success"
        )

        //  WHEN
        let request = try? sut.generateRequest()
        XCTAssertNotNil(request)
        let (status, error) = start(challange: challange, shouldTimeout: true)

        //  THEN
        XCTAssertNil(status, "Challange should timeout but it succeeded ")
        XCTAssertNotNil(error)
        transactionBuilderMock.verifyStartingChallange(
            paymentStatus: status,
            error: error,
            doChallangeCount: 1,
            getAuthenticationRequestParametersCount: 1
        )
        transactionBuilderMock.verifyCloseTransaction(closeCount: 1)
    }

    /// Check if starting the challange with currect data is handling cancellation correctly
    func testStartingChallangeWithChallangeCancelledIsStartingTransactionAndClosingTransaction() {
        //  GIVEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        let challange = ThreeDS2Challenge(
            threeDSServerTransactionID: "testServerTransactionID_canceled",
            acsTransactionID: "testACSTransactionID_canceled",
            acsRefNumber: "testACSRefNumber_canceled",
            acsSignedContent: "testACSSignedContent_canceled"
        )

        //  WHEN
        let request = try? sut.generateRequest()
        XCTAssertNotNil(request)
        let (status, error) = start(challange: challange)

        //  THEN
        XCTAssertNil(status, "Challange should be cancelled but it succeeded ")
        XCTAssertNotNil(error)
        transactionBuilderMock.verifyStartingChallange(
            paymentStatus: status,
            error: error,
            doChallangeCount: 1,
            getAuthenticationRequestParametersCount: 1
        )
        transactionBuilderMock.verifyCloseTransaction(closeCount: 1)
    }

    /**
     * Check if triggering the ClientEventListening methods does not crash the system.
     * As they do not return any values or change any state within SUT
     * this test does not have any asserts.
     */
    func testListenerProvidesLogsWithoutFatalErrors() {
        //  GIVEN
        sut = ThreeDS2VerificationService(
            verificationData: verificationData,
            transactionBuilder: transactionBuilderMock,
            viewControler: viewControllerFake
        )

        //  WHEN
        transactionBuilderMock.triggerClientEventListening()

        //  THEN
        //  No fatal errors accured when invoking ClientEventListening methods
    }

    override func tearDown() {
        transactionBuilderMock = nil
        viewControllerFake = nil
        verificationData = nil
        sut = nil
    }

    /**
     * Helper method to start the challange and pass the result.
     * - Parameters:
     *    - challange: Struct with all the data needed to create a challange
     *    - shouldTimeout: Decides wheter to pass a 0 as a time before the timeout, hence triggering one instantaneously
     * - Returns: Tuple with status and error of the transaction fetched from completion of `startChallenge` method
     *      from `ThreeDS2VerificationService`
     * - Warning: This method is using a completion when calling `startChallenge`
     * method, that allows for asynchronous code, **this method works correctly only as**
     * **long as the implementation of** `doChallange` **in the** `TransactionProtocol`
     * **works synchronously.** `TransactionMock` has a synchronous implementation of the `doChallange`
     * method so it work as intended.
     */
    private func start(challange: ThreeDS2Challenge, shouldTimeout: Bool = false) -> (ThreeDS2PaymentStatus?, Error?) {
        var status: ThreeDS2PaymentStatus?
        var error: Error?

        sut.startChallenge(challange, timeout: shouldTimeout ? 0 : 30) { result in
            switch result {
            case .success(let successStatus):
                status = successStatus
            case .failure(let failureError):
                error = failureError
            }
        }

        return (status, error)
    }
}

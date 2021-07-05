//
//  TranslationServiceCase.swift
//  P9_Le_BaluchonTests
//
//  Created by arnaud kiefer on 28/06/2021.
//

import XCTest
@ testable import P9_Le_Baluchon

class TranslationServiceCase: XCTestCase {

    var translation: TranslationService!
    private let languageIndex = 0
    private let textToTranslate = "bonjour"

    override func setUp() {
        super.setUp()
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.translationCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        translation = TranslationService(translationSession: session)
    }

    // MARK: - Network call tests
    func testGetTranslationShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.translationError
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(translationSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        translationService.getTranslation(languageIndex: languageIndex, textToTranslate: textToTranslate) { (success, traductedResponse) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(traductedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(translationSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        translationService.getTranslation(languageIndex: languageIndex, textToTranslate: textToTranslate) { (success, traductedResponse) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(traductedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.conversionCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(translationSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(languageIndex: languageIndex, textToTranslate: textToTranslate) { success, traductedResponse in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(traductedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.conversionIncorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(translationSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(languageIndex: languageIndex, textToTranslate: textToTranslate) { success, traductedResponse in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(traductedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetTranslationInEnglishShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.translationCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(translationSession: session)
         // When
        translationService.getTranslation(languageIndex: languageIndex, textToTranslate: textToTranslate) { (success, traductedResponse) in
            let text = "Hello"
            let detectedSourceLanguage = "fr"
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(traductedResponse)
            XCTAssertEqual(text, traductedResponse!.data.translations[0].translatedText)
            XCTAssertEqual(detectedSourceLanguage, traductedResponse!.data.translations[0].detectedSourceLanguage)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

}

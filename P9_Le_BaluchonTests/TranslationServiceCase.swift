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
        translation = TranslationService(translationSession: URLSessionFake(data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseOK, error: nil))
    }

    func testGetTranslationShouldPostFailedCallbackIfError() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.translationError))
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
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: nil, response: nil, error: nil))
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

    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseKO, error: nil))
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

    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeResponseData.translationIncorrectData, response: FakeResponseData.responseOK, error: nil))
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

    func testGetTranslationInEnglishShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

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

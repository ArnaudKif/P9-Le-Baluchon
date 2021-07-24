//
//  ConversionTestCase.swift
//  P9_Le_BaluchonTests
//
//  Created by arnaud kiefer on 28/06/2021.
//

import XCTest
@ testable import P9_Le_Baluchon

class ConversionTestCase: XCTestCase {

    var conversion: ConversionService!

    override func setUp() {
        super.setUp()
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.conversionCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        conversion = ConversionService(conversionSession: session)
    }

    // MARK: - Network call tests
    func testGetRatesShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.conversionError
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = ConversionService(conversionSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getRates { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetRatesShouldPostFailedCallbackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = ConversionService(conversionSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getRates { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectResponse() {
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
        let conversionService = ConversionService(conversionSession: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        conversionService.getRates { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        /// Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.conversionIncorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = ConversionService(conversionSession: session)
        // When
        conversionService.getRates { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.conversionCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = ConversionService(conversionSession: session)
        // When
        conversionService.getRates { (success, searchRate) in
            let rate = 1.192897
            let index = 0
            let date = "2021-06-28"
            let euroNumber = 2.0
            let dollarNumber = "2,37"
            let convert = self.conversion.euroToDollarConvert(euroNumber: euroNumber, index: index)
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(searchRate)
            XCTAssertEqual(rate, searchRate!.rates.USD)
            XCTAssertEqual(date, searchRate!.date)
            XCTAssertEqual(self.conversion.convertDate(date: date), "28-06-2021")
            XCTAssertEqual(convert, dollarNumber)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - conversion function tests
    func testConvertUserEntrerConvertedInCorrectString() {
        let result = 1.5
        let stringTaped = conversion.stringToDouble(textToTransform: "1,5")
        XCTAssertEqual(result, stringTaped)
    }

    func testErrorInFormatOfNumber() {
        let doubleError = 0.0
        let stringError = conversion.stringToDouble(textToTransform: "t2")
        XCTAssertEqual(doubleError, stringError)

    }

} // enf of ConversionTestCase

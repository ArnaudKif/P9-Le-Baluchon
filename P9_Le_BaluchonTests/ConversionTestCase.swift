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
        conversion = ConversionService(conversionSession: URLSessionFake(data: FakeResponseData.conversionCorrectData, response: FakeResponseData.responseOK, error: nil))
    }



    func testGetRatesShouldPostFailedCallbackIfError() {
        // Given
        let conversionService = ConversionService(
            conversionSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.conversionError))
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

    func testGetRatesShouldPostFailedCallbackIfNoData() {
        // Given
        let conversionService = ConversionService(
            conversionSession: URLSessionFake(data: nil, response: nil, error: nil))
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

    func testGetRatesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let conversionService = ConversionService(
            conversionSession: URLSessionFake(data: FakeResponseData.conversionCorrectData, response: FakeResponseData.responseKO, error: nil))
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

    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let conversionService = ConversionService(
            conversionSession: URLSessionFake(data: FakeResponseData.conversionIncorrectData, response: FakeResponseData.responseOK, error: nil))
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

    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let conversionService = ConversionService(
            conversionSession: URLSessionFake(data: FakeResponseData.conversionCorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getRates { (success, searchRate) in
            let rate = 1.192897
            let date = "2021-06-28"
            let euroNumber = 2.0
            let dollarNumber = "2,39"
            let convert = self.conversion.euroToDollarConvert(euroNumber: euroNumber, rate: rate)
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(searchRate)
            XCTAssertEqual(rate, searchRate!.rates.USD)
            XCTAssertEqual(date, searchRate!.date)
            XCTAssertEqual(self.conversion.convertDate(date: date), "28-06-2021")
            XCTAssertEqual(convert, dollarNumber)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testConvertUserEntrerConvertedInCorrectString() {
        let result = 1.5
        let stringTaped = conversion.stringToDouble(textToTransform: "1,5")
        XCTAssertEqual(result, stringTaped)
    }




} // enf of ConversionTestCase

//
//  WeatherServiceCase.swift
//  P9_Le_BaluchonTests
//
//  Created by arnaud kiefer on 28/06/2021.
//

import XCTest
@ testable import P9_Le_Baluchon

class WeatherServiceCase: XCTestCase {

    var weather: WeatherService!

    override func setUp() {
        super.setUp()
        weather = WeatherService(weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
    }

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.weatherError))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: FakeResponseData.weatherIncorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherInEnglishShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            let temp = 23.61
            let id = 800
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weatherResult)
            XCTAssertEqual(temp, weatherResult!.main.temp)
            XCTAssertEqual(id, weatherResult!.weather[0].id)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    func testDateConvert() {
        let dt = 1624869947
        let date = weather.convertDate(unix: dt)
        let dateString = "28 juin 2021 à 10:45"
        XCTAssertEqual(date, dateString)

    }


}

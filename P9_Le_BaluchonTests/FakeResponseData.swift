//
//  FakeResponseData.swift
//  P9_Le_BaluchonTests
//
//  Created by arnaud kiefer on 28/06/2021.
//

import Foundation

class FakeResponseData  {

    // MARK: - Data
    static var conversionCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Conversion", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Conversion", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Conversion", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let conversionIncorrectData = "erreur".data(using: .utf8)!
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    static let translationIncorrectData = "erreur".data(using: .utf8)!


    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    class ConversionError: Error {}
    static let conversionError = ConversionError()

    class WeatherError: Error {}
    static let weatherError = WeatherError()

    class TranslationError: Error {}
    static let translationError = TranslationError()

}

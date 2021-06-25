//
//  Translation.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 21/06/2021.
//

import Foundation

struct Translation: Codable {
    let data: Translations
} // end of struct Translation

struct Translations: Codable {
    let translations: [Infos]
} // end of struct Translations

struct Infos: Codable {
    let translatedText: String
    let detectedSourceLanguage: String
} // end of struct Infos

//
//  Translation.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 21/06/2021.
//

import Foundation

struct Translation: Codable {
    let data: Translations
}

struct Translations: Codable {
    let translations: [Infos]
}

struct Infos: Codable {
    let translatedText: String
    let detectedSourceLanguage: String
}

let translateLanguage = ["Anglais",
                         "Français",
                         "Allemand",
                         "Espagnol"
                        ]

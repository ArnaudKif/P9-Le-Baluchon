//
//  TranslationService.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 21/06/2021.
//

import Foundation

class TranslationService {

    // MARK: - Singleton pattern
    static var shared = TranslationService()
    private init() {}

    // MARK: - Attribute & init
    private var task : URLSessionDataTask?
    private var translationSession = URLSession(configuration: .default)

    init(translationSession: URLSession) {
        self.translationSession = translationSession
    } // end of init

    // MARK: - Sending alert notification
    private func sendAlertNotification(message : String) {
        let alertName = Notification.Name("alertDisplay")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    } // end of sendAlertNotification

    // MARK: - recovery and processing of translation
    func getTranslation(languageIndex: Int,textToTranslate: String, callback: @escaping (Bool, Translation?) -> Void) {
        if textToTranslate == "" {
            self.sendAlertNotification(message: "Veuillez remplir le texte à traduire")
        }
        let language = selectedLanguage(index: languageIndex)
        let resquest = createTranslationRequest(target: language, text: textToTranslate)
        task?.cancel()
        task = translationSession.dataTask(with: resquest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    self.sendAlertNotification(message: "Absence de réponse du serveur")
                    return
                }
                print("data OK")
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("No response from translationSession")
                    self.sendAlertNotification(message: "Absence de réponse du serveur")
                    return
                }
                print("response status OK")
                guard let responseJSON = try? JSONDecoder().decode(Translation.self, from: data) else {
                    callback(false, nil)
                    print("Failed to decode translationJSON")
                    self.sendAlertNotification(message: "Impossible de traiter la réponse du serveur ")
                    return
                }
                print("JSON OK")
                let traductedResponse: Translation = responseJSON
                callback(true, traductedResponse)
                print(traductedResponse)
            }
        }
        task?.resume()
    } // end of func GetTranslation

    // MARK: - URL & Request configuration
    private func translateURL(target: String,textToTranslate: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "target", value: "\(target)"),
            URLQueryItem(name: "key", value: "\(googleApiIdKey)"),
            URLQueryItem(name: "q", value: "\(textToTranslate)")
        ]
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        return url
    } // end of func translateURL

    private func createTranslationRequest(target: String, text: String) -> URLRequest {
        var request = URLRequest(url: translateURL(target: target, textToTranslate: text))
        request.httpMethod = "POST"
        return request
    } // end of func createTranslationRequest

    private func selectedLanguage(index: Int) -> String {
        let language: String
        switch index {
        case 0 :
            language = "en"
            return language
        case 1 :
            language = "fr"
            return language
        case 2 :
            language = "de"
            return language
        case 3 :
            language = "es"
            return language
        default:
            sendAlertNotification(message: "erreur dans le choix de la langue")
            return "en"
        }
    } // end of selectedLanguage

} // end of class TranslationService

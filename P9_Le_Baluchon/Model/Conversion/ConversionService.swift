//
//  ConversionService.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 21/06/2021.
//

import Foundation

class ConversionService {

    static var shared = ConversionService()
    private init() {}

    private var task : URLSessionDataTask?
    private var conversionSession = URLSession(configuration: .default)

    init(conversionSession: URLSession) {
        self.conversionSession = conversionSession
    } // end of init

    private func sendAlertNotification(message : String) {
        let alertName = Notification.Name("alertDisplay")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    } // end of sendAlertNotification

    private func conversionURL() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/api/latest"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: "\(dataFixerApiIdKey)"),
            URLQueryItem(name: "symbols", value: "USD,AUD,CAD,CHF,CNY,GBP,JPY")
        ]
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        return url
    }// end of func conversionURL

    private func createConversionRequest() -> URLRequest {
        var request = URLRequest(url: conversionURL())
        request.httpMethod = "GET"
        return request
    }// end of func createConversionRequest

    func getRates(callback: @escaping (Bool, CurrencyRate?) -> Void) {
        let resquest = createConversionRequest()
        task?.cancel()
        task = conversionSession.dataTask(with: resquest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    self.sendAlertNotification(message: "Absence de réponse du serveur")
                    return
                }
                print("data OK")
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("No response from conversionSession")
                    self.sendAlertNotification(message: "Absence de réponse du serveur, \nVeuillez vérifier la monnaie choisie !")
                    return
                }
                print("response status OK")
                guard let responseJSON = try? JSONDecoder().decode(CurrencyRate.self, from: data) else {
                    callback(false, nil)
                    print("Failed to decode conversionJSON")
                    self.sendAlertNotification(message: "Impossible de traiter la réponse du serveur ")
                    return
                }
                print("JSON OK")
                let searchRate: CurrencyRate = responseJSON
                callback(true, searchRate)
                print(searchRate)
            }
        }
        task?.resume()
    } // end of func getRates

    func euroToDollarConvert(euroNumber: Double, rate: Double) -> String {
        let dollarNumber: Double = euroNumber * rate
        let dollarString = doubleToInteger(currentDouble: dollarNumber)
        return dollarString
    } // end of func euroToDollarConvert

    private func doubleToInteger(currentDouble: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2

        let doubleAsString =  formatter.string(from: NSNumber(value: currentDouble))!

        return doubleAsString
    } // end of doubleToInteger

    func stringToDouble(textToTransform: String) -> Double {
        let formatter = NumberFormatter()

        if textToTransform.firstIndex(of: ",") != nil {
            formatter.decimalSeparator = ","
        } else { formatter.decimalSeparator = "." }

        let grade = formatter.number(from: textToTransform)
        if let doubleGrade = grade?.doubleValue {
            return doubleGrade
        } else {
            sendAlertNotification(message: "Le nombre est incorrect !\nVeuillez corriger la saisie.")
            return 0.0
        }
    } // end of func stringToDouble

    func convertDate(date: String) -> String {
        let splitDate:[String] = date.split(separator: "-").map { "\($0)"}
        let date_string = "\(splitDate[2])-\(splitDate[1])-\(splitDate[0])"
        return date_string
    } // end of convertDate

} // end of class ConversionService

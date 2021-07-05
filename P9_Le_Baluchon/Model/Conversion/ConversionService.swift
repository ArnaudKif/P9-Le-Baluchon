//
//  ConversionService.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 21/06/2021.
//

import Foundation

class ConversionService {

    // MARK: - Singleton pattern
    static var shared = ConversionService()
    private init() {}
    
    // MARK: - Attribute & init
    private var task : URLSessionDataTask?
    private var conversionSession = URLSession(configuration: .default)
    var rateArray: [Double] = [1.186669, 1.584021, 1.470579, 1.097681, 7.674545, 0.860127, 132.25722]
    
    init(conversionSession: URLSession) {
        self.conversionSession = conversionSession
    } // end of init
    
    // MARK: - Sending alert notification
    private func sendAlertNotification(message : String) {
        let alertName = Notification.Name("alertDisplay")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    } // end of sendAlertNotification
    
    // MARK: - URL & Request configuration
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
    
    // MARK: - recovery and processing of rates
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
                ConversionService.shared.rateArray.removeAll()
                ConversionService.shared.rateArray.append(searchRate.rates.USD)
                ConversionService.shared.rateArray.append(searchRate.rates.AUD)
                ConversionService.shared.rateArray.append(searchRate.rates.CAD)
                ConversionService.shared.rateArray.append(searchRate.rates.CHF)
                ConversionService.shared.rateArray.append(searchRate.rates.CNY)
                ConversionService.shared.rateArray.append(searchRate.rates.GBP)
                ConversionService.shared.rateArray.append(searchRate.rates.JPY)
            }
        }
        task?.resume()
    } // end of func getRates
    
    // MARK: - data conversion and management
    func euroToDollarConvert(euroNumber: Double, index: Int) -> String {
        let finalRate: Double = ConversionService.shared.rateArray[index]
        let dollarNumber: Double = euroNumber * finalRate
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

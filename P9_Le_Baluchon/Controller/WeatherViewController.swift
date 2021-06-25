//
//  WeatherViewController.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

// MARK - Outlet
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var descriptionWeather: UILabel!
    @IBOutlet weak var update: UILabel!

    @IBOutlet weak var NYiconWeather: UIImageView!
    @IBOutlet weak var NYdegree: UILabel!
    @IBOutlet weak var NYdescriptionWeather: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alertDisplay"), object: nil)

        searchButtonTaped()

    } // end of viewDidLoad

    @objc private func presentAlert(notification : Notification) {
        guard let alertInfo = notification.userInfo!["message"] as? String else { return }

        let alert = UIAlertController(title: "Erreur", message: alertInfo, preferredStyle: .alert)
        let action  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }



    private func NYWeatherUpdate() {
        WeatherService.shared.getWeather(city: "new york") { (true, searchWeather) in
            if true, let NYWeather = searchWeather {
                let NYdegreeInt = Int(NYWeather.main.temp)
                self.NYdegree.text = "\(NYdegreeInt)°C"
                self.NYiconWeather.image = UIImage(named: "\(NYWeather.weather[0].icon).png")
                self.NYdescriptionWeather.text = NYWeather.weather[0].description
            }
        }
    } // end of NYWeatherUpdate
    


    private func displayWeatherInfo(weather: AllWeather) {
        let degreeInt = Int(weather.main.temp)
        degree.text = "\(degreeInt)°C"
        update.text = WeatherService.shared.convertDate(unix: weather.dt)
        iconWeather.image = UIImage(named: "\(weather.weather[0].icon).png")
        descriptionWeather.text = weather.weather[0].description

    } // end fo displayWeatherInfo


    @IBAction func searchButtonTaped() {
        city.resignFirstResponder()
        WeatherService.shared.getWeather(city: city.text!) { (true, searchWeather) in
            if true, let resultWeather = searchWeather {
                self.displayWeatherInfo(weather: resultWeather)
                self.NYWeatherUpdate()
            }
        }
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        city.resignFirstResponder()
        searchButtonTaped()
    } // end of dismissKeyboard

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        city.resignFirstResponder()
        searchButtonTaped()
        return true
    } // end of textFieldShouldReturn

}

//
//  WeatherViewController.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var descriptionWeather: UILabel!
    @IBOutlet weak var update: UILabel!

    @IBOutlet weak var NYiconWeather: UIImageView!
    @IBOutlet weak var NYdegree: UILabel!
    @IBOutlet weak var NYdescriptionWeather: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchCityButton: UIButton!

// MARK: - viewDidLoad & presentAlert
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alertDisplay"), object: nil)
        activityIndicator.isHidden = true
        searchButtonTaped()
    } // end of viewDidLoad

    @objc private func presentAlert(notification : Notification) {
        guard let alertInfo = notification.userInfo!["message"] as? String else { return }

        let alert = UIAlertController(title: "Erreur", message: alertInfo, preferredStyle: .alert)
        let action  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    } // end of presentAlert

    // MARK: - keyboard control
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        city.resignFirstResponder()
        searchButtonTaped()
    } // end of dismissKeyboard

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        city.resignFirstResponder()
        searchButtonTaped()
        return true
    } // end of textFieldShouldReturn

    // MARK: - IBAction : button control
    @IBAction func searchButtonTaped() {
        toggleActivityIndicator(shown: true)
        city.resignFirstResponder()
        WeatherService.shared.getWeather(city: city.text!) { (true, searchWeather) in
            self.toggleActivityIndicator(shown: false)
            if true, let resultWeather = searchWeather {
                self.displayWeatherInfo(weather: resultWeather)
                self.NYWeatherUpdate()
            }
        }
    }// end of searchButtonTaped

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

    private func toggleActivityIndicator(shown: Bool) {
        searchCityButton.isHidden = shown
        activityIndicator.isHidden = !shown
    } // end of toggleActivityIndicator

} // end of WeatherViewController

//
//  ChangeViewController.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {

// MARK: - IBOutlet
    @IBOutlet weak var upTextField: UITextField!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var convertButton: UIButton!

// MARK: - viewDidLoad & presentAlert
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alertDisplay"), object: nil)
        activityIndicator.isHidden = true
    } // end of viewDidLoad

    @objc func presentAlert(notification : Notification) {
        guard let alertInfo = notification.userInfo!["message"] as? String else { return }

        let alert = UIAlertController(title: "Erreur", message: alertInfo, preferredStyle: .alert)
        let action  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    } // end of presentAlert

// MARK: - keyboard control

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        upTextField.resignFirstResponder()
        updateResultLabelText()
        return true
    } // end of textFieldShouldReturn

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        upTextField.resignFirstResponder()
        updateResultLabelText()
    } // end of dismissKeyboard

// MARK: - IBAction : button control
    @IBAction func ConversionButton(_ sender: Any) {
        upTextField.resignFirstResponder()
        updateResultLabelText()
    } // end of ConversionButton

    private func updateResultLabelText() {
        toggleActivityIndicator(shown: true)
        let euroNumber: Double = ConversionService.shared.stringToDouble(textToTransform: upTextField.text!)

        ConversionService.shared.getRates { (true, searchRate) in
            self.toggleActivityIndicator(shown: false)
            self.downLabel.text =  "\(ConversionService.shared.euroToDollarConvert(euroNumber: euroNumber,rate: searchRate!.rates.USD))"
            let date = ConversionService.shared.convertDate(date: searchRate!.date)
            let rate = searchRate!.rates.USD
            self.rateLabel.text = "Taux de conversion : 1€ = \(rate)$ \nMise à jour le \(date)"
        }
    } // end of updateResultLabelText

    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
    } // end of toggleActivityIndicator

} // end of ConversionViewController

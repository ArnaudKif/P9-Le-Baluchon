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
    @IBOutlet weak var ratePickerView: UIPickerView!

//    var dailyRate
    
// MARK: - viewDidLoad & presentAlert
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alertDisplay"), object: nil)
        activityIndicator.isHidden = true
        self.rateLabel.text = "Appuyer sur Convertir pour mettre à jour le taux de conversion"
    } // end of viewDidLoad

    @objc private func presentAlert(notification : Notification) {
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
        ConversionService.shared.getRates { (true, searchRate) in
            let date = ConversionService.shared.convertDate(date: searchRate!.date)
            let euroNumber: Double = ConversionService.shared.stringToDouble(textToTransform: self.upTextField.text!)

            let indexRate = self.ratePickerView.selectedRow(inComponent: 0)
            self.downLabel.text =  "\(ConversionService.shared.euroToDollarConvert(euroNumber: euroNumber,index: indexRate))"
            let rate = ConversionService.shared.rateArray[indexRate]
        let monnaie = rateChoice[indexRate]
            self.rateLabel.text = "Taux de conversion : \n1€ = \(rate) \(monnaie) \nMise à jour le \(date)"
            self.toggleActivityIndicator(shown: false)
        }
    } // end of updateResultLabelText

    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
    } // end of toggleActivityIndicator

} // end of ConversionViewController

// MARK: - PickerView Components
extension ConversionViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rateChoice.count
    }

    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rateChoice[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateResultLabelText()
        }
}

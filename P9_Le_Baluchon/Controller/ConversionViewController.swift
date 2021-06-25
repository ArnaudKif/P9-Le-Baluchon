//
//  ChangeViewController.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var upTextField: UITextField!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alertDisplay"), object: nil)
    }

    @objc func presentAlert(notification : Notification) {
        guard let alertInfo = notification.userInfo!["message"] as? String else { return }

        let alert = UIAlertController(title: "Erreur", message: alertInfo, preferredStyle: .alert)
        let action  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        upTextField.resignFirstResponder()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        upTextField.resignFirstResponder()
        updateResultLabelText()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        upTextField.resignFirstResponder()
        updateResultLabelText()
    }

    private func updateResultLabelText() {
        let euroNumber: Double = ConversionService.shared.stringToDouble(textToTransform: upTextField.text!)

        ConversionService.shared.getRates { (true, searchRate) in
            self.downLabel.text =  "\(ConversionService.shared.euroToDollarConvert(euroNumber: euroNumber,rate: searchRate!.rates.USD))"
            let date = ConversionService.shared.convertDate(date: searchRate!.date)
            let rate = searchRate!.rates.USD
            self.rateLabel.text = "Taux de conversion : 1€ = \(rate)$ \nMise à jour le \(date)"
        }
    }


}

//extension ConversionViewController: UIPickerViewDataSource, UIDocumentPickerDelegate {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return currencyList.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return currencyList[row]
//    }
//
//}

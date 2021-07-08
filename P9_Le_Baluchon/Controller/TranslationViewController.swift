//
//  TraductionViewController.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import UIKit

class TranslationViewController: UIViewController, UITextFieldDelegate {

    // MARK: - PickerView elements
    let translateLanguage = ["Anglais", "Français", "Allemand", "Espagnol"]

    // MARK: - IBOutlet
    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var LanguagepickerView: UIPickerView!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alertDisplay"), object: nil)
        activityIndicator.isHidden = true
    }

    @objc private func presentAlert(notification : Notification) {
        guard let alertInfo = notification.userInfo!["message"] as? String else { return }
        let alert = UIAlertController(title: "Erreur", message: alertInfo, preferredStyle: .alert)
        let action  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - keyboard control
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textToTranslate.resignFirstResponder()
        return true
    } // end of textFieldShouldReturn

    // MARK: - IBAction : button control
    @IBAction func translateButton(_ sender: Any) {
        translateButtonTaped()
    }

    private func translateButtonTaped() {
        toggleActivityIndicator(shown: true)
        let text = textToTranslate.text!
        let index = LanguagepickerView.selectedRow(inComponent: 0)

        TranslationService.shared.getTranslation(languageIndex: index , textToTranslate: text) { (true, traductedResponse) in
            self.toggleActivityIndicator(shown: false)
            self.translatedText.text = traductedResponse?.data.translations[0].translatedText
        }
    }

    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

// MARK: - PickerView Components
extension TranslationViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return translateLanguage.count
    }

    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return translateLanguage[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        translateButtonTaped()
    }
}

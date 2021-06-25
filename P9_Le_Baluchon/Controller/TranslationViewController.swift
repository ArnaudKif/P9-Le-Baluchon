//
//  TraductionViewController.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import UIKit

class TranslationViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var translatedText: UILabel!

    @IBOutlet weak var LanguagepickerView: UIPickerView!


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textToTranslate.resignFirstResponder()
        return true
    } // end of textFieldShouldReturn


    @IBAction func translateButton(_ sender: Any) {
        translateButtonTaped()
    }

    private func translateButtonTaped() {
        let text = textToTranslate.text!
        let index = LanguagepickerView.selectedRow(inComponent: 0)

        TranslationService.shared.getTranslation(languageIndex: index , textToTranslate: text) { (true, traductedResponse) in
            self.translatedText.text = traductedResponse?.data.translations[0].translatedText

        }

    }

}

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

}

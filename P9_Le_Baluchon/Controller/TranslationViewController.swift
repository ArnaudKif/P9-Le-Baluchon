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
    
    @IBAction func dissmisKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
        translateButtonTaped()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textToTranslate.resignFirstResponder()
        translateButtonTaped()
        return true
    } // end of textFieldShouldReturn


    @IBAction func translateButton(_ sender: Any) {
        translateButtonTaped()
    }

    private func translateButtonTaped() {
        let text = textToTranslate.text!
        TranslationService.shared.getTranslation(textToTranslate: text) { (true, traductedResponse) in
            self.translatedText.text = traductedResponse?.data.translations[0].translatedText

        }

    }


}

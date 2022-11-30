//
//  FeedbackVC.swift
//  Duuliye
//
//  Created by Developer on 13/09/22.
//

import UIKit

class FeedbackVC: UIViewController {

    @IBOutlet var txtFeedback: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFeedback.delegate = self
        txtFeedback.text = "Feedback"
        txtFeedback.textColor = UIColor.lightGray
        
    txtFeedback.layer.borderColor = UIColor(red: 102/255, green: 188/255, blue: 55/255, alpha: 1.0).cgColor
    txtFeedback.layer.cornerRadius = 12.0
    txtFeedback.clipsToBounds = true
    txtFeedback.borderWidth = 1.5

        // Do any additional setup after loading the view.
    }

    @IBAction func sendNowTapped(_ sender: Any) {
        if !txtFeedback.text.isEmpty && txtFeedback.text != "Feedback"{
            api_Feedback()
        }
    }
    @IBAction func backTApped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedbackVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Feedback"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Feedback"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
}

extension FeedbackVC{
    func api_Feedback()
    {
        if isConnectedToNetwork() {
            
            var strUserId = ""
            var strToken = ""
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
            }
            let param:[String:Any] = [
                "token" : strToken,
                "user_id" : strUserId,
                "message" : txtFeedback.text ?? ""
            ]
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIsave_feedback)", service: APIsave_feedback, parameters: param as NSDictionary, keyname: APIsave_feedback as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        
                        if data["success"] as! Bool{
                            showMessage("Feedback sent Successfully")
                            self.navigationController?.popViewController(animated: true)
                        }
                       
                        
                       
                    }
                }
            }
        }
    }
}


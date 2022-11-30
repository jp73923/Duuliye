//
//  UpdateProfileVC.swift
//  Duuliye
//
//  Created by Developer on 13/09/22.
//

import UIKit
import SwiftyJSON

class UpdateProfileVC: UIViewController {
    
    var userDIc = [String:String]()

    @IBOutlet weak var btnUpdateNow: UIButton!
    @IBOutlet weak var txtEnglish: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtName.delegate = self
        txtLastName.delegate = self
        txtContactNo.delegate = self
        txtCountry.delegate = self
        txtEnglish.delegate = self
        
        txtName.addBottomBorder(.darkGray)
        txtLastName.addBottomBorder(.darkGray)
        txtContactNo.addBottomBorder(.darkGray)
        txtCountry.addBottomBorder(.darkGray)
        txtEnglish.addBottomBorder(.darkGray)
        
        txtName.leftImageWIthPadding(image: UIImage(named: "ic_selected_user"), color: .green)
        txtLastName.leftImageWIthPadding(image: UIImage(named: "ic_selected_user"), color: .green)
        txtContactNo.leftImageWIthPadding(image: UIImage(named: "ic_otp"), color: .green)
        txtCountry.leftImageWIthPadding(image: UIImage(named: "ic_plane_to"), color:  .green)
        txtEnglish.leftImageWIthPadding(image: UIImage(named: "ic_otp"), color: .green)
        
        
        AddRightView(strText: "First Name", txtFld: txtName)
        AddRightView(strText: "Last Name", txtFld: txtLastName)
        AddRightView(strText: "Phone", txtFld: txtContactNo)
        AddRightView(strText: "Country", txtFld: txtCountry)
        AddRightView(strText: "Language", txtFld: txtEnglish)
        
        txtName.text = "\(userDIc["first_name"] ?? "")"
        txtLastName.text = "\(self.userDIc["last_name"] ?? "")"
        txtContactNo.text = "\(self.userDIc["country_code"] ?? "") \(self.userDIc["phone"] ?? "")"
        txtCountry.text = "\(self.userDIc["country_name"] ?? "")"
        txtEnglish.text = "Language - English"
        
        txtEnglish.isUserInteractionEnabled = false
        txtContactNo.isUserInteractionEnabled = false
        txtCountry.isUserInteractionEnabled = false
        

        
        // Do any additional setup after loading the view.
    }
    
    func AddRightView(strText: String, txtFld: UITextField){
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.text = strText
        label.textColor = UIColor.darkGray
        label.textAlignment = .center

        rightView.addSubview(label)
       
        txtFld.rightView = rightView
        txtFld.rightViewMode = .always
    }
    
    @IBAction func updateNowTapped(_ sender: Any) {
        api_updateProfile()
    }
    
    @IBAction func backTapped(_ sender: Any) {
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
extension UpdateProfileVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addBottomBorder(.green)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addBottomBorder(.darkGray)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //print(#function,prospectiveText)
        
        let numberSet = CharacterSet.decimalDigits
                    if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                        return false
                    }
        
        return range.location < 10
    
    }
}

//MARK: - API Calling Methods
extension UpdateProfileVC {
    func api_updateProfile()
    {
        /*"token" : "XlXAEsyjYTUQGt2T",
         "user_id" : "62a3247615d8ee628c91c00c",
         "first_name" : "",
         "last_name" : "",
         "country_name" : "",
         "country_code" : ""*/
        var strUserId = ""
        var strToken = ""
        let strCountryCode = "\(self.userDIc["country_code"] ?? "")"
        
        if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
            strUserId  = objUser.userid ?? "0"
            strToken = objUser.token ?? ""
        }
       
        
        
        if isConnectedToNetwork() {
            
            let param:[String:Any] = [
                "token" : strToken,
                "user_id" : strUserId,
                "first_name" : txtName.text!,
                "last_name": txtLastName.text!,
                "country_name": txtCountry.text!,
                "country_code": strCountryCode
            ]
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIUpdateUserData)", service: APIUpdateUserData, parameters: param as NSDictionary, keyname: APIUpdateUserData as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        UserDefaultManager.setBooleanToUserDefaults(value: true, key: kIsLoggedIn)
                            if let userData = data["user"] as? [String:Any] {
                                let uData = ClassUser.init(json: JSON(userData))
                                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: uData, key: kUserInfo)
                            }
                        
                        self.navigationController?.popViewController(animated: true)
                        
                       
                    }
                }
            }
        }
    }
}

//
//  VerifyVC.swift
//  Duuliye
//
//  Created by Jay on 02/06/22.
//

import UIKit
import SwiftyJSON

class VerifyVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var btnMobile: UIButton!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!

    @IBOutlet var txtOTP: [UITextField]!
    //MARK: - Global Variables
    var strMobileNo:String = ""
    var isSuccess = Bool()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        print(isSuccess)
        self.btnMobile.setTitle(strMobileNo, for: UIControl.State.normal)
            }
    
    override func viewDidAppear(_ animated: Bool) {
        txt1.becomeFirstResponder()

    }
    
    //MARK: - Custom Functions
    func validation() {
        //let codeadded = "\(txt1.text!)\(txt2.text!)\(txt3.text!)\(txt4.text!)"
        if txt1.text!.isEmpty || txt2.text!.isEmpty || txt3.text!.isEmpty || txt4.text!.isEmpty{
            showMessage(EnterOTP)
        } else {
           // print("Proper")
        self.api_VerifyPIN()
        }
    }
    func setupUI() {
        self.txt1.delegate = self
        self.txt2.delegate = self
        self.txt3.delegate = self
        self.txt4.delegate = self
        
        if #available(iOS 12.0, *) {
            self.txt1.textContentType = .oneTimeCode
            self.txt2.textContentType = .oneTimeCode
            self.txt3.textContentType = .oneTimeCode
            self.txt4.textContentType = .oneTimeCode
                } else {
                    // Fallback on earlier versions
                }
        
        self.txt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        self.txt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        self.txt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        self.txt4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    //MARK: - IBActions
    @IBAction func btnEditMobileNo_Clk(_ sender: UIButton) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
    @IBAction func btnContinue_Clk(_ sender: UIButton) {
        self.validation()
    }
    @IBAction func btnBack(_ sender: Any) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension VerifyVC:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        let updatedText = textField.text!.replacingCharacters(in: Range(range, in: textField.text!)!, with: string)
                print(updatedText)
        
        if !updatedText.isEmpty{
            if let idx = txtOTP.firstIndex(where: { $0.isFirstResponder }) {
                if txtOTP[idx].text!.isEmpty{
                    
                    txtOTP[idx].text = updatedText
                    
                }
                
                if idx != 3 {
                    if textField.text!.count <= 1 {
                        txtOTP[idx + 1].becomeFirstResponder()
                    }
                }
                else if idx == 3{
                    txtOTP[3].resignFirstResponder()
                }
                
            }
                }

        
        
        return newLength <= 1
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
        {
          
            if textField.tag == 4{
                if !textField.text!.isEmpty{
             
                    txt4.text = String(textField.text![textField.text!.index(before: textField.text!.endIndex)])
                }
            }
            // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
            return true
        }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count==1 {
            switch textField{
            case txt1:
                txt2.becomeFirstResponder()
            case txt2:
                txt3.becomeFirstResponder()
            case txt3:
                txt4.becomeFirstResponder()
            case txt4:
                txt4.resignFirstResponder()
            default:
                break
            }
        } else {
            switch textField{
            case txt2:
                txt1.becomeFirstResponder()
            case txt3:
                txt2.becomeFirstResponder()
            case txt4:
                txt3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt4{
            self.validation()
        }
    }
}

//MARK: - API Calling Methods
extension VerifyVC {
    func api_VerifyPIN()
    {
        if isConnectedToNetwork() {
            let param:[String:Any] = [
                "pincode" : "\(txt1.text!)\(txt2.text!)\(txt3.text!)\(txt4.text!)",
                "phone" : strMobileNo,
                "device_token" : "DJFIJSIGJISJFIGJISJFGJSIDFJGIDJIFGIPOOW5PONBNSTIRHGISHJGIHTIHWHSHH]SG]HSGPSP-PRPT"
            ]
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIVerifyPIN)", service: APIVerifyPIN, parameters: param as NSDictionary, keyname: APILogin as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        print(#function,data)
                        if data["success"] as! Bool{
                        if data["type"] as! Int == 1{
                        UserDefaultManager.setBooleanToUserDefaults(value: true, key: kIsLoggedIn)
                            if let userData = data["user"] as? [String:Any] {
                                let uData = ClassUser.init(json: JSON(userData))
                                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: uData, key: kUserInfo)
                            }
                            UserDefaults.standard.set(self.strMobileNo.components(separatedBy: " ")[0] , forKey: "COUNTRYCODE")
                        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idTabbarVC)
                        APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
                        APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
                        APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
                        APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
                        APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
                        APP_DELEGATE.window?.makeKeyAndVisible()
                        }
                        else{
                            let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idSignUpVC) as! SignUpVC
                            vc.strMobileNo = self.strMobileNo
                            APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                        }
                        }
                        else{
                            hideLoaderHUD()
                            showMessage(data["message"] as! String)
                        }
                    }
                }
            }
        }
    }
}


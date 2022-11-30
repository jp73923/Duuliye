//
//  SignUpVC.swift
//  Duuliye
//
//  Created by Developer on 09/06/22.
//

import UIKit
import SwiftyJSON

class SignUpVC: UIViewController {

    @IBOutlet weak var txtPassport: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    
    //MARK: - Global Variables
    var strMobileNo:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFullName.delegate = self
        
        txtPassport.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setBottomBorders()
    }
    
    func setBottomBorders(){
        txtFullName.addBottomBorder(.darkGray)
        
        txtPassport.addBottomBorder(.darkGray)
    }
    
    @IBAction func saveClick(_ sender: Any) {
        
        if validateTxtFieldLength(txtFullName, withMessage: EnterFullname) && validateTxtFieldLength(txtPassport, withMessage: EnterPassport) {
            self.view.endEditing(true)
            
            api_Register()
            
        }
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


extension SignUpVC{
    func api_Register()
    {
      if isConnectedToNetwork() {
          let param:[String:Any] = [
              "phone":strMobileNo,
              "name" : self.txtFullName.text ?? "",
              "device_token" : "DJFIJSIGJISJFIGJISJFGJSIDFJGIDJIFGIPOOW5PONBNSTIRHGISHJGIHTIHWHSHH]SG]HSGPSP-PRPT",
              "passport" : self.txtPassport.text ?? ""
          ]
          HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIRegister)", service: APIRegister, parameters: param as NSDictionary, keyname: APIRegister as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
              if error != nil
              {
                  showMessage(error.debugDescription)
                  return
              }
              else if let data = responseDict
              {
                  if let ata = data as? NSDictionary {
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
//                      let objUser = ClassUser.init(json: JSON(ata))
//                      if let userId = data.value(forKey: "user_id") as? Int {
//                          UserDefaultManager.setStringToUserDefaults(value: "\(userId)", key: kAppUserId)
//                      }
//                      UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: objUser, key: UD_UserData)
//                    //  showMessage("\(objUser.loginotp ?? 0)")
//                      let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idVerificationVC) as! VerificationVC
//                      vc.OTP = objUser.loginotp ?? 0
//                      APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
  //                }
              }
                  }
          }
      }
  }
}

}



extension SignUpVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
       setBottomBorders()
        textField.addBottomBorder(.green)
    }
}

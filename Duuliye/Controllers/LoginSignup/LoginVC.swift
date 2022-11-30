//
//  ViewController.swift
//  Duuliye
//
//  Created by Jay on 02/06/22.
//

import UIKit
import SwiftyJSON
import SDWebImage

class LoginVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var imgFLag: UIImageView!
    @IBOutlet weak var baseVIew: UIView!
    
    @IBOutlet weak var btnCode: UIButton!
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMobile.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        baseVIew.addGestureRecognizer(tap)
        
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        
        UserDefaultManager.setBooleanToUserDefaults(value: false, key: kIsLoggedIn)
           
        let uData = ClassUser.init(json: JSON([String:Any]()))
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: uData, key: kUserInfo)
            
            UserDefaults.standard.set("" , forKey: "COUNTRYCODE")
        
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idTabbarVC)
        APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
        APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
        APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
        APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
        APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
        APP_DELEGATE.window?.makeKeyAndVisible()
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print(#function)
        
        let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idCountryListVC) as! CountryListVC
        
        vc.CallBackToSetVallue = { selectedCode, imgFLag in
           print(selectedCode, imgFLag)
            self.btnCode.setTitle(selectedCode, for: .normal)
            let strUrl = (imgFLag).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            self.imgFLag.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
        }
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func btnVerify_Clk(_ sender: UIButton) {
        if validateTxtFieldLength(txtMobile, withMessage: EnterMobile) {
            if validateEqualTxtFieldLength(txtMobile, lenght: btnCode
                                            .titleLabel?.text?.count == 4 ? 9 : 10, msg: EnterMobileLength){
            self.view.endEditing(true)
            self.api_Login()
            }else{
                showMessage("Please Enter correct No of Digits ")
            }
            
//            let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idSignUpVC) as! SignUpVC
//            vc.strMobileNo = "+91 " + (self.txtMobile.text ?? "")
//            APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
            
        /*    let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idVerifyVC) as! VerifyVC
            vc.isSuccess = true
            vc.strMobileNo = "+91 " + (self.txtMobile.text ?? "")
            APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)*/
        }
    }
}

//MARK: - API Calling Methods
extension LoginVC {
    func api_Login()
    {
        if isConnectedToNetwork() {
            let param:[String:Any] = [
                "phone" : (btnCode.titleLabel!.text!) + " " + (self.txtMobile.text ?? "")
            ]
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APILogin)", service: APILogin, parameters: param as NSDictionary, keyname: APILogin as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        
                        let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idVerifyVC) as! VerifyVC
                        vc.isSuccess = data["success"] as! Bool
                        
                        vc.strMobileNo = (self.btnCode.titleLabel!.text!) + " " + (self.txtMobile.text ?? "")
                        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                        
                       
                    }
                }
            }
        }
    }
}

extension LoginVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //print(#function,prospectiveText)
        
        let numberSet = CharacterSet.decimalDigits
                    if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                        return false
                    }
        
        return range.location < 10
    
    }
}


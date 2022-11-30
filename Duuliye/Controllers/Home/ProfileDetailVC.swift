//
//  ProfileDetailVC.swift
//  Duuliye
//
//  Created by Developer on 13/09/22.
//

import UIKit

class ProfileDetailVC: UIViewController {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInitials: UILabel!
    
    var userDic = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        api_ProfileDetail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateProfileTApped(_ sender: Any) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idUpdateProfileVC) as! UpdateProfileVC
        vc.userDIc = userDic
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
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
extension ProfileDetailVC{
    func api_ProfileDetail()
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
                
            ]
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetUserData)", service: APIGetUserData, parameters: param as NSDictionary, keyname: APIGetUserData as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        
                        if data["success"] as! Bool{
                            
                            /* "user": {
                             "_id": "62a3247615d8ee628c91c00c",
                             "first_name": "Asma",
                             "last_name": "Godil",
                             "country_name": "India",
                             "country_code": "+91",
                             "phone": "9106692317"
                         }*/
                            
                            
                            self.userDic = data["user"] as! [String:String]
                            self.lblName.text = "\(self.userDic["first_name"] ?? "") \(self.userDic["last_name"] ?? "")"
                            self.lblFullName.text = "\(self.userDic["first_name"] ?? "") \(self.userDic["last_name"] ?? "")"
                            self.lblContactNo.text = "\(self.userDic["country_code"] ?? "") \(self.userDic["phone"] ?? "")"
                            self.lblCity.text = "\(self.userDic["country_name"] ?? "")"
                            
                            let initials = "\(self.lblFullName.text ?? "")".getAcronyms()
                            //"\(self.lblFullName.text)".components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                            
                            self.lblInitials.text = initials
                            
                            print(initials)
                            print(#function,"\(self.lblFullName.text ?? "")".getAcronyms())
                            
                            self.lblInitials.layer.cornerRadius = self.lblInitials.frame.height/2
                            self.lblInitials.clipsToBounds = true
                            
                            
                        }
                       
                        
                       
                    }
                }
            }
        }
    }
}


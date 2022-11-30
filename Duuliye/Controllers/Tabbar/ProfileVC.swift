//
//  ProfileVC.swift
//  Duuliye
//
//  Created by Jay on 05/06/22.
//

import UIKit
class cellProfile: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
}
class ProfileVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var tblProfile: UITableView!
    
    //MARK: - Global Varaibles
    var arroptions = [["name":"My account","icon":"ic_unselected_user"],["name":"Feedback","icon":"ic_privacy_safety"],["name":"Share Application","icon":"share"],["name":"Logout","icon":"logout"],["name":"Remove Account","icon":"delete_Account"]]
    //var arroptions = [["name":"Manage my account","icon":"ic_unselected_user"],["name":"Privacy and safety","icon":"ic_privacy_safety"],["name":"Links","icon":"share"],["name":"Codes","icon":"ic_otp"]]

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblProfile.separatorColor = UIColor.clear
        
        if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
            if (objUser.firstName ?? "") == "" {
                lblName.text = "Guest"
                arroptions = [["name":"Feedback","icon":"ic_privacy_safety"],["name":"Share Application","icon":"share"]]
                lblContactNo.text = ""
            } else {
                lblName.text  = (objUser.firstName ?? "") + " " + (objUser.lastName ?? "")
                lblContactNo.text = objUser.phone ?? ""
            }
        }
        
    }
}
//MARK: - UITableViewDataSource,UITableViewDelegate
extension ProfileVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arroptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblProfile.dequeueReusableCell(withIdentifier: "cellProfile") as! cellProfile
        cell.lblName.text = self.arroptions[indexPath.row]["name"] ?? ""
        cell.imgProfile.image = UIImage.init(named: self.arroptions[indexPath.row]["icon"] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
            if (objUser.firstName ?? "") == "" {
                if indexPath.row == 0{
                    let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idFeedbackVC) as! FeedbackVC
                    APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                } else {
                    let items = [URL(string: "https://www.apple.com")!]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    present(ac, animated: true)
                }
            } else {
                if indexPath.row == 1{
                    let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idFeedbackVC) as! FeedbackVC
                    APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                } else if indexPath.row == 0{
                    let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idProfileDetailVC) as! ProfileDetailVC
                    APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                } else if indexPath.row == 3 || indexPath.row == 4 {
                    api_logoutORRemoveAccount(tag: indexPath.row)
                } else{
                    let items = [URL(string: "https://www.apple.com")!]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    present(ac, animated: true)
                }
            }
        }
    }
}

extension ProfileVC{
    func api_logoutORRemoveAccount(tag: Int)
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
                "user_id" : strUserId
            ]
            
            var ApiUrl = APIlogout
            if tag == 4 {
                ApiUrl = APIDeleteUser
            }
            
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + ApiUrl)", service: ApiUrl, parameters: param as NSDictionary, keyname: APIGetCompanyList as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil {
                    showMessage(error.debugDescription)
                    return
                } else if let data = responseDict {
                    if let data = data as? NSDictionary {
                        if data["success"] as! Bool{
                            DispatchQueue.main.async {
                                self.removeAllUserDefaultsKeyValues()
                                let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idLoginVC)
                                APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
                                APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
                                APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
                                APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
                                APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
                                APP_DELEGATE.window?.makeKeyAndVisible()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeAllUserDefaultsKeyValues() {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}


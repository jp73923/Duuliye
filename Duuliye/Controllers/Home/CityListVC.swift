//
//  CityListVC.swift
//  Duuliye
//
//  Created by Jay on 03/06/22.
//

import UIKit
import SwiftyJSON
class cellCity: UITableViewCell {
    
    
    @IBOutlet weak var llblCode: UILabel!
    @IBOutlet weak var lblAirport: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
}
class CityListVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tblCityList: UITableView!
    
    
    @IBOutlet weak var txtSearch: UISearchBar!
    var arrCityList = [CityList]()
    var arrFilterCityList = [CityList]()
    var CallBackToSetVallue :((_ strTitle: String)-> Void)!
    var strSelectedCity = ""

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCityList.delegate = self
        tblCityList.dataSource = self
        
        tblCityList.separatorColor = .darkGray
        tblCityList.separatorStyle = .singleLine
      //  self.api_GetCity()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrFilterCityList = arrCityList
     //   api_GetCityList()
    }
    
    //MARK: - IBActions
    @IBAction func btnBack_Clk(_ sender: UIButton) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
    
    func imageFromView(myView: UIView) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, false, UIScreen.main.scale)
        myView.drawHierarchy(in: myView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
//MARK: - UITableViewDataSource,UITableViewDelegate
extension CityListVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterCityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCityList.dequeueReusableCell(withIdentifier: "cellCity") as! cellCity
        
        cell.llblCode.text = arrFilterCityList[indexPath.item].code
        
        cell.llblCode.cornerRadius = cell.llblCode.frame.height/2
        cell.llblCode.clipsToBounds = true
        
        cell.lblCityName.text = arrFilterCityList[indexPath.item].cityName
        cell.lblAirport.text = arrFilterCityList[indexPath.item].airportName
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedValue = (arrFilterCityList[indexPath.row].cityName!) + ", " + (arrFilterCityList[indexPath.row].code!)
        
        if strSelectedCity != selectedValue{
        CallBackToSetVallue(selectedValue)
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
        }
        else{
            showMessage("This City is Already Selected")
          //  showAlertOnKeyWindow(title: "WRONG SELEECTION", strMessage: "This City is Already Selected", time: 1.5, completion:nil)
        }
    }
}

//MARK: - API Calling Methods
extension CityListVC {
    func api_GetCityList()
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
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetCityList)", service: APIGetCityList, parameters: param as NSDictionary, keyname: APIGetCityList as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        if data["success"] as! Bool{
                            print(data)
                            
                            if let cityData = data["data"] as? NSArray {
                                for i in 0 ..< (cityData.count) {
                                    if let dict = cityData.object(at: i) as? NSDictionary {
                                        self.arrCityList.append(CityList.init(json: JSON(dict)))
                                    }
                                }
                            }
                            print(self.arrCityList.count)
                            
                            self.tblCityList.reloadData()
                               
                            
                        
                       
                        
                        }
                        
                    }
                }
            }
        }
    }
    
    func api_cities()
    {
        if isConnectedToNetwork() {
            let param:[String:Any] = [
                "type" : "1"
            ]
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetCities)", service: APIGetCities, parameters: param as NSDictionary, keyname: APIGetCities as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        
                    }
                }
            }
        }
    }
}


extension CityListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
        
        let updatedText = searchBar.text!.replacingCharacters(in: Range(range, in: searchBar.text!)!, with: text)
        
        if updatedText.count >= 1 {
            //  addCancel()
            if updatedText.count >= 2 {
                searchingFunctionality(text: updatedText)
            }
            else {
                arrFilterCityList = arrCityList
                tblCityList.reloadData()
            }
        }
        else {
            arrFilterCityList = arrCityList
            //   removeCancel()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchingFunctionality(text: String) {
        arrFilterCityList = arrCityList.filter({ ( ($0.id!).localizedCaseInsensitiveContains(text) || ($0.cityName!).localizedCaseInsensitiveContains(text) || ($0.code!).localizedCaseInsensitiveContains(text) || ($0.airportName!).localizedCaseInsensitiveContains(text) ) }).map({ $0 })
        tblCityList.reloadData()
    }
}

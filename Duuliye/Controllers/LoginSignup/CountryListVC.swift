//
//  CountryListVC.swift
//  Duuliye
//
//  Created by Developer on 09/09/22.
//

import UIKit
import SDWebImage
import SwiftyJSON

class cellCountry: UITableViewCell {
    
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var llblCode: UILabel!
   
    @IBOutlet weak var lblCountryName: UILabel!
}

class CountryListVC: UIViewController {

    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tblCountry: UITableView!
    
    var arrCountryList = [CountryList]()
    var arrFilterCountryList = [CountryList]()
    var CallBackToSetVallue :((_ strcode: String, _ strFLag: String)-> Void)!
    var strSelectedCountry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblCountry.delegate = self
        tblCountry.dataSource = self
        
        tblCountry.separatorColor = .darkGray
        tblCountry.separatorStyle = .singleLine
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api_GetCountryList()
    }
    

    @IBAction func backTapped(_ sender: Any) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
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

//MARK: - UITableViewDataSource,UITableViewDelegate
extension CountryListVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterCountryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCountry.dequeueReusableCell(withIdentifier: "cellCountry") as! cellCountry
        
        cell.llblCode.text = arrFilterCountryList[indexPath.item].countrycode
        
        cell.llblCode.cornerRadius = cell.llblCode.frame.height/2
        cell.llblCode.clipsToBounds = true
        
        cell.lblCountryName.text = arrFilterCountryList[indexPath.item].name
        cell.imgFlag.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        let strUrl = (arrFilterCountryList[indexPath.row].flag!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.imgFlag.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedValue = (arrFilterCountryList[indexPath.row].countrycode!)
                CallBackToSetVallue(selectedValue,arrFilterCountryList[indexPath.row].flag!)
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
       
    }
}

//MARK: - API Calling Methods
extension CountryListVC {
    func api_GetCountryList()
    {
        if isConnectedToNetwork() {
        
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetCountryList)", service: APIGetCountryList, parameters: [String:Any]() as NSDictionary, keyname: APIGetCountryList as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                 //   if let data = data as? NSDictionary {
                        if data["success"] as! Bool{
                            print(data)
                            
                            if let cityData = data["data"] as? NSArray {
                                for i in 0 ..< (cityData.count) {
                                    if let dict = cityData.object(at: i) as? NSDictionary {
                                        self.arrCountryList.append(CountryList.init(json: JSON(dict)))
                                    }
                                }
                            }
                            self.arrFilterCountryList = self.arrCountryList
                            print(self.arrCountryList.count)
                            
                            self.tblCountry.reloadData()
                               
                            
                        
                       
                        
                        }
                        
                 //   }
                }
            }
        }
        else{
            print("nonet")
        }
    }
    
    func api_cities()
    {
        if isConnectedToNetwork() {
            let param:[String:Any] = [
                "type" : "1"
            ]
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetCities)", service: APIGetCities, parameters: param as NSDictionary, keyname: APILogin as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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


extension CountryListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
        
        let updatedText = searchBar.text!.replacingCharacters(in: Range(range, in: searchBar.text!)!, with: text)
        
        if updatedText.count >= 1 {
            //  addCancel()
            if updatedText.count >= 2 {
                searchingFunctionality(text: updatedText)
            }
            else {
                arrFilterCountryList = arrCountryList
                tblCountry.reloadData()
            }
        }
        else {
            arrFilterCountryList = arrCountryList
            //   removeCancel()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchingFunctionality(text: String) {
        arrFilterCountryList = arrCountryList.filter({ ( ($0.id!).localizedCaseInsensitiveContains(text) || ($0.name!).localizedCaseInsensitiveContains(text) || ($0.code!).localizedCaseInsensitiveContains(text) || ($0.countrycode!).localizedCaseInsensitiveContains(text) ) }).map({ $0 })
        tblCountry.reloadData()
    }
}



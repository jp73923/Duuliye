//
//  HomeVC.swift
//  Duuliye
//
//  Created by Jay on 03/06/22.
//

import UIKit
import PanModal
import IQDropDownTextField
import SwiftyJSON
import SDWebImage

class cellFlights: UITableViewCell {
    
    @IBOutlet weak var imgFlight: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblFromToCity: UILabel!
}
class HomeVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblnfants: UILabel!
    @IBOutlet weak var lblChild: UILabel!
    @IBOutlet weak var lblAdults: UILabel!
    @IBOutlet weak var lblToCity: UILabel!
    @IBOutlet weak var lblFromCity: UILabel!
    
    @IBOutlet weak var tblHomeFlights: UITableView!
    @IBOutlet weak var txtDate: IQDropDownTextField!
    @IBOutlet weak var lblDate: UILabel!
    
    var arrTodayFlights = [Flights]()
    var arrCityList = [CityList]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDate.dropDownMode = .datePicker
        self.txtDate.isOptionalDropDown = true
        self.txtDate.datePicker.minimumDate = Date()
        self.txtDate.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.lblDate.text = dateFormatter.string(from: Date())
        
        api_GetCityList()
        api_onlyTodayFlights()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - IBActions
    @IBAction func btnTakeOffCitySelection_Clk(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idCityListVC) as! CityListVC
        vc.arrCityList = arrCityList
        vc.strSelectedCity = lblFromCity.text!
        vc.CallBackToSetVallue = { selectedCity in
            print(#function,selectedCity)
            self.lblFromCity.text = selectedCity
        }
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLandingCitySelection_Clk(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idCityListVC) as! CityListVC
        vc.arrCityList = arrCityList
        vc.strSelectedCity = lblFromCity.text!
        vc.CallBackToSetVallue = { selectedCity in
            print(#function,selectedCity)
            self.lblToCity.text = selectedCity
        }
        
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
    @IBAction func btnPassengerSelection_Clk(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPassengerSelectionVC) as! PassengerSelectionVC
        vc.CallBackToSetPassengers = { adults, child, infants in
            self.lblAdults.text = "\(adults)"
            self.lblChild.text = "\(child)"
            self.lblnfants.text = "\(infants)"
        }
        self.presentPanModal(vc)
    }
    @IBAction func btnSearch_Clk(_ sender: UIButton) {
        if lblFromCity.text!.isEmpty || lblFromCity.text! == "Select departure"{
            //lblFromCity.shake()
            showMessage("Please Select FROM City")
        }
        else if lblToCity.text!.isEmpty || lblToCity.text! == "Select destination" {
            showMessage("Please Select TO City")
        }
        else{
           
            api_searchFlights()
        }
    }
}

//MARK: - API Calling Methods
extension HomeVC {
    func api_searchFlights()
    {
        if isConnectedToNetwork() {
            
            var strUserId = ""
            var strToken = ""
           
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let date = dateFormatter.date(from: self.lblDate.text!)
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "MM/dd/yyyy"
            let selectedDate = dateFormatter1.string(from: date ?? Date())
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
            }
            let param:[String:Any] = [
                "token" : strToken,
                "user_id" : strUserId,
                "adult": lblAdults.text ?? "",
                "child": lblChild.text ?? "",
                "infant": lblnfants.text ?? "",
                "date": selectedDate,
                "from_city": (lblFromCity.text!.components(separatedBy: ","))[0],
                "to_city": (lblToCity.text!.components(separatedBy: ","))[0]
            ]
            
            print(param as NSDictionary)
            
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APISearch)", service: APISearch, parameters: param as NSDictionary, keyname: APISearch as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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
                            
                            var arrFlightList = [Flights]()
                            
                            if let flightData = data["flights"] as? NSArray {
                                for i in 0 ..< (flightData.count) {
                                    if let dict = flightData.object(at: i) as? NSDictionary {
                                        arrFlightList.append(Flights.init(json: JSON(dict)))
                                    }
                                }
                            }
                            
                            let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idSearchListVC) as! SearrchResultVC
                            
                            vc.strTitle = (self.lblFromCity.text!).components(separatedBy: ",")[0] + " - " + (self.lblToCity.text!).components(separatedBy: ",")[0]
                            vc.arrFlights = arrFlightList
                           
                            APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)

                       
                       
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
    
    func api_onlyTodayFlights()
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
                "city": "Mogadishu"
                
            ]
            
            print(param as NSDictionary)
            
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIOnlyToday)", service: APIOnlyToday, parameters: param as NSDictionary, keyname: APIOnlyToday as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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
                            
                           
                            
                            if let flightData = data["flights"] as? NSArray {
                                for i in 0 ..< (flightData.count) {
                                    if let dict = flightData.object(at: i) as? NSDictionary {
                                        self.arrTodayFlights.append(Flights.init(json: JSON(dict)))
                                    }
                                }
                            }
                            self.tblHomeFlights.reloadData()

                       
                       
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
                            
                        //    self.tblCityList.reloadData()
                               
                            
                        
                       
                        
                        }
                        
                    }
                }
            }
        }
    }
}


//MARK: - UITableViewDataSource,UITableViewDelegate
extension HomeVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTodayFlights.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblHomeFlights.dequeueReusableCell(withIdentifier: "cellFlights") as! cellFlights
      
        
        
        cell.lblFromToCity.text = (arrTodayFlights[indexPath.row].fromcity ?? "") + " - " + (arrTodayFlights[indexPath.row].tocity ?? "")
        
       
        cell.imgFlight.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        let strUrl = (arrTodayFlights[indexPath.row].complogo!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.imgFlight.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_selected_flights"))
        cell.lblDepartureTime.text = arrTodayFlights[indexPath.item].departuretime
        cell.lblArrivalTime.text = arrTodayFlights[indexPath.item].arrivaltime
        cell.lblFare.text = (arrTodayFlights[indexPath.item].curency!.suffix(1) ) + " " + "\(arrTodayFlights[indexPath.item].fare ?? 0)"
        
        let dateFormatter = DateFormatter()
        //2022-06-21T08:30:00.000Z
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        let dtDate = dateFormatter.date(from: arrTodayFlights[indexPath.item].departuredate!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd,yyyy"
        cell.lblDate.text = dateFormatter1.string(from: dtDate ?? Date())
        
        
       // print(dateFormatter1.date(from: cell.lblDate.text!)?.dayOfWeek())
        cell.lblDay.text = (dateFormatter1.date(from: cell.lblDate.text!))?.weekdayNameFull
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idAddPassengerListVC) as! AddingPassengersVC
        vc.strTitlle = (arrTodayFlights[indexPath.row].fromcity ?? "") + " - " + (arrTodayFlights[indexPath.row].tocity ?? "")
        vc.strFlight = arrTodayFlights[indexPath.row].complogo!
        vc.strFlightCompany = arrTodayFlights[indexPath.row].compname!
        vc.strDepartureTime = arrTodayFlights[indexPath.item].departuretime ?? ""
        vc.strArrivalTime = arrTodayFlights[indexPath.item].arrivaltime ?? ""
        vc.strFare = (arrTodayFlights[indexPath.item].curency!.suffix(1)) + " " + "\(arrTodayFlights[indexPath.item].fare ?? 0)"
        vc.selectedid = arrTodayFlights[indexPath.item].id ?? ""
        vc.scheduleId = arrTodayFlights[indexPath.item].scheduleid ?? ""
        let dateFormatter = DateFormatter()
        //2022-06-21T08:30:00.000Z
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        let dtDate = dateFormatter.date(from: arrTodayFlights[indexPath.item].departuredate!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM yyyy"
        vc.strDate = dateFormatter1.string(from: dtDate ?? Date())
        
        
       // print(dateFormatter1.date(from: cell.lblDate.text!)?.dayOfWeek())
        vc.strDay = (dateFormatter1.date(from: vc.strDate))!.weekdayNameFull
       
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
}
//MARK: - IQDropDownTextFieldDelegate
extension HomeVC:IQDropDownTextFieldDelegate{
    func textField(_ textField: IQDropDownTextField, didSelect date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.lblDate.text = dateFormatter.string(from: date ?? Date())
    }
}



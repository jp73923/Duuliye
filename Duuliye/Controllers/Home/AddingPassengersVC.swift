//
//  AddingPassengersVC.swift
//  Duuliye
//
//  Created by Developer on 18/06/22.
//

import UIKit
import SDWebImage

class passengerDetailCell: UITableViewCell{
    
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
}

class AddingPassengersVC: UIViewController {
    
    var strDate = String()
    var strDay = String()
    var strDepartureTime = String()
    var strArrivalTime = String()
    var strFlight = String()
    var strFlightCompany = String()
    var strFare = String()
    var strTitlle = String()
    
    var selectedid = String()
    var scheduleId = String()
    var yOffsets: [CGFloat] = []
    
    var tempABC = [
                "class_type" : "",
                "elem_id" : 0,
                "fare" : 0,
                "first_name" : "",
                "last_name" : "",
                "passport" : "",
                "phone" : "+",
                "seat" : "",
                "type" : "",
                "isInfant" : 0,
                "InfantFirstName" : "",
                "InfantLastName" : "",
                
    ] as [String : Any]
    
    var ArrDetails = [[String:Any]]()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tblDetail: UITableView!
    @IBOutlet weak var tblDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var imgFlight: UIImageView!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInfants: UILabel!
    @IBOutlet weak var lblChild: UILabel!
    @IBOutlet weak var lblAdults: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtContactNo.delegate = self
        
        makePrefix()
        tblDetail.delegate = self
        tblDetail.dataSource = self
        
        var tempDic = [String:Any]()
        tempDic["class_type"] = ""
        tempDic["elem_id"] = 0
        tempDic["fare"] = self.strFare
        tempDic["first_name"] = ""
        tempDic["last_name"] = ""
        tempDic["passport"] = ""
        tempDic["phone"] = ""//self.txtContactNo.text
        tempDic["seat"] = ""
        tempDic["type"] = ""
        tempDic["isInfant"] = 0
        tempDic["InfantFirstName"] = ""
        tempDic["InfantLastName"] = ""
        
        ArrDetails.append(tempDic)
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.layoutSubviews()
        self.view.layoutSubviews()
        lblDay.text = strDay
        lblDate.text = strDate
        lblDepartureTime.text = strDepartureTime
        lblArrivalTime.text = strArrivalTime
        
        let strUrl = (strFlight).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        imgFlight.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_selected_flights"))
        
       
        lblFare.text = strFare
        lblTitle.text = strTitlle
        
       
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
            txtContactNo.text = objUser.phone
            txtContactNo.addBottomBorder(.darkGray)
        }
    }
    
    override func viewDidLayoutSubviews() {
      

              //  self.frame.size.height = height
              //  self.heightValue = height

    }
    
    func makePrefix() {
        let attributedString = NSMutableAttributedString(string: "+91 ")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0,4))
        txtContactNo.attributedText = attributedString
    }
    
    @IBAction func passengerDetail_clk(_ sender: Any) {
    }
    @IBAction func passengers_clk(_ sender: Any) {
        if UserDefaultManager.getBooleanFromUserDefaults(key: kIsLoggedIn) {
        
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPassengerSelectionVC) as! PassengerSelectionVC
        
        vc.CallBackToSetPassengers = { adults, child, infants in
            self.lblAdults.text = "\(adults)"
            self.lblChild.text = "\(child)"
            self.lblInfants.text = "\(infants)"
            
            self.ArrDetails = [[String:Any]]()
            
            for i in 0..<adults + child{
                
                var tempDic = [String:Any]()
                tempDic["class_type"] = ""
                tempDic["elem_id"] = 0
                tempDic["fare"] = self.strFare
                tempDic["first_name"] = ""
                tempDic["last_name"] = ""
                tempDic["passport"] = ""
                tempDic["phone"] = self.txtContactNo.text
                tempDic["seat"] = ""
                tempDic["type"] =  i < adults ? "Adult" : "Child"
                tempDic["isInfant"] = 0
                tempDic["InfantFirstName"] = ""
                tempDic["InfantLastName"] = ""
                
                self.ArrDetails.append(tempDic)
       
            }
            
            if infants > 0{
                for i in 0..<infants{
                    self.ArrDetails[i]["isInfant"] = 1
                    self.ArrDetails[i]["type"] = "Infant"
                }
                
            }
            
            print(self.ArrDetails)
            
            
            self.tblDetailHeight.constant = CGFloat((adults + child) * 65)
         
            self.tblDetail.reloadData()
            self.scrollView.layoutSubviews()
        }
        self.presentPanModal(vc)
        }
        
        else{
            let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idLoginVC)
            APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
            APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
            APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
            APP_DELEGATE.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func back_clk(_ sender: Any) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
    @IBAction func bookNow_Clk(_ sender: Any) {
//        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPaymentPreviewVC) as! PaymentPreviewVC
//
//        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
        //temporary
        
        if UserDefaultManager.getBooleanFromUserDefaults(key: kIsLoggedIn) {
            
            let fnames = ArrDetails.map({ ($0["first_name"] as! String).isEmpty })
            let lnames = ArrDetails.map({ ($0["last_name"] as! String).isEmpty })
            let passport = ArrDetails.map({ ($0["passport"] as! String).isEmpty })
            let phone = ArrDetails.map({ ($0["phone"] as! String).isEmpty })
            let isinfant = ArrDetails.filter({ ($0["isInfant"] as! Int == 1) })
            
            if fnames.contains(true){
              showMessage("Please enter the first name")
                if let idx = ArrDetails.firstIndex(where: { ($0["first_name"] as! String).isEmpty }) {
                    openPanModel(idx: idx)
                }
                
                
                
                
            }else if lnames.contains(true){
              showMessage("Please enter the last name")
                if let idx = ArrDetails.firstIndex(where: { ($0["last_name"] as! String).isEmpty }) {
                    openPanModel(idx: idx)
                }
                
            }
            else if passport.contains(true){
              showMessage("Please enter the Passport")
                if let idx = ArrDetails.firstIndex(where: { ($0["passport"] as! String).isEmpty }) {
                    openPanModel(idx: idx)
                }
            }
            
           else if phone.contains(true){
              showMessage("Please enter the phone number")
               if let idx = ArrDetails.firstIndex(where: { ($0["phone"] as! String).isEmpty }) {
                   openPanModel(idx: idx)
               }
            }
            else{
                if isinfant.isEmpty{
           
            let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idSeatSelectionVC) as! SeatSelectionVC
            vc.ArrPassengerDetaails = ArrDetails
            vc.flightId = selectedid
            vc.scheduleId = scheduleId
                    vc.strFlightCompany = strFlightCompany
                    
                    vc.strFare = strFare

            APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                }
                else{
                    let fnames = ArrDetails.map({ ($0["InfantFirstName"] as! String).isEmpty && $0["isInfant"] as! Int == 1 })
                    let lnames = ArrDetails.map({ ($0["InfantLastName"] as! String).isEmpty && $0["isInfant"] as! Int == 1})
                    if fnames.contains(true){
                      showMessage("Please enter the Infant first name")
                        if let idx = ArrDetails.firstIndex(where: { ($0["InfantFirstName"] as! String).isEmpty }) {
                            openPanModel(idx: idx)
                        }
                    }else if lnames.contains(true){
                        showMessage("Please enter the Infant last name")
                        if let idx = ArrDetails.firstIndex(where: { ($0["InfantLastName"] as! String).isEmpty }) {
                            openPanModel(idx: idx)
                        }
                      
                    }
                    else{
                        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idSeatSelectionVC) as! SeatSelectionVC
                        vc.ArrPassengerDetaails = ArrDetails
                        vc.flightId = selectedid
                        vc.scheduleId = scheduleId
                        vc.strFlightCompany = strFlightCompany

                        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                    }
                }
            }
           
        } else {
            let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idLoginVC)
            APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
            APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
            APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
            APP_DELEGATE.window?.makeKeyAndVisible()
        
        
       
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

extension AddingPassengersVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtContactNo.addBottomBorder(.green)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtContactNo.addBottomBorder(.darkGray)
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

extension AddingPassengersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.tblDetail.dequeueReusableCell(withIdentifier: "PassengerDetailCell") as! passengerDetailCell
        
       
        cell.lblName.text = (ArrDetails[indexPath.row]["first_name"] as! String).isEmpty ? "Passenger" : "\(ArrDetails[indexPath.row]["first_name"] as? String ?? "") \(ArrDetails[indexPath.row]["last_name"] as? String ?? "")"
        cell.lblDetail.text = (ArrDetails[indexPath.row]["passport"] as! String).isEmpty ? "click here to fill" : (ArrDetails[indexPath.row]["passport"] as! String)
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaultManager.getBooleanFromUserDefaults(key: kIsLoggedIn) {
        openPanModel(idx: indexPath.item)
        }
        else{
            let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idLoginVC)
            APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
            APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
            APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
            APP_DELEGATE.window?.makeKeyAndVisible()
        }
    }
    
    func openPanModel(idx : Int){
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPassengerFormsVC) as! PDFormVC
        vc.isLapInfant = ArrDetails[idx]["isInfant"] as! Int
        vc.firstName = self.ArrDetails[idx]["first_name"] as! String
        vc.lastName = self.ArrDetails[idx]["last_name"] as! String
        vc.passport = self.ArrDetails[idx]["passport"] as! String
        vc.Phone = self.ArrDetails[idx]["phone"] as! String
        vc.infantFirstName = self.ArrDetails[idx]["InfantFirstName"] as! String
        vc.infantLastName = self.ArrDetails[idx]["InfantLastName"] as! String
        
        vc.CallBackToSetPassengerDetails = { firstName, lastName, passport, phone, infantFirstName, infantLastName in
           
           
            self.ArrDetails[idx]["first_name"] = firstName
            self.ArrDetails[idx]["last_name"] = lastName
            self.ArrDetails[idx]["passport"] = passport
            self.ArrDetails[idx]["phone"] = phone.isEmpty ? self.txtContactNo.text : phone
            self.ArrDetails[idx]["InfantFirstName"] = infantFirstName
            self.ArrDetails[idx]["InfantLastName"] = infantLastName
            self.ArrDetails[idx]["type"] = idx < Int(self.lblAdults.text!)! ? "Adult" : "Child"
            
            self.tblDetail.reloadData()
            
        }
        self.presentPanModal(vc)
    }
    
    
}

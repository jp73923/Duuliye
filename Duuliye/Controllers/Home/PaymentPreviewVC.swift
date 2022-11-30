//
//  PaymentPreviewVC.swift
//  Duuliye
//
//  Created by Developer on 18/06/22.
//

import UIKit

class passengersCell: UITableViewCell {
    
    @IBOutlet weak var lblPassenger: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblSeatFare: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
}

class cellPaymentPreview: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblPassengers: UITableView!
    @IBOutlet weak var lblFlightName: UILabel!
    @IBOutlet weak var lblDAte: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAAirlineName: UILabel!
    @IBOutlet weak var lblToCityNAme: UILabel!
    @IBOutlet weak var lblFromCityName: UILabel!
    @IBOutlet weak var lblToCity: UILabel!
    @IBOutlet weak var lblFromCity: UILabel!
    @IBOutlet weak var baseView: UIView!
    var arrPassengers = [[String: Any]]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//
        
        
    }
    
    func REloadDAta(){
        tblPassengers.delegate = self
               tblPassengers.dataSource = self
       
            
        tblHeight.constant = CGFloat(arrPassengers.count * 80)
        
        tblPassengers.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPassengers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblPassengers.dequeueReusableCell(withIdentifier: "passengersCell") as! passengersCell
        cell.lblName.text = "\(arrPassengers[indexPath.row]["first_name"] ?? "") \(arrPassengers[indexPath.row]["last_name"] ?? "")"
        cell.lblClass.text = "\(arrPassengers[indexPath.row]["class_type"] ?? "Economy")"
        cell.lblSeatFare.text = "\(arrPassengers[indexPath.row]["seat"] ?? "")/\(arrPassengers[indexPath.row]["fare"] ?? "")"
        cell.lblPassenger.text = "passenger \(indexPath.row + 1) \(arrPassengers[indexPath.row]["type"] ?? "")"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

class PaymentPreviewVC: UIViewController {

    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblPaymentPreview: UITableView!
    @IBOutlet weak var lblPassengers: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var ArrPassengers = [[String:Any]]()
    var flightDic = [String: Any]()
    var airportDic = [String: Any]()
    
    var flightId = String()
    var scheduleId = String()
    var strFare = String()
    var strFlightCompany = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblPaymentPreview.delegate = self
        tblPaymentPreview.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        lblPrice.text = "USD \((self.ArrPassengers.compactMap { Int((($0["fare"] as? String ?? "0").replacingOccurrences(of: "$ ", with: ""))) }.reduce(0,+)))"
        print(lblPrice.text)
        lblPassengers.text = "For \(ArrPassengers.count) Passengers"
        
//        tblHeight.constant = CGFloat(120 * ArrPassengers.count)
    }
    override func viewDidLayoutSubviews() {
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: bottomView.height/3)
    }
    
    @IBAction func back_clk(_ sender: Any) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
    
    @IBAction func Done_Clk(_ sender: Any) {
       // showMessage("Done Booking")
      //  let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPDFVC) as! PDFVC
      //  vc.pdfURL = "https://duuliye.com/ticketPdf/62c260bf550077c2f10bcea7.pdf"
        
     //       APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
        
        
 //
        showAlertButtonTapped()
      //  api_SaveBookings()
    }
    
    func showAlertButtonTapped() {
        
        var strPhone = ""
        
        if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
            
            strPhone = objUser.phone ?? ""
           // strCode = objUser.countryCode ?? UserDefaults.standard.value(forKey: "COUNTRYCODE") as! String
            
        }

            // create the alert
            let alert = UIAlertController(title: "Alert!", message: "Confirm ticket booking with payment phone \(strPhone)", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            }))
                               
           alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action in
               
               self.api_get_payment_method()
               
            }))
                                      
                                  

            // show the alert
            self.present(alert, animated: true, completion: nil)
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

extension PaymentPreviewVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblPaymentPreview.dequeueReusableCell(withIdentifier: "cellPaymentPreview") as! cellPaymentPreview
        
        cell.baseView.cornerRadius = 8.0
      //  cell.backgroundColor = .red
        cell.baseView.clipsToBounds = true
        
        cell.baseView.addShadow()
        
        
        
        cell.lblFromCity.text = airportDic["from_airport_code"] as? String
        cell.lblToCity.text = airportDic["to_airport_code"] as? String
        cell.lblFromCityName.text = "\(airportDic["from_city"] as? String ?? ""), \(airportDic["from_country"] as? String ?? "")"
        cell.lblToCityNAme.text = "\(airportDic["to_city"] as? String ?? ""), \(airportDic["to_country"] as? String ?? "")"
        let dateFormatter = DateFormatter()
        //2022-06-21T08:30:00.000Z
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        let dtDate = dateFormatter.date(from: flightDic["departure_date"]! as! String)
       
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd,yyyy"
        cell.lblDAte.text = dateFormatter1.string(from: dtDate ?? Date())
        
        
        
        
       // cell.lblDAte.text = flightDic["departure_date"] as? String
        cell.lblTime.text = flightDic["departure_time"] as? String
        cell.lblArrivalTime.text = flightDic["arrival_time"] as? String ?? ""
        cell.lblFlightName.text = "Flight No : \(flightDic["flight_number"] as? String ?? "")"
        cell.lblAAirlineName.text = strFlightCompany
        
        cell.arrPassengers = ArrPassengers
        cell.REloadDAta()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((ArrPassengers.count * 60) + 345)
    }
    
    
}

//MARRRK:- API_CALL
extension PaymentPreviewVC{
    
    func api_get_payment_method()
    {
        if isConnectedToNetwork() {
            
          
            var strUserId = ""
            var strToken = ""
           
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
               // strPhone = objUser.phone ?? ""
               // strCode = objUser.countryCode ?? UserDefaults.standard.value(forKey: "COUNTRYCODE") as! String
                
            }
            
            var tempdic = [String: Any]()
           
            tempdic["token"] = strToken
            tempdic["user_id"] = strUserId
            
            print(tempdic)
      
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetPaymentMethod)", service: APIGetPaymentMethod, parameters: tempdic as NSDictionary, keyname: APIGetPaymentMethod as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        print(data)
                        if data["success"] as! Bool{
                            
                            var arrPaymentList = data["data"] as! [[String: String]]
                            let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPaymentList) as! PaymentListController
                            vc.arrPAyment = arrPaymentList
                            vc.strTotalFAre = self.lblPrice.text ?? "0"
                            vc.CallBackToSetVallue = { selectedPaymentMethod in
                                print(#function,selectedPaymentMethod)
                                self.api_SaveBookings(strSelectedpaymentMethod: selectedPaymentMethod)
                                
                            }
                            APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                            
                            
                            
                            
                     /*       {
                      "success": true,
                      "data": [
                          {
                              "name": "Card payment",
                              "description": "International Card payment",
                              "icon": "https://play-lh.googleusercontent.com/UZN9LaE6AKxQBcLJmH-9_Cseutoit4hxSJEI8U1BI1XNodWyJBkWpk0ITKlcvkNX-A=w240-h480-rw"
                          }
                      ]
                  }*/
                               
                            
                        
                       
                        
                        }
                        else{
                            showMessage("Error in booking")
                        }
                        
                    }
                }
            }
        }
    }
    
    func api_SaveBookings(strSelectedpaymentMethod: String)
    {
        if isConnectedToNetwork() {
            
           /* var strUserId = ""
            var strToken = ""
            var strPhone = ""
            
            /*{
             "token": "XlXAEsyjYTUQGt2T",
             "user_id": "62a3247615d8ee628c91c00c",
             "passenger_detail": [
                 {
                     "first_name": "Asma",
                     "last_name": "Godil",
                     "phone": "1234567890",
                     "passport": "qwerty",
                     "type": "Adult",
                     "seat": "D4",
                     "class_type": "First class",
                     "elem_id": 0,
                     "fare": 165
                 }
             ],
             "count": 1,
             "schedule_id": "6310c7ccb37c8f9ccd73649d",
             "flight_id": "630f4aef7e6519315fae75db",
             "payment_phone": "+91 1234567890",
             "total": 165
         }*/
            
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
                strPhone = objUser.phone ?? ""
            }
            
            var tempdic = [String: Any]()
            tempdic["count"] = ArrPassengers.count
            tempdic["flight_id"] = flightId
            tempdic["token"] = strToken
            tempdic["user_id"] = strUserId
            tempdic["schedule_id"] = scheduleId
            tempdic["payment_phone"] = strPhone
            tempdic["total"] = 115
            
            tempdic["passenger_detail"] = ArrPassengers
            
            print(tempdic)*/
            var strUserId = ""
            var strToken = ""
            var strPhone = ""
            var strCode = ""
            
            /*{
            -- "token": "XlXAEsyjYTUQGt2T",
            -- "user_id": "62a3247615d8ee628c91c00c",
             "passenger_detail": [
                 {
                    -- "first_name": "Asma",
                    -- "last_name": "Godil",
                     "phone": "1234567890",
                    -- "passport": "qwerty",
                    -- "type": "Adult",
                    -- "seat": "D4",
                    -- "class_type": "First class",
                     --"elem_id": 0,
                     "fare": 165
                 }
             ],
            -- "count": 1,
            -- "schedule_id": "6310c7ccb37c8f9ccd73649d",
             --"flight_id": "630f4aef7e6519315fae75db",
            -- "payment_phone": "+91 1234567890",
             --"total": 165
         }*/
            
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
                strPhone = objUser.phone ?? ""
                strCode = objUser.countryCode ?? UserDefaults.standard.value(forKey: "COUNTRYCODE") as! String
                
            }
            
            var tempdic = [String: Any]()
            tempdic["count"] = ArrPassengers.count
            tempdic["flight_id"] = flightId
            tempdic["token"] = strToken
            tempdic["user_id"] = strUserId
            tempdic["schedule_id"] = scheduleId
            tempdic["payment_phone"] = "\(strCode) \(strPhone)"
            tempdic["total"] = (self.ArrPassengers.compactMap { Int((($0["fare"] as? String ?? "0").replacingOccurrences(of: "$ ", with: ""))) }.reduce(0,+))
            var arrFinalPassengers = ArrPassengers
            
            for i in 0..<ArrPassengers.count{
                arrFinalPassengers[i]["fare"] = (ArrPassengers[i]["fare"] as! String).components(separatedBy:" ")[1]
                arrFinalPassengers[i]["phone"] = (ArrPassengers[i]["phone"] as! String).contains(" ") ? (ArrPassengers[i]["phone"] as! String).components(separatedBy:" ")[1] : (ArrPassengers[i]["phone"] as! String)
            }
            print(arrFinalPassengers)
            tempdic["passenger_detail"] = arrFinalPassengers
           
            var abc = [String : String]()
            abc["name"] = strSelectedpaymentMethod
            
            tempdic["payment"] = abc
            
            print(tempdic)
       //  let jsonString = tempdic.toJSONStringWithSpace
            
           // let postData = jsonString.data(using: .utf8)
            
            /*{
             "token": "bbdd11fc-b3bf-4050-82f1-4488ff5bd3ca",
             "user_id": "ea43d414-6b3d-47d4-a3d1-9869a84fc587",
             "passenger_detail": [
                 {
                     "first_name": "Asma",
                     "last_name": "Godil",
                     "phone": "+911234567890",
                     "passport": "P0030032",
                     "type": "Adult",
                     "seat": "A5",
                     "class_type": "Eccnomic class",
                     "elem_id": 32,
                     "fare": 120
                 }
             ],
             "count": 1,
             "schedule_id": "62bc46f9285855ee007326f4",
             "flight_id": "62bc45cd285855ee00731170",
             "payment_phone": "+911234567890",
             "total": 120
         }*/
            
        /*    let param:[String:Any] = [
                "token" : strToken,
                "user_id" : strUserId,
                "passenger_detail": [
                    [
                        "first_name": "Asma",
                        "last_name": "Godil",
                        "phone": "+911234567890",
                        "passport": "P0030032",
                        "type": "Adult",
                        "seat": "B2",
                        "class_type": "Eccnomic class",
                        "elem_id": 0,
                        "fare": 115
                    ]
                ],
                "count": 1,
                "schedule_id": scheduleId,
                "flight_id": flightId,
                "payment_phone": "+911234567890",
                "total": 115
            ]*/
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APISave_booking)", service: APISave_booking, parameters: tempdic as NSDictionary, keyname: APISave_booking as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                    if let data = data as? NSDictionary {
                        print(data)
                        if data["success"] as! Bool{
                            
                            let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPDFVC) as! PDFVC
                            vc.pdfURL = data["pdflink"] as! String
                            
                                APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
                            
                     /*       {
                                "pdflink": "https://duuliye.com/ticketPdf/62c24498550077c2f10bcdc6.pdf",
                                "ticket_id": "62c24498550077c2f10bcdc6",
                                "detail": {
                                    "fullname": "Asma Godil",
                                    "from_city": "Mogadishu",
                                    "to_city": "Beledweyne",
                                    "duration": "13h 30m",
                                    "d_time": "8:00",
                                    "a_time": "9:30",
                                    "d_date": "Jul 05",
                                    "a_date": "Jul 05",
                                    "flight_number": "SD0105",
                                    "logo": "https://duuliye.com/flight_icons/KRRNOwvMq4.jpg",
                                    "ticket_number": 273,
                                    "class_type": "Eccnomic class"
                                },
                                "success": true,
                                "message": "Ticket successfully booked to airline, thank you"
                            }*/
                               
                            
                        
                       
                        
                        }
                        else{
                            showMessage("Error in booking")
                        }
                        
                    }
                }
            }
        }
    }
    
}

extension Dictionary{
    var toJSONStringWithSpace: String {
        let jsonParser = try! JSONSerialization.data(withJSONObject: self, options: [])
        return String(data: jsonParser, encoding: .utf8)!.filter { !$0.isNewline }
    }
}

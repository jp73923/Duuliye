//
//  FlightInfoController.swift
//  Duuliye
//
//  Created by Developer on 01/08/22.
//

import UIKit

class FlightInfoController: UIViewController {
    
    var ticketId = String()

    @IBOutlet weak var tblPassengerHeight: NSLayoutConstraint!
    @IBOutlet weak var tblPassengers: UITableView!
    @IBOutlet weak var lblFlightNo: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblToTime: UILabel!
    @IBOutlet weak var lblFromTime: UILabel!
    @IBOutlet weak var fare: UILabel!
    @IBOutlet weak var airlineCompany: UILabel!
    @IBOutlet weak var toAirport: UILabel!
    @IBOutlet weak var fromAirport: UILabel!
    @IBOutlet weak var toCity: UILabel!
    @IBOutlet weak var fromCity: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    var arrPassengers = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FlightInfo()
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

extension FlightInfoController{
    
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
    
    func FlightInfo()
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
                "ticket_id": ticketId
                
            ]
            
            print(param as NSDictionary)
            
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIBookingDetail)", service: APITicketHistory, parameters: param as NSDictionary, keyname: APIBookingDetail as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
                if error != nil
                {
                    showMessage(error.debugDescription)
                    return
                }
                else if let data = responseDict
                {
                 //   if let data = data as? NSDictionary {
                        print(#function,data)
                        if data["success"] as! Bool{
                            
                            if let flightData = data["data"] as? [String:Any]{
                                
                                
                                self.arrPassengers = flightData["ticket_detail"] as! [[String:Any]]
                                
                                self.tblPassengerHeight.constant = CGFloat(85 * self.arrPassengers.count)
                                self.baseView.layer.borderColor = UIColor(red: 102/255, green: 188/255, blue: 55/255, alpha: 1.0).cgColor
                                self.baseView.layer.cornerRadius = 12.0
                                self.baseView.clipsToBounds = true
                                self.baseView.borderWidth = 1.5
                            
                          //  self.tblPassengerHeight.text =
                            //self.tblPassengers.text =
                            self.lblFlightNo.text = "Flight No.:\(flightData["flight_number"] as! String)"
                                let dateFormatter = DateFormatter()
                                //2022-06-21T08:30:00.000Z
                                dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
                                let dtDate = dateFormatter.date(from: flightData["departure_date"]! as! String)
                                
                                
                                let dateFormatter1 = DateFormatter()
                                dateFormatter1.dateFormat = "MMM dd,yyyy"
                                self.lblFromDate.text = dateFormatter1.string(from: dtDate ?? Date())
                                
                                let abc = self.convertDateFormater(date: flightData["arrival_date"]! as! String)
                                print(#function,abc)
                            
                            self.lblToTime.text = self.convertDateFormater(date: flightData["arrival_date"]! as! String)
                            self.lblFromTime.text = self.convertDateFormater(date: flightData["departure_date"]! as! String)
                            self.fare.text = "\(flightData["fare"] as? Int ?? 0) USD"
                            self.airlineCompany.text = flightData["comp_name"] as? String
                            self.toAirport.text = flightData["to_airport_name"] as? String
                            self.fromAirport.text = flightData["from_airport_name"] as? String
                            self.toCity.text = flightData["to_city_name"] as? String
                                self.fromCity.text = flightData["from_city_name"] as? String
                                self.tblPassengers.delegate = self
                                self.tblPassengers.dataSource = self
                                self.tblPassengers.reloadData()
                           // self.baseView.text =

                            }
                       
                        }
                        else{
                            hideLoaderHUD()
                            showMessage(data["message"] as! String)
                            
                        }
                    //}
                }
            }
        }
    }
}

extension FlightInfoController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPassengers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblPassengers.dequeueReusableCell(withIdentifier: "passengersCell") as! passengersCell
        cell.lblName.text = "\(arrPassengers[indexPath.row]["fullname"] ?? "")"
        cell.lblClass.text = "\(arrPassengers[indexPath.row]["class_type"] ?? "Economy")"
        cell.lblSeatFare.text = "\(arrPassengers[indexPath.row]["seat"] ?? "")"
        cell.lblPassenger.text = "Passenger \(indexPath.row) \(arrPassengers[indexPath.row]["type"] ?? "")"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

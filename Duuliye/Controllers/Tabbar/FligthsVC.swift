//
//  FligthsVC.swift
//  Duuliye
//
//  Created by Jay on 06/06/22.
//

import UIKit
import SwiftyJSON
import SDWebImage


class cellTabFlights:UITableViewCell {
    //MARK: - IBOutlets
   
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblToFromCity: UILabel!
    @IBOutlet weak var imgFlights: UIImageView!
}

class cell_Dates:UICollectionViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeekday: UILabel!
}
class FligthsVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tblTodayFlights: UITableView!
    @IBOutlet weak var clvDates: UICollectionView!
    
    @IBOutlet weak var lblSearchCount: UILabel!
    var selectedIndex = 0
    var totalMonthDays = 0
    var arrDays = [Int]()
    var selectedDate = ""
    var isCheapest = true
    var compId = ""
    var arrTodayFlights = [Flights]()
    var datesBetweenArray = [Date]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       /* let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: Date())

        let dateComponents = DateComponents(year: Int(year), month: Int(month))
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        self.totalMonthDays = range.count
        
        for i in 0 ..< self.totalMonthDays{
            arrDays.append(i)
        }*/
        
        let monthsToAdd = 1
        let newDate = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: Date())
     
         datesBetweenArray = Date.dates(from: Date(), to: newDate!)
       
        self.clvDates.reloadData()
        self.tblTodayFlights.isHidden = true
       
        today_flights(strDate: "")
    }
    
    func today_flights(strDate: String)
    {
        if isConnectedToNetwork() {
            
            var strUserId = ""
            var strToken = ""
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
            }
            print(strDate)
           // let strDate = Date.getCurrentDate(withFormat: "MM/dd/yyyy")
            
            let param:[String:Any] = [
                "token" : strToken,
                "user_id" : strUserId,
                "city": "Mogadishu",
                "price": isCheapest ? "cheapest" : "Quikest",
                "comp_id": compId,
                "date": strDate.isEmpty ? Date.getCurrentDate(withFormat: "MM/dd/yyyy") : strDate,
                
            ]
            
            print(param as NSDictionary)
            
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APITodayFlights)", service: APITodayFlights, parameters: param as NSDictionary, keyname: APITodayFlights as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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
                            self.lblSearchCount.text = "\(self.arrTodayFlights.count) Results"
                            self.tblTodayFlights.reloadData()
                            self.tblTodayFlights.isHidden = false

                       
                       
                        }
                        else{
                            hideLoaderHUD()
                            self.lblSearchCount.text = "\(self.arrTodayFlights.count) Results"
                            showMessage(data["message"] as! String)
                            self.tblTodayFlights.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func btnFilterFlights_Clk(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idFilterFlightsVC) as! FilterFlightsVC
        vc.isCheapest = isCheapest
        vc.selectedCompId = compId
        vc.CallBackToSFFillterFlight = { isCheapest1, companyId in
          
            self.isCheapest = isCheapest1
            self.compId = companyId
            self.arrTodayFlights = [Flights]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            // Convert Date to String
           
            self.today_flights(strDate: dateFormatter.string(from: self.datesBetweenArray[self.selectedIndex]))
            
            
        }
        self.presentPanModal(vc)
    }
}
//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension FligthsVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return datesBetweenArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clvDates.dequeueReusableCell(withReuseIdentifier: "cell_Dates", for: indexPath) as! cell_Dates
        cell.vwBG.layer.borderWidth = 2.0
        cell.vwBG.layer.borderColor = self.selectedIndex == indexPath.row ? UIColor.fromHex(hexString: "#059e4a").cgColor : UIColor.lightGray.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: datesBetweenArray[indexPath.row])
        cell.lblDate.text = day
       
        cell.lblWeekday.text = datesBetweenArray[indexPath.row].weekdayName()
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.clvDates.reloadData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // Convert Date to String
        arrTodayFlights = [Flights]()
        today_flights(strDate: dateFormatter.string(from: datesBetweenArray[indexPath.row]))
    }
}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension FligthsVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTodayFlights.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblTodayFlights.dequeueReusableCell(withIdentifier: "cellTabFlights") as! cellTabFlights
      
        cell.lblToFromCity.text = (arrTodayFlights[indexPath.row].fromcity ?? "") + " - " + (arrTodayFlights[indexPath.row].tocity ?? "")
        
       
        cell.imgFlights.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        let strUrl = (arrTodayFlights[indexPath.row].complogo!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.imgFlights.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_selected_flights"))
        cell.lblDepartureTime.text = arrTodayFlights[indexPath.item].departuretime
        cell.lblArrivalTime.text = arrTodayFlights[indexPath.item].arrivaltime
        cell.lblFare.text = (arrTodayFlights[indexPath.item].curency!.suffix(1)) + " " + "\(arrTodayFlights[indexPath.item].fare ?? 0)"
        
        let dateFormatter = DateFormatter()
        //2022-06-21T08:30:00.000Z
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        let dtDate = dateFormatter.date(from: arrTodayFlights[indexPath.item].departuredate!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd,yyyy"
        cell.lblDate.text = dateFormatter1.string(from: dtDate ?? Date())
       
        cell.lblDay.text = (dateFormatter1.date(from: cell.lblDate.text!))?.weekdayNameFull
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idAddPassengerListVC) as! AddingPassengersVC
        vc.strTitlle = (arrTodayFlights[indexPath.row].fromcity ?? "") + " - " + (arrTodayFlights[indexPath.row].tocity ?? "")
        vc.strFlightCompany = arrTodayFlights[indexPath.row].compname!
        vc.strFlight = arrTodayFlights[indexPath.row].complogo!
        vc.strDepartureTime = arrTodayFlights[indexPath.item].departuretime ?? ""
        vc.strArrivalTime = arrTodayFlights[indexPath.item].arrivaltime ?? ""
        vc.strFare = (arrTodayFlights[indexPath.item].curency!.suffix(1)) + " " + "\(arrTodayFlights[indexPath.item].fare ?? 0)"
        vc.selectedid = arrTodayFlights[indexPath.item].id ?? ""
        vc.scheduleId = arrTodayFlights[indexPath.item].scheduleid ?? ""
       
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM,yyyy"
        
        vc.strDate = dateFormatter1.string(from: self.datesBetweenArray[self.selectedIndex])
   
       // print(dateFormatter1.date(from: cell.lblDate.text!)?.dayOfWeek())
        vc.strDay = (dateFormatter1.date(from: vc.strDate))!.weekdayNameFull
       
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
}

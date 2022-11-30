//
//  SeatSelectionVC.swift
//  Duuliye
//
//  Created by Developer on 18/06/22.
//

import UIKit

class SeatSelectionVC: UIViewController {

    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var seatColHeight: NSLayoutConstraint!
    @IBOutlet weak var passengeListColHeight: NSLayoutConstraint!
    @IBOutlet weak var passengerListCol: UICollectionView!
    @IBOutlet weak var seatCol: UICollectionView!
    var ArrPassengerDetaails = [[String: Any]]()
    var flightDic = [String: Any]()
    var airportDic = [String: String]()
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"Rectangle_Aeroplane")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    var strFlightCompany = String()
    var selectedCellTag = -1
    var selectedbtnTag = -1
    var ArrScheduledSeats = [[String: Any]]()
    var ArrPtDetail = [[String: Any]]()
   // var seatSection = 1
    

    var arrSelection = [[String:Int]]()
    
    
    var flightId = String()
    var scheduleId = String()
    
    var fromCityCode = String()
    var toCityCode = String()
    
    var fromCity = String()
    var toCity = String()
    var strFare = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seatCol.delegate = self
        seatCol.dataSource = self
        
        passengerListCol.delegate = self
        passengerListCol.dataSource = self
        
        passengerListCol.register(UINib(nibName: "cityHeaderViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cityHeaderViewCell")
        
        passengerListCol.register(UINib(nibName: "PassengerListCell", bundle: nil), forCellWithReuseIdentifier: "PassengerListCell")
        
        seatCol.backgroundView = imageView
        
        seatCol.register(UINib(nibName: "RiightLLeftHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RiightLLeftHeaderCell")
        
        seatCol.register(UINib(nibName: "SeatCell", bundle: nil), forCellWithReuseIdentifier: "SeatCell")
        
        print(ArrPassengerDetaails)
        
       api_GetLayoutId()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        passengeListColHeight.constant = CGFloat(ArrPassengerDetaails.count * 118)      //120//140
      //  seatColHeight.constant = 1200
        
        passengerListCol.reloadData()
        seatCol.reloadData()
        
        scrView.layoutIfNeeded()
        scrView.layoutSubviews()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmSeatTapped(_ sender: Any) {
       print(ArrPassengerDetaails)
     //   [["class_type": "", "passport": "qwerty", "seat": "", "InfantFirstName": "", "isInfant": 0, "fare": "$ 95", "InfantLastName": "", "type": "", "elem_id": 0, "first_name": "Asma", "last_name": "Godil", "phone": "+91 9909952548"]]
        
       // ArrPassengerDetaails.map({ ($0["InfantFirstName"] as! String).isEmpty })
        
      //  if ArrPassengerDetaails.
        
        if arrSelection.count == ArrPassengerDetaails.count{
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPaymentPreviewVC) as! PaymentPreviewVC
        vc.flightId = flightId
        vc.scheduleId = scheduleId
            vc.flightDic = flightDic
            vc.airportDic = airportDic
        vc.ArrPassengers = ArrPassengerDetaails
            vc.strFlightCompany = strFlightCompany
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
        }
        else{
            showMessage("please select the seats")
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
// MARK: - EXTENSIONS_COLLECTIONVIEW

extension SeatSelectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == passengerListCol{
            return 1
        }else{
            return ArrScheduledSeats.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == passengerListCol{
            return ArrPassengerDetaails.count
        }
        else{
            return (ArrScheduledSeats[section] )["rows"] as! Int
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == passengerListCol{
        return CGSize(width: passengerListCol.frame.width, height: 60)
        }
        else{
            if section == 0{
            return CGSize(width:seatCol.frame.width, height: 260)
            }
            else{
                return CGSize(width:seatCol.frame.width, height: 60)
            }
        }
        
        //    return CGSize(width: passengerListCol.frame.width, height: 60)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            if collectionView == passengerListCol
            {
        let HeaderView = passengerListCol.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cityHeaderViewCell", for: indexPath) as! cityHeaderViewCell
                
                HeaderView.lblFromCity.text = self.fromCityCode
                HeaderView.lblToCity.text = self.toCityCode
                HeaderView.llblFromCityName.text = self.fromCity
                HeaderView.lblToCityName.text = self.toCity
                
          //  HeaderView.backgroundColor = .orange
        HeaderView.layoutSubviews()
        
        return HeaderView
            }
            else
            {
                let HeaderView = seatCol.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RiightLLeftHeaderCell", for: indexPath) as! RiightLLeftHeaderCell
                
                HeaderView.layoutSubviews()
                
                if indexPath.section == 0{
                    HeaderView.imgHeight.constant = 103
                    HeaderView.topHeight.constant = 64
                }else{
                    HeaderView.imgHeight.constant = 0
                    HeaderView.topHeight.constant = 4
                }
                HeaderView.lblClass.text = ArrScheduledSeats[indexPath.section]["classtype"] as? String
                HeaderView.lblPrice.text = strFare
                
                
                
                return HeaderView
                
            }
        }
        else if kind  == UICollectionView.elementKindSectionFooter{
            return UICollectionReusableView()
        }
        else{
            assert(false, "Invalid element type")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == passengerListCol{
        
        let cell = passengerListCol.dequeueReusableCell(withReuseIdentifier: "PassengerListCell", for: indexPath) as! PassengerListCell
            
            cell.lblName1.text = "\(ArrPassengerDetaails[indexPath.item]["first_name"] ?? "") \(ArrPassengerDetaails[indexPath.item]["last_name"] ?? "")"
            
            cell.lblSeat.text = "\(ArrPassengerDetaails[indexPath.item]["seat"] ?? "--")"
            
            if cell.lblSeat.text != "--" && !cell.lblSeat.text!.isEmpty{
            if "\(ArrPassengerDetaails[indexPath.item]["type"] ?? "--")" == "Adult"{
                if ArrPassengerDetaails[indexPath.item]["isInfant"] as! Int == 1{
                    
                    
                    
                    let abc = ArrPtDetail[0]["fare"] as! Int
                    
                    let def = ArrPtDetail[2]["fare"] as! Int
                    
                    let ghi = "\(abc + def)"
                    
                    cell.lblSelectSeat1.text = "\(ArrScheduledSeats[indexPath.section]["classtype"] as! String) $ \(ghi)"
                    
                    ArrPassengerDetaails[indexPath.item]["fare"] = "$ \(ghi)"
                }
                else{
                    cell.lblSelectSeat1.text = "\(ArrScheduledSeats[indexPath.section]["classtype"] as! String ) $ \(ArrPtDetail[0]["fare"] as! Int)"
                    ArrPassengerDetaails[indexPath.item]["fare"] = "$ \(ArrPtDetail[0]["fare"] as! Int)"
                }
                
            }
            else if "\(ArrPassengerDetaails[indexPath.item]["type"] ?? "--")" == "Child"{
                cell.lblSelectSeat1.text = "\(ArrScheduledSeats[indexPath.section]["classtype"] as! String ) $\(ArrPtDetail[1]["fare"] as! Int)"
                ArrPassengerDetaails[indexPath.item]["fare"] = "$ \(ArrPtDetail[1]["fare"] as! Int)"
            }
            }
            else{
                cell.lblSelectSeat1.text = "Select Seat"
            }
            
            print(ArrPassengerDetaails[indexPath.item])
        
        cell.lblSeat.layer.borderColor = UIColor.green.cgColor
        cell.lblSeat.layer.borderWidth = 1.0
        
        cell.lblSeat.layer.cornerRadius = 2.0
        cell.lblSeat.clipsToBounds = true
            return cell
        }
        else{
            let cell = seatCol.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCell
            cell.tag = indexPath.item
            cell.contentView.tag = indexPath.item
            cell.lblSrNo.text = "\(indexPath.item + 1)"
//            cell.btn1.titleLabel?.text = "A\(indexPath.item + 1)"
//            cell.btn2.titleLabel?.text = "B\(indexPath.item + 1)"
//            cell.btn3.titleLabel?.text = "C\(indexPath.item + 1)"
//            cell.btn4.titleLabel?.text = "C\(indexPath.item + 1)"
          //  if arrSelectedCellTag.contains(indexPath.item){
            if arrSelection.map({$0["CELLTAG"]}).contains(indexPath.item){
                let abc = arrSelection.filter({$0["CELLTAG"] == indexPath.item})
                print(abc)
                let btntag = abc.map({$0["BTNTAG"]})
                
           // if selectedCellTag == indexPath.item{
             //   if !btntag.contains(cell.btn1.tag)
                    if !btntag.contains(cell.btn1.tag){//selectedbtnTag != cell.btn1.tag{
                    cell.btn1.setTitle("A\(indexPath.item + 1)", for: .normal)
                    cell.btn1.setImage(nil, for: .normal)
                }else
                {
                    cell.btn1.setTitle("", for: .normal)
                    cell.btn1.setImage(UIImage(named: "ic_checkmark"), for: .normal)
                    cell.btn1.imageView?.contentMode = .scaleAspectFit
                }
                if !btntag.contains(cell.btn2.tag){ // if selectedbtnTag != cell.btn2.tag{
                    cell.btn2.setTitle("B\(indexPath.item + 1)", for: .normal)
                    cell.btn2.setImage(nil, for: .normal)
                }else
                {
                    cell.btn2.setTitle("", for: .normal)
                    cell.btn2.setImage(UIImage(named: "ic_checkmark"), for: .normal)
                    cell.btn2.imageView?.contentMode = .scaleAspectFit
                }
                if !btntag.contains(cell.btn3.tag){//if selectedbtnTag != cell.btn3.tag{
                    cell.btn3.setTitle("C\(indexPath.item + 1)", for: .normal)
                    cell.btn3.setImage(nil, for: .normal)
                    
                }else
                {
                    cell.btn3.setTitle("", for: .normal)
                    cell.btn3.setImage(UIImage(named: "ic_checkmark"), for: .normal)
                    cell.btn3.imageView?.contentMode = .scaleAspectFit
                }
                if !btntag.contains(cell.btn4.tag){// if selectedbtnTag != cell.btn4.tag{
                    cell.btn4.setTitle("D\(indexPath.item + 1)", for: .normal)
                    cell.btn4.setImage(nil, for: .normal)
                }else
                {
                    
                    cell.btn4.setTitle("", for: .normal)
                    cell.btn4.setImage(UIImage(named: "ic_checkmark"), for: .normal)
                    
                    cell.btn4.imageView?.contentMode = .scaleAspectFit
                }
            }
            else{
                print(indexPath.item + 1)
                cell.btn1.setTitle("A\(indexPath.item + 1)", for: .normal)
                cell.btn2.setTitle("B\(indexPath.item + 1)", for: .normal)
                cell.btn3.setTitle("C\(indexPath.item + 1)", for: .normal)
                cell.btn4.setTitle("D\(indexPath.item + 1)", for: .normal)
                
                cell.btn1.setImage(nil, for: .normal)
                cell.btn2.setImage(nil, for: .normal)
                cell.btn3.setImage(nil, for: .normal)
                cell.btn4.setImage(nil, for: .normal)
                
            }
            
            cell.btn1.addTarget(self, action: #selector(triggerActionHandler), for: .touchUpInside)
            cell.btn2.addTarget(self, action: #selector(triggerActionHandler), for: .touchUpInside)
            cell.btn3.addTarget(self, action: #selector(triggerActionHandler), for: .touchUpInside)
            cell.btn4.addTarget(self, action: #selector(triggerActionHandler), for: .touchUpInside)
            
           
                return cell
        }
        
        
    }
    
    @objc func triggerActionHandler(sender: UIButton) {
        
        if arrSelection.count <= ArrPassengerDetaails.count{
            
           
        
            if arrSelection.map({$0["CELLTAG"]}).contains(sender.superview!.tag){
                
                var sIndex = -1
                for i in 0..<arrSelection.count{
                    if arrSelection[i]["CELLTAG"] == sender.superview?.tag && arrSelection[i]["BTNTAG"] == sender.tag{
                      sIndex = -1
                        break
                    }
                    
                }
                
                if sIndex != -1{
                    arrSelection.remove(at: sIndex)
                    
                }
                else{
                    if arrSelection.count == ArrPassengerDetaails.count{
                        arrSelection[arrSelection.count - 1]["CELLTAG"] = sender.superview?.tag
                        arrSelection[arrSelection.count - 1]["BTNTAG"] = sender.tag
                    }else{
                    var tempDic = [String:Int]()
                    tempDic["CELLTAG"] = sender.superview?.tag
                    tempDic["BTNTAG"] = sender.tag
                    arrSelection.append(tempDic)
                    }
                }
                
               
                
            }
                
              
            
            else{
                if arrSelection.count == ArrPassengerDetaails.count{
                    arrSelection[arrSelection.count - 1]["CELLTAG"] = sender.superview?.tag
                    arrSelection[arrSelection.count - 1]["BTNTAG"] = sender.tag
                }else{
                var tempDic = [String:Int]()
                tempDic["CELLTAG"] = sender.superview?.tag
                tempDic["BTNTAG"] = sender.tag
                arrSelection.append(tempDic)
                }
            }
        
        
       
        }else{
            if arrSelection.map({$0["CELLTAG"]}).contains(sender.superview!.tag){
                
                var sIndex = -1
                for i in 0..<arrSelection.count{
                    if arrSelection[i]["CELLTAG"] == sender.superview?.tag && arrSelection[i]["BTNTAG"] == sender.tag{
                      sIndex = -1
                        break
                    }
                    
                }
                
                if sIndex != -1{
                    arrSelection.remove(at: sIndex)
                    
                }
            }
        }
        selectedbtnTag = sender.tag
        selectedCellTag = sender.superview!.tag
        
        ArrPassengerDetaails[arrSelection.count - 1]["seat"] = sender.titleLabel?.text
        ArrPassengerDetaails[arrSelection.count - 1]["class_type"] = ArrScheduledSeats[0]["classtype"] as? String
        
        print(ArrPassengerDetaails)
        passengerListCol.reloadData()
        
        seatCol.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == passengerListCol{
        return CGSize(width: passengerListCol.frame.width, height: 80)
        }
        else{
            return CGSize(width:seatCol.frame.width - 64, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == seatCol{
            return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
            
       
        
    }
    
}

//MARK:- API_CALL
extension SeatSelectionVC{
    
    func api_GetLayoutId()
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
                "_id": flightId,
                "schedule_id": scheduleId
            ]
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetLayout)", service: APIGetLayout, parameters: param as NSDictionary, keyname: APIGetLayout as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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
                            
                            self.fromCityCode = (data["airport"] as! NSDictionary)["from_airport_code"] as! String
                            self.toCityCode = (data["airport"] as! NSDictionary)["to_airport_code"] as! String
                            self.fromCity = (data["airport"] as! NSDictionary)["from_city"] as! String
                            self.toCity = (data["airport"] as! NSDictionary)["to_city"] as! String
                            self.flightDic = data["flights"] as! [String: Any]
                            self.airportDic = data["airport"] as! [String: String]
                            
                          //  self.seatSection = (data["schedule_seats"] as! NSArray).count
                            self.ArrScheduledSeats = (data["flights"] as! NSDictionary)["schedule_seats"] as! [[String: Any]]
                            let ptDetail = (data["flights"] as! NSDictionary)["ptdetail"] as! [[[String: Any]]]//data["ptdetail"] as! Array<Array<Dictionary<String, Any>>>
                            //print(ptDetail)
                            self.ArrPtDetail = ptDetail[0]
                          //  let def = abc
                            print(self.ArrPtDetail)
                            self.seatColHeight.constant = CGFloat((self.ArrScheduledSeats.compactMap { ($0["rows"] as? Int) }.reduce(0,+)) * 60) + 280.0
                            print(self.ArrScheduledSeats.compactMap { ($0["rows"] as? Int) })
                            self.passengerListCol.reloadData()
                            self.seatCol.reloadData()
                            
                            
                            
                           /*{
                            "success": true,
                            "airport": {
                                "from_airport_code": "MGQ",
                                "to_airport_code": "BLW",
                                "from_country": "Somalia",
                                "to_country": "Somalia",
                                "from_city": "Mogadishu",
                                "to_city": "Beledweyne"
                            },
                            "flights": {
                                "flight_id": "62bc45cd285855ee00731170",
                                "_id": "62bc45cd285855ee00731170",
                                "flight_number": "SD0105",
                                "schedule_id": "62bc46f9285855ee007326f4",
                                "from_city": "Mogadishu",
                                "to_city": "Beledweyne",
                                "from_airport_id": "613cdf6a97d599b6ad7a9eb6",
                                "to_airport_id": "61445c68f982c16e12489435",
                                "aircraft": "F-50",
                                "from_airport": "Aden Ade International",
                                "to_airport": "Beledweyne Airpot",
                                "departure_date": "2022-07-05T08:00:00.000Z",
                                "departure_time": "08:00",
                                "arrival_date": "2022-07-05T21:30:00.000Z",
                                "arrival_time": "21:30",
                                "schedule_seats": [
                                    {
                                        "classtype": "First Class",
                                        "rows": 12,
                                        "color": "#00FF00",
                                        "is_available_class": 1
                                    }
                                ],
                                "ticket_type": [
                                    "First Class"
                                ],
                                "passenger_type": [],
                                "fare": [],
                                "ptdetail": [
                                    [
                                        {
                                            "type": "Adult",
                                            "max": 2,
                                            "fare": 105
                                        },
                                        {
                                            "type": "Child",
                                            "max": 2,
                                            "fare": 85
                                        },
                                        {
                                            "type": "Infant",
                                            "max": 2,
                                            "fare": 20
                                        }
                                    ]
                                ],
                                "fare_id": [
                                    "62bc45ce285855ee0073117a"
                                ],
                                "layout_id": "627fb76b88f59e50b6f2b12f",
                                "reserved_class": [],
                                "reserved_seat": []
                            },
                            "layout": {
                                "_id": "627fb76b88f59e50b6f2b12f",
                                "seat_style": "2-2",
                                "number_indexer": 50,
                                "chars": [
                                    "A",
                                    "B",
                                    "C",
                                    "D"
                                ]
                            }
                        }*/
                               
                            
                        
                       
                        
                        }
                        
                    }
                }
            }
        }
    }
    
}

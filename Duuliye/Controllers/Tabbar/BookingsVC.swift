//
//  BookingsVC.swift
//  Duuliye
//
//  Created by Jay on 06/06/22.
//

import UIKit
import SwiftyJSON

class cell_Bookings:UICollectionViewCell {
    //MARK: - IBOutlets
   
}

class BookingsVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var bookingCol: UICollectionView!
    @IBOutlet weak var constraintLeadingUnderline: NSLayoutConstraint!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnCancelled: UIButton!
    
    var strStatus = "All"
    
    var arrHistory = [History]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAll.isSelected = true
        
        
        
        bookingCol.register(UINib(nibName: "BookingCell", bundle:   nil), forCellWithReuseIdentifier: "BookingCell")
        
        ticketHistory()
        
        bookingCol.reloadData()
        
        
        
        
    }
    
    //MARK: - Cutom Functions
    func disableAllButtons(){
        self.btnAll.isSelected = false
        self.btnPending.isSelected = false
        self.btnCompleted.isSelected = false
        self.btnCancelled.isSelected = false
    }
    
    //MARK: - IBActions
    @IBAction func btnAllBookingsAction(_ sender: UIButton) {
        self.disableAllButtons()
        self.btnAll.isSelected = true
        
        strStatus = "All"

        UIView.animate(withDuration: 0.5) {
            self.constraintLeadingUnderline.constant = 0.0
            self.view.layoutIfNeeded()
        }
        ticketHistory()
        
    }
    @IBAction func btnPendingBookingsAction(_ sender: UIButton) {
        self.disableAllButtons()
        self.btnPending.isSelected = true
        strStatus = "Pending"
        
        UIView.animate(withDuration: 0.5) {
            self.constraintLeadingUnderline.constant = UIScreen.main.bounds.size.width/4
            self.view.layoutIfNeeded()
        }
        ticketHistory()
    }
    @IBAction func btnCompletedBookingsAction(_ sender: UIButton) {
        self.disableAllButtons()
        self.btnCompleted.isSelected = true
        strStatus = "Completed"
        
        UIView.animate(withDuration: 0.5) {
            self.constraintLeadingUnderline.constant = UIScreen.main.bounds.size.width/4 * 2
            self.view.layoutIfNeeded()
        }
        ticketHistory()
    }
    @IBAction func btnCancelledBookingsAction(_ sender: UIButton) {
        self.disableAllButtons()
        self.btnCancelled.isSelected = true
        strStatus = "Cancelled"
        
        UIView.animate(withDuration: 0.5) {
            self.constraintLeadingUnderline.constant = UIScreen.main.bounds.size.width/4 * 3
            self.view.layoutIfNeeded()
        }
        ticketHistory()
    }
}
//MARK:- SERVICE_CALL
extension BookingsVC{
    func ticketHistory()
    {
        if isConnectedToNetwork() {
            
            var strUserId = ""
            var strToken = ""
            
            if let objUser = UserDefaultManager.getCustomObjFromUserDefaults(key: kUserInfo) as? ClassUser {
                strUserId  = objUser.userid ?? "0"
                strToken = objUser.token ?? ""
            }
            
          //  let strDate = Date.getCurrentDate(withFormat: "MM/dd/yyyy")
            
            let param:[String:Any] = [
                "token" : strToken,
                "user_id" : strUserId,
                "status": strStatus
                
            ]
            
            print(param as NSDictionary)
            
            
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APITicketHistory)", service: APITicketHistory, parameters: param as NSDictionary, keyname: APITicketHistory as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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
                            
                            self.arrHistory = [History]()
                            
                            if let HistoryData = data["data"] as? NSArray {
                                for i in 0 ..< (HistoryData.count) {
                                    if let dict = HistoryData.object(at: i) as? NSDictionary {
                                        self.arrHistory.append(History.init(json: JSON(dict)))
                                    }
                                }
                            }
                            self.bookingCol.reloadData()
                            self.bookingCol.isHidden = false

                       
                       
                        }
                        else{
                            hideLoaderHUD()
                            showMessage(data["message"] as! String)
                            self.bookingCol.isHidden = true
                        }
                    }
                }
            }
        }
    }
}

extension BookingsVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrHistory.count
       
    }
    
/*    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
       
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }*/
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
     //   let cell = shopCol.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as! ShopCell
        let cell = bookingCol.dequeueReusableCell(withReuseIdentifier: "BookingCell", for: indexPath) as! BookingCell
       // cell.backgroundColor = .red
        cell.lblAirline.text = arrHistory[indexPath.item].compname
        cell.lblFare.text = "\(arrHistory[indexPath.item].fare ?? 0) USD"
        cell.lblFromCity.text = arrHistory[indexPath.item].fromcity
        cell.lblToCity.text = arrHistory[indexPath.item].tocity
        cell.btnViewTicket.tag = indexPath.item
        cell.baseView.layer.borderColor = UIColor(red: 102/255, green: 188/255, blue: 55/255, alpha: 1.0).cgColor
        cell.baseView.layer.cornerRadius = 12.0
        cell.baseView.clipsToBounds = true
        cell.baseView.borderWidth = 1.5
        
        cell.btnViewTicket.addTarget(self, action: #selector(viewTicketTapped(_:)), for: .touchUpInside)
        
        cell.btnFlightInfo.tag = indexPath.item
        cell.btnFlightInfo.addTarget(self, action: #selector(flightInfoTapped(_:)), for: .touchUpInside)
      
        return cell
     
    }
    
    @objc func viewTicketTapped(_ sender: UIButton) {
        guard let url = URL(string: "\(Server_URL)\(arrHistory[sender.tag].ticketurl ?? "")") else { return }
        UIApplication.shared.open(url)
        /*let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idPDFVC) as! PDFVC
        vc.pdfURL = arrHistory[sender.tag].ticketurl ?? ""
      APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)*/
        
    }
    
    @objc func flightInfoTapped(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idFlightInfoVC) as! FlightInfoController
        vc.ticketId = arrHistory[sender.tag].ticketid ?? ""
      APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
    
    @objc func triggerActionHandler(sender: UIButton) {
        
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: bookingCol.frame.width, height: 220)
       
    }
    
 /*   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
       
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    }*/
    
}

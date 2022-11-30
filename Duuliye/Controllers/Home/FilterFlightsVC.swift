//
//  FilterFlightsVC.swift
//  Duuliye
//
//  Created by Jay on 08/06/22.
//

import UIKit
import PanModal
import SwiftyJSON

class cell_Filters:UITableViewCell {
    
   
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
}
class FilterFlightsVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tblFilters: UITableView!
    @IBOutlet weak var quickestFlightView: UIView!
    @IBOutlet weak var cheapestFlightViiew: UIView!
    @IBOutlet weak var btnCheapestFlight: UIButton!
    
    @IBOutlet weak var btnQuuickestFlight: UIButton!
    
    //MARK: - Global Variables
    
    var isShortFormEnabled = true
    var arrCompanyList = [Companies]()
    var companySelectedIndex = 0
    var selectedCompId = String()
    var isCheapest = true
    var CallBackToSFFillterFlight:((_ ischeapest: Bool, _ companyName: String)-> Void)!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api_GetCompanyList()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        quickestFlightView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cheapestFlightViiew.addGestureRecognizer(tap1)
        
        if isCheapest{
           
                btnCheapestFlight.isHidden = false
                btnQuuickestFlight.isHidden = true
                
            }
            else{
                btnQuuickestFlight.isHidden = false
                btnCheapestFlight.isHidden = true
               
           
        }
        
     //   btnCheapestFlight.isHidden = false
        
        
    }
    
    @IBAction func clleearAllTapped(_ sender: Any) {
        CallBackToSFFillterFlight(isCheapest, "")
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func FilterTapped(_ sender: Any) {
        CallBackToSFFillterFlight(isCheapest, arrCompanyList[companySelectedIndex].id!)
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if sender?.view?.tag == 100{
            btnCheapestFlight.isHidden = false
            btnQuuickestFlight.isHidden = true
            isCheapest = true
        }
        else{
            btnQuuickestFlight.isHidden = false
            btnCheapestFlight.isHidden = true
            isCheapest = false
        }
    }
   
}
//MARK: - UITableViewDelegate,UITableViewDataSource
extension FilterFlightsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompanyList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.tblFilters.dequeueReusableCell(withIdentifier: "cell_Filters") as! cell_Filters
        cell.lblCompany.text = arrCompanyList[indexPath.item].name
        
        if companySelectedIndex == indexPath.item{
            cell.btnSelection.isHidden = false
        }
        else{
            cell.btnSelection.isHidden = true
        }
        
        let strUrl = (arrCompanyList[indexPath.item].logo)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.imgCompanyLogo.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_selected_flights"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        companySelectedIndex = indexPath.row
        tblFilters.reloadData()
    }
}
//MARK: - PanModalPresentable
extension FilterFlightsVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return UIScrollView()
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset((UIScreen.main.bounds.size.height/2) - 100.0)
    }
    var shortFormHeight: PanModalHeight {
        return isShortFormEnabled ? .contentHeight(400.0) : longFormHeight
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    var showDragIndicator: Bool{
        return false
    }
    var allowsExtendedPanScrolling: Bool { return true }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}

extension FilterFlightsVC{
    func api_GetCompanyList()
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
            HttpRequestManager.sharedInstance.requestWithPostJsonParam(endpointurl: "\(Server_URL + APIGetCompanyList)", service: APIGetCompanyList, parameters: param as NSDictionary, keyname: APIGetCompanyList as NSString, message: "", showLoader: true) { error, responseArray, responseDict in
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
                                        self.arrCompanyList.append(Companies.init(json: JSON(dict)))
                                        if !self.selectedCompId.isEmpty{
                                            if self.arrCompanyList[i].id! == self.selectedCompId{
                                                self.companySelectedIndex = i
                                            }
                                        }
                                    }
                                }
                            }
                            print(self.arrCompanyList.count)
                            
                            self.tblFilters.reloadData()
                     
                        }
                        
                    }
                }
            }
        }
    }
}

//
//  PaymentListController.swift
//  Duuliye
//
//  Created by Developer on 13/10/22.
//

import UIKit

class cellListPayment: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
}

class PaymentListController: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    
    var strTotalFAre = String()
    var arrPAyment = [[String:String]]()
    var CallBackToSetVallue :((_ strTitle: String)-> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.separatorColor = .darkGray
        tblList.separatorStyle = .singleLine

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTotal.text = "Total \(strTotalFAre)"
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
extension PaymentListController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPAyment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblList.dequeueReusableCell(withIdentifier: "cellListPayment") as! cellListPayment
        
        cell.lblTitle.text = arrPAyment[indexPath.item]["name"]
        cell.lblSubTitle.text = arrPAyment[indexPath.item]["description"]
        
        let strUrl = (arrPAyment[indexPath.item]["icon"])!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.imgLogo.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_selected_flights"))
        
        
//        cell.llblCode.text = arrPAyment[indexPath.item].code
//
//        cell.llblCode.cornerRadius = cell.llblCode.frame.height/2
//        cell.llblCode.clipsToBounds = true
//
//        cell.lblCityName.text = arrFilterCityList[indexPath.item].cityName
//        cell.lblAirport.text = arrFilterCityList[indexPath.item].airportName
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CallBackToSetVallue(arrPAyment[indexPath.item]["name"] ?? "")
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
//        let selectedValue = (arrFilterCityList[indexPath.row].cityName!) + ", " + (arrFilterCityList[indexPath.row].code!)
//        
//        if strSelectedCity != selectedValue{
//        CallBackToSetVallue(selectedValue)
//        APP_DELEGATE.appNavigation?.popViewController(animated: true)
//        }
//        else{
//            showMessage("This City is Already Selected")
//          //  showAlertOnKeyWindow(title: "WRONG SELEECTION", strMessage: "This City is Already Selected", time: 1.5, completion:nil)
//        }
    }
}


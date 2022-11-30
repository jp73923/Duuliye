//
//  SearrchResultVC.swift
//  Duuliye
//
//  Created by Developer on 18/06/22.
//

import UIKit
import SDWebImage

class cellFlightSearch: UITableViewCell{
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgFlights: UIImageView!
    @IBOutlet weak var lblArrivalTiime: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblToFromCity: UILabel!
    
}

class SearrchResultVC: UIViewController {
    
    var arrFlights = [Flights]()
    var strTitle = String()
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblSearch: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearch.delegate = self
        tblSearch.dataSource = self
        
        lblTitle.text = strTitle

        // Do any additional setup after loading the view.
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

extension SearrchResultVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSearch.dequeueReusableCell(withIdentifier: "cellFlightSearch") as! cellFlightSearch
        
        cell.lblToFromCity.text = (arrFlights[indexPath.row].fromcity ?? "") + " - " + (arrFlights[indexPath.row].tocity ?? "")
        
       
        cell.imgFlights.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        let strUrl = (arrFlights[indexPath.row].complogo!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.imgFlights.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_selected_flights"))
        cell.lblDepartureTime.text = arrFlights[indexPath.item].departuretime
        cell.lblArrivalTiime.text = arrFlights[indexPath.item].arrivaltime
        cell.lblFare.text = (arrFlights[indexPath.item].curency!.suffix(1)) + " " + "\(arrFlights[indexPath.item].fare ?? 0)"
        
        let dateFormatter = DateFormatter()
        //2022-06-21T08:30:00.000Z
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        let dtDate = dateFormatter.date(from: arrFlights[indexPath.item].departuredate!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd, yyyy"
        cell.lblDate.text = dateFormatter1.string(from: dtDate ?? Date())
        
        
       // print(dateFormatter1.date(from: cell.lblDate.text!)?.dayOfWeek())
        cell.lblDay.text = (dateFormatter1.date(from: cell.lblDate.text!))?.weekdayNameFull
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idAddPassengerListVC) as! AddingPassengersVC
        vc.strTitlle = (arrFlights[indexPath.row].fromcity ?? "") + " - " + (arrFlights[indexPath.row].tocity ?? "")
        vc.strFlight = arrFlights[indexPath.row].complogo!
        vc.strFlightCompany = arrFlights[indexPath.row].compname!
        vc.strDepartureTime = arrFlights[indexPath.item].departuretime ?? ""
        vc.strArrivalTime = arrFlights[indexPath.item].arrivaltime ?? ""
        vc.strFare = (arrFlights[indexPath.item].curency!.suffix(1)) + " " + "\(arrFlights[indexPath.item].fare ?? 0)"
        vc.selectedid = arrFlights[indexPath.item].id ?? ""
        vc.scheduleId = arrFlights[indexPath.item].scheduleid ?? ""
        
        let dateFormatter = DateFormatter()
        //2022-06-21T08:30:00.000Z
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        let dtDate = dateFormatter.date(from: arrFlights[indexPath.item].departuredate!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM yyyy"
        vc.strDate = dateFormatter1.string(from: dtDate ?? Date())
        
        
       // print(dateFormatter1.date(from: cell.lblDate.text!)?.dayOfWeek())
        vc.strDay = (dateFormatter1.date(from: vc.strDate))!.weekdayNameFull
       
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
}

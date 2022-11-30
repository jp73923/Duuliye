//
//  PDFormVC.swift
//  Duuliye
//
//  Created by Developer on 28/06/22.
//

import UIKit
import PanModal

class PDFormVC: UIViewController {
    
    var isLapInfant = Int()
    var firstName = String()
    var lastName = String()
    var passport = String()
    var Phone = String()
    var infantFirstName = String()
    var infantLastName = String()
    
    
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
        @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtPPassport: UITextField!
    @IBOutlet weak var txtPFirstName: UITextField!
    @IBOutlet weak var txtPLastName: UITextField!
    @IBOutlet weak var txtPPhone: UITextField!
    @IBOutlet weak var PLastName: UITextField!
    @IBOutlet weak var inffantStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var infantStackView: UIStackView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblInfant: UILabel!
    @IBOutlet weak var lblPDCaption: UILabel!
    
    var isShortFormEnabled = true
   // :((_ Adults: Int, _ Child: Int, _ Infants: Int)-> Void)!
    var CallBackToSetPassengerDetails:((_ FirstName: String, _ LastName: String, _ Passport: String, _ PhoneNo: String, _ infantFirstName: String, _ infantLastName: String)-> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if isLapInfant != 1{
            self.infantStackView.isHidden = false
            self.inffantStackViewHeight.constant = 0
            lbl1.isHidden = true
            lbl2.isHidden = true
            lblInfant.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLayoutSubviews()
        txtPPhone.addBottomBorder(.darkGray)
        txtLastName.addBottomBorder(.darkGray)
        txtFirstName.addBottomBorder(.darkGray)
        txtPPassport.addBottomBorder(.darkGray)
        txtPFirstName.addBottomBorder(.darkGray)
        txtPLastName.addBottomBorder(.darkGray)
        
        txtPFirstName.text = firstName
        txtPLastName.text = lastName
        txtPPassport.text = passport
        txtPPhone.text = Phone
        txtFirstName.text = infantFirstName
        txtLastName.text = infantLastName
    }
    
    override func viewDidLayoutSubviews() {
       
        
        
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        CallBackToSetPassengerDetails(txtPFirstName.text ?? "",txtPLastName.text ?? "",txtPPassport.text ?? "",txtPPhone.text ?? "" ,txtFirstName.text ?? "" ,txtLastName.text ?? "")
        self.dismiss(animated: true, completion: nil)
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

//MARK: - PanModalPresentable
extension PDFormVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return UIScrollView()
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(isLapInfant == 1 ? (UIScreen.main.bounds.size.height/2) - 250 : (UIScreen.main.bounds.size.height/2) - 180)
    }
    var shortFormHeight: PanModalHeight {
        print(#function,isShortFormEnabled,longFormHeight)
        return .maxHeight
       // return isShortFormEnabled ? .contentHeight(isLapInfant == 1 ? 500.0 : (UIScreen.main.bounds.size.height/2)) : longFormHeight
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


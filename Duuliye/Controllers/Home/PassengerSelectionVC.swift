//
//  PassengerSelectionVC.swift
//  Duuliye
//
//  Created by Jay on 07/06/22.
//

import UIKit
import PanModal

class PassengerSelectionVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var lblAdultsCount: UILabel!
    @IBOutlet weak var lblChildrenCount: UILabel!
    @IBOutlet weak var lblInfantsCount: UILabel!
    
    

    //MARK: - Global Variables
    var isShortFormEnabled = true
    var adults = 1
    var child = 0
    var infants = 0
    
    var CallBackToSetPassengers:((_ Adults: Int, _ Child: Int, _ Infants: Int)-> Void)!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBActions
    @IBAction func btnAdultsIncreaseDecreaseAction(_ sender: UIButton) {
        if sender.tag == 1 {
            adults = adults + 1
        } else {
            adults = adults - 1
        }
        if adults > 0 {
            self.lblAdultsCount.text = "\(adults)"
        }
    }
    @IBAction func btnChildrenIncreaseDecreaseAction(_ sender: UIButton) {
        if sender.tag == 1 {
            child = child + 1
        } else {
            child = child - 1
        }
        if child >= 0 {
            self.lblChildrenCount.text = "\(child)"
        }
    }
    @IBAction func btnInfantsIncreaseDecreaseAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            if infants + 1 <= Int(lblAdultsCount.text!)!{
                infants = infants + 1
            }
        } else {
            infants = infants - 1
        }
        
        if infants >= 0 {
            self.lblInfantsCount.text = "\(infants)"
        }
    }
    @IBAction func btnDoneAction(_ sender: UIButton) {
        
        CallBackToSetPassengers(adults, child, infants)
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - PanModalPresentable
extension PassengerSelectionVC: PanModalPresentable {
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

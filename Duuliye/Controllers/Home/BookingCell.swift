//
//  BookingCell.swift
//  Duuliye
//
//  Created by Developer on 01/08/22.
//

import UIKit

class BookingCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var btnFlightInfo: UIButton!
    @IBOutlet weak var btnViewTicket: UIButton!
    @IBOutlet weak var lblToCity: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblFromCity: UILabel!
    @IBOutlet weak var lblAirline: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

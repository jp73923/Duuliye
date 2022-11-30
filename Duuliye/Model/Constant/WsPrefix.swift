//
//  Constants.swift
//
//  Created by C237 on 30/10/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

let GET = "GET"
let POST = "POST"
let MEDIA = "MEDIA"

let DEFAULT_TIMEOUT:TimeInterval = 60.0
let Fetch_Data_Limit:NSInteger = 50

//MARK:- API URL
let Server_URL = "https://api.duuliye.com/ios/"
let Image_Server_URL = "https://themaxdeal.com/maximizer/images/"


//MARK:- RESPONSE KEY
let kData = "data"
let kMessage = "message"
let kStatus = "StatusCode"
let kToken = "token"
let kFCMToken = "UDFCMToken"
let kCode = "code"
let kSuccess = "status"
let kSuccessCode = "status_code"
let kUserInfo = "userinfo"
let kErrors = "errors"
let kMarket = "market"
let kHeader = "header"
let kBrand = "brand"

//MARK:- API SERVICE NAMES
let APILogin = "verification"
let APIUpdateUserData = "update_user_data"
let APIsave_feedback = "save_feedback"
let APIGetUserData = "get_user_data"
let APISearch = "search"
let APIOnlyToday = "only_today"
let APITodayFlights = "today_flights"
let APITicketHistory = "ticket_history"
let APIBookingDetail = "booking_detail"
let APIVerifyPIN = "verify_pin"
let APIRegister = "save_user"
let APIGetCities = "get_city"
let APIGetCityList = "cities"
let APIGetCountryList = "get_countires"
let APIGetLayout = "get_layout"
let APISave_booking = "save_booking_new"//"save_booking_ios"//"X/save_booking"
let APIGetPaymentMethod = "get_payment_method"
let APIGetCompanyList = "companies"
let APIlogout = "logout"
let APIDeleteUser = "delete_user"

//MARK:- API Key
let APIResponseKey = "data"

//MARK:- Error Message
let SomethingWentWrongErr = "Something went wrong"

//
//  KeyNamesConstants.swift
//  ELFramework
//
//  Created by Admin on 14/12/17.
//  Copyright © 2017 EL. All rights reserved.
//

import Foundation
import UIKit

struct SOCIAL {
    static let FACEBOOK = 1
    static let GOOGLE  = 2
    static let TWITTER = 3
    static let INSTAGRAM = 4
    static let APPLE = 5
}

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
//AIzaSyBSw0El1uuzq0hlYkETRb1YshIEimKJEFI


//MARK:- STORY BOARD NAMES

public let SB_MAIN :String = "Main"
public let SB_TABBAR :String = "Tabbar"

//MARK:- CONTROLLERS ID
public let idLoginVC   = "LoginVC"
public let idSignUpVC   = "RegisterationVC"
public let idVerificationVC = "VerificationVC"
public let idCityListVC = "CityListVC"
public let idCountryListVC = "CountrListVC"
public let idSearchListVC = "SearchListVC"
public let idAddPassengerListVC = "AddPassengerListVC"
public let idPaymentPreviewVC = "PaymentPreviewVC"
public let idPaymentList = "PaymentList"
public let idPDFVC = "PDF"
public let idFlightInfoVC = "FlightInfo"
public let idSeatSelectionVC = "SeatSelectionVC"
public let idFeedbackVC = "FB"
public let idProfileDetailVC = "ProfileDetailVC"
public let idUpdateProfileVC = "UpdateProfileVC"
public let idVerifyVC = "VerifyVC"
public let idHomeVC = "HomeVC"
public let idTabbarVC = "TabbarVC"
public let idPassengerSelectionVC = "PassengerSelectionVC"
public let idPassengerFormsVC = "PassengerFormVC"
public let idFilterFlightsVC = "FilterFlightsVC"



//MARK:- USER DEFAULTS KEY
let kAccessToken = "UDAccessToken"
let kTokenType = "UDTokenType"
let kIsLoggedIn:String = "UDLoggedIn"
let kAppDeviceToken:String = "UDDeviceToken"
let kAppUser = "User"
let kAppUserId =  "UserId"
let kAppLoginPin =  "UDLoginPin"
let kIsLocationOn =  "IsLocationOn"


//MARK:- LocalNotification Identifier
let NC_HomeRefresh = "HomeRefresh"
let NC_NotifyMe = "NotifyMe"


//MARK:- IMAGE
let UserPlaceholderImage:UIImage = UIImage.init(named: "img_user")!


//MARK:- FONT NAMES
//let FT_Italic = "Poppins-Italic"
let FT_Medium = "Montserrat-SemiBold"
let FT_Regular = "Montserrat-Regular"
let FT_Bold = "Montserrat-Bold"
let FT_Light = "Montserrat-Light"
let FT_Black = "Montserrat-Black"

//MARK: - Enum App Color
enum ColorCodes: String {
    //APP Color
    case app_dark_green
    case app_light_green
    case app_golden
    //Border Color
    case border_light_blue
    //Text Color
    case text_dark_gray
    case text_light_gray
}

//MARK:- COLOR NAMES
let themeGrayColor = Color_Hex(hex: "#999999")
let themeLightGreenColor = RGBA(40, 94, 99, 0.3)
let themeGreenColor = RGBA(40, 94, 99, 1.0)
let themeAppWhiteLightColor = RGBA(255, 255, 255, 0.6)
let themeAppWhiteExtraLightColor = RGBA(255, 255, 255, 0.1)

//let COLOR_PopupBG = themeAppRedColor//RGBA(0, 0, 0, 0.750)

//MARK:- MESSAGES
let ServerResponseError = "Server Response Error"
let RetryMessage = "Something went wrong please try again..."
let InternetNotAvailable = "Internet connection appears to be offline."
let EnterOTP = "Please enter OTP"
let EnterMobile = "Please enter mobile number"
let EnterMobileLength = "Mobile number length is not correct"
let EnterVerification = "Please enter verification code"
let EnterFullname = "Please enter Full Name"
let EnterUsername = "Please enter Username"
let EnterAlphaNumeric = "Please enter Alphanumeric only"
let EnterFirstname = "Please enter First Name"
let EnterLastname = "Please enter Last Name"
let EnterPassport = "Please enter Passport No"
let EnterWalletAddress = "Please enter wallet address"
let EnterValidWalletAddress = "Please enter valid wallet address"
let EnterPin = "Please enter valid pin"
let EnterPinMatch = "Entered pin doesn't match!"
let EnterCurrentPassword = "Please Enter Current Password"
let EnterNewPassword = "Please Enter New Password"
let EnterPassword = "Please Enter Password"
let EnterCurrentPass = "Please Enter Current Password"
let EnterReTypePassword = "Please Re-Enter Password"
let EnterPasswordLength = "Password length should be eight"
let EnterEmailPhone = "Email address or Phone number is required"
let EnterEmail = "Please Enter Email"
let EnterPhone = "Please Enter Phone Number"
let EnterGender = "Please Enter Gender"
let EnterVaildEmail = "Please Enter Valid Email Address"
let EnterMisMatchPassword = "Password is Mismatch"
let EnterName = "Please Enter Name"
let EnterEventName = "Please Enter Event Name"
let EnterPackage = "Please Select Package"
let EnterProfit = "Please Enter Profit Ratio"
let EnterIssue = "Please Select Issue Type"
let EnterSubject = "Please Enter Subject"
let EnterMessage = "Please Enter Message"
let EnterDescription = "Please Enter Description"
let EnterVaildOTP = "Please Enter Valid OTP"
let EnterExecutiveCode = "Please Enter Executive Code"
//
let SelectMessage = "Please Select Hashtag"
let SelectCategory = "Please Select Category"
let EnterOrScanCoupan = "Please Enter Code or Scan QR code"
let EnterBillNumber = "Please Enter Bill Number"
let SelectPaymentOption = "Please Select Payment Option"
let EnterPromoCode = "Please Enter Promo Code"
let EnterQuantity = "Please Enter Quantity"


//MARK:- Messages
let msgLocationService = "Location services are disabled, Please enable from Settings"

//MARK:- Devices
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
//
let is_iPhone4 = (isPhone && UIScreen.main.bounds.size.height == 480.0)
let is_iPhone5 = (isPhone && UIScreen.main.bounds.size.height == 568.0)
let is_iPhone678 = (isPhone && UIScreen.main.bounds.size.height == 667.0)
let is_iPhone678Plus = (isPhone && UIScreen.main.bounds.size.height == 736.0)
let is_iPhoneX = (isPhone && UIScreen.main.bounds.size.height == 812.0)
let is_iPhoneXRXmax = (isPhone && UIScreen.main.bounds.size.height == 896.0)


//MARK: - User Default Key
let UD_AppLanguage = "UDAppLanguage"
let UD_AppCountryCode = "UDAppCountryCode"
let UD_AccessToken = "UD_Token"
let UD_LoginUser = "UD_LoginUser"
let UD_PushyToken = "UD_PushyToken"
let UD_PasscodePin = "UD_PasscodePin"
let UD_UserData = "UD_UserData"
//
let UD_AppCountryName = "UDAppCountryName"
let UD_AppSettings = "UDAppSettings"
let UD_AppCurrency = "UDAppCurrency"
let UD_AppTimeZone = "UDAppTimeZone"
let UD_CountryID = "UDAppCountryID"
//
let UD_NotifyMe = "UDNotifyMe"
let UD_UserProfiledata = "UDUserProfiledata"
let UD_OtherUserProfiledata = "UDOtherUserProfiledata"


let preferredLanguage = NSLocale.preferredLanguages[0]

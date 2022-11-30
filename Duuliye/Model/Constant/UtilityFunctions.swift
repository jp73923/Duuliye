//
//  constant.swift

import Foundation
import UIKit
import CoreLocation
import SystemConfiguration
import AVFoundation
import SwiftMessages
import Photos
//import FirebaseDynamicLinks

var vw = UIView()
//let activityView = ActivityIndicators.create(.dashed)
var topbar : CGFloat{
    return UIApplication.shared.statusBarFrame.size.height + 50
}

struct DIRECTORY_NAME
{
    public static let IMAGES = "Images"
    public static let VIDEOS = "Videos"
    public static let DOWNLOAD_VIDEOS = "Download_videos"
}

public let isSimulator: Bool = {
    var isSim = false
    #if arch(i386) || arch(x86_64)
    isSim = true
    #endif
    return isSim
}()

var myDeviceToken: String = "testDeviceToken"
var myDeviceType: String = "I"
var appEnvironment: String = "test"

var CurrentLatitude = Double()
var CurrentLongitude = Double()
var CurrentAddress = ""

//MARK:- iOS Versions and screens

public var appDisplayName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

public var appBundleID: String? {
    return Bundle.main.bundleIdentifier
}

public func IOS_VERSION() -> String {
    return UIDevice.current.systemVersion
}

public var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}

public var applicationIconBadgeNumber: Int {
    get {
        return UIApplication.shared.applicationIconBadgeNumber
    }
    set {
        UIApplication.shared.applicationIconBadgeNumber = newValue
    }
}

public var appVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

public func SCREENWIDTH() -> CGFloat
{
    let screenSize = UIScreen.main.bounds
    return screenSize.width
}

public func SCREENHEIGHT() -> CGFloat
{
    let screenSize = UIScreen.main.bounds
    return screenSize.height
}

func GetAPIToken() -> String {
    if(UserDefaults.standard.string(forKey: UD_AccessToken) == nil) {
        return ""
    } else {
        return "Bearer \(UserDefaults.standard.string(forKey: UD_AccessToken)!)"
    }
}

func saveInUserDefault(obj: AnyObject, key: String) {
    UserDefaults.standard.set(obj, forKey: key)
    UserDefaults.standard.synchronize()
}

func getUserInfo() -> NSDictionary {
    var dictUser: NSDictionary = NSDictionary()
    if let dictData = UserDefaults.standard.value(forKey: kUserInfo) as? NSDictionary {
        dictUser = dictData
    }
    return dictUser
}


func getUserID() -> String {
    if(UserDefaults.standard.string(forKey: kAppUserId) == nil) {
        return UserDefaults.standard.string(forKey: kAppUserId) ?? ""
        
    } else {
        return "\(UserDefaults.standard.string(forKey: kAppUserId)!)"
    }
}

func getCountryID() -> String {
    if(UserDefaults.standard.string(forKey: UD_AppCountryCode) == nil) {
        return ""
    } else {
        return "\(UserDefaults.standard.string(forKey: UD_AppCountryCode)!)"
    }
}


//MARK:- Get User Type
func getPushyToken() -> String {
    let balance = UserDefaultManager.getStringFromUserDefaults(key: UD_PushyToken)
    return balance
}


//MARK:-  Get VC
public func getStoryboard(storyboardName: String) -> UIStoryboard {
    return UIStoryboard(name: storyboardName, bundle: nil)
}

public func loadVC(strStoryboardId: String, strVCId: String) -> UIViewController {
    
    let vc = getStoryboard(storyboardName: strStoryboardId).instantiateViewController(withIdentifier: strVCId)
    return vc
}

public func showLoaderHUD()
{
    LoadingHud.showHUDText()
}

public func hideLoaderHUD()
{
    LoadingHud.dismissHUD()
}


func compressImage(image:UIImage) -> Data
{
    var compression:CGFloat!
    let maxCompression:CGFloat!
    compression = 0.9
    maxCompression = 0.1
    var imageData = image.jpegData(compressionQuality: compression)
    
    while (imageData!.count > 10 && compression > maxCompression)
    {
        compression = compression - 0.10
        imageData = image.jpegData(compressionQuality: compression)
    }
    return imageData!
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}


func setNoDataLabel(tableView:UITableView, array:NSMutableArray, text:String) -> Int
{
    var numOfSections = 0
    
    if array.count != 0 {
        tableView.backgroundView = nil
        numOfSections = 1
    } else {
        let noDataLabel = UILabel()
        noDataLabel.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: tableView.frame.size.height)
        noDataLabel.text = text
        noDataLabel.numberOfLines = 0
        noDataLabel.textColor = UIColor.darkGray
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataLabel.font = UIFont.init(name: FT_Medium, size: 20)
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = .none
    }
    
    return numOfSections
}

class DropShadowView: UIView {
    var presetCornerRadius : CGFloat = 25.0
    
    override var bounds: CGRect {
        didSet {
            setupShadowPath()
        }
    }
    
    private func setupShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: presetCornerRadius).cgPath
    }
    
}

//MARK:- Network indicator
public func ShowNetworkIndicator(xx :Bool)
{
    runOnMainThreadWithoutDeadlock {
        UIApplication.shared.isNetworkActivityIndicatorVisible = xx
    }
}

//MARK:- Share


//MARK:- Number
public func suffixNumber(number:NSNumber) -> NSString  {
    
    let number = number.doubleValue
    let thousand = number / 1000
    let million = number / 1000000
    if million >= 1.0 {
        return "\(round(million*10)/10)M" as NSString
    }
    else if thousand >= 1.0 {
        return "\(round(thousand*10)/10)K" as NSString
    }
    else {
        return "\(Int(number))" as NSString
    }
}

//MARK:- Validation
public func TRIM(string: Any) -> String
{
    return (string as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}

public func validateTxtLength(_ txtVal: String, withMessage msg: String) -> Bool {
    if TRIM(string: txtVal).count == 0
    {
        showMessage(msg);
        return false
    }
    return true
}

public func validateTxtFieldLength(_ txtVal: UITextField, withMessage msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count == 0
    {
        txtVal.shake()
        showMessage(msg);
        return false
    }
    return true
}

public func validateMinTxtFieldLength(_ txtVal: UITextField, lenght:Int, msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count < lenght
    {
        txtVal.shake()
        showMessage(msg);
        return false
    }
    return true
}

public func validateMaxTxtFieldLength(_ txtVal: UITextField, lenght:Int,msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count > lenght
    {
        txtVal.shake()
        showMessage(msg);
        return false
    }
    return true
}

public func validateEqualTxtFieldLength(_ txtVal: UITextField, lenght:Int,msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count != lenght
    {
        txtVal.shake()
        showMessage(msg);
        return false
    }
    return true
}

public func passwordMismatch(_ txtVal: UITextField, _ txtVal1: UITextField, withMessage msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "") != TRIM(string: txtVal1.text ?? "")
    {
        txtVal1.shake()
        showMessage(msg);
        return false
    }
    return true
}

public func validateEmailAddress(_ txtVal: UITextField ,withMessage msg: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    if(emailTest.evaluate(with: txtVal.text) != true)
    {
        txtVal.shake()
        showMessage(msg);
        return false
    }
    return true
}

public func isBase64(stringBase64:String) -> Bool
{
    let regex = "([A-Za-z0-9+/]{4})*" + "([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)"
    let test = NSPredicate(format:"SELF MATCHES %@", regex)
    if(test.evaluate(with: stringBase64) != true)
    {
        return false
    }
    return true
}

//MARK:- Check Internet connection
func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    })
        else
    {
        return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let available =  (isReachable && !needsConnection)
    if(available)
    {
        return true
    }
    else
    {
        showMessage(InternetNotAvailable)
        return false
    }
}

//MARK:- Helper
public func TableEmptyMessage(modulename:String, tbl:UITableView) {
    let uiview = UIView(frame: Frame_XYWH(0, 0, tbl.frame.size.width, tbl.frame.size.height))
    let messageLabel = UILabel(frame: Frame_XYWH(30, 0, SCREENWIDTH() - 60, 50))
    messageLabel.font = UIFont.init(name: FT_Regular, size: 15)
    messageLabel.text = modulename //"\("No " + modulename + " Available.")"
    messageLabel.textColor = themeGreenColor
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    
    if(modulename.count > 0) {
        messageLabel.setViewBottomBorder(borderColor: themeAppWhiteExtraLightColor)
    }
    uiview.addSubview(messageLabel)
    tbl.backgroundView = uiview;
    //tbl.separatorStyle = .singleLine;
}

public func CollectionEmptyMessage(modulename:String, tbl:UICollectionView) {
    let uiview = UIView(frame: Frame_XYWH(0, 0, tbl.frame.size.width, tbl.frame.size.height))
    let messageLabel = UILabel(frame: Frame_XYWH(30, 0, SCREENWIDTH() - 60, 50))
    messageLabel.font = UIFont.init(name: FT_Regular, size: 15)
    messageLabel.text = modulename //"\("No " + modulename + " Available.")"
    messageLabel.textColor = themeAppWhiteLightColor
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    
    if(modulename.count > 0) {
        messageLabel.setViewBottomBorder(borderColor: themeAppWhiteExtraLightColor)
    }
    uiview.addSubview(messageLabel)
    tbl.backgroundView = uiview;
    //tbl.separatorStyle = .singleLine;
}

public func TableEmptyMessageCenter(modulename:String, tbl:UITableView, _ isCenter: Bool) {
   
    var strY = 0.0
    var strH = tbl.frame.size.height
    var uiview = UIView()
    if isCenter {
        //strY =  Double(uiview.center.y)
        strH =  CGFloat(Double(SCREENHEIGHT() - 300))
    }
    uiview = UIView(frame: Frame_XYWH(0, 0, tbl.frame.size.width, CGFloat(strH)))
    
    if isCenter {
           strY =  Double(uiview.center.y)
       }
    let messageLabel = UILabel(frame: Frame_XYWH(30, CGFloat(strY), SCREENWIDTH() - 60, 50))
    messageLabel.font = UIFont.init(name: FT_Regular, size: 15)
    messageLabel.text = modulename //"\("No " + modulename + " Available.")"
    messageLabel.textColor = themeGrayColor
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    
    if(modulename.count > 0) {
        messageLabel.setViewBottomBorder(borderColor: themeAppWhiteExtraLightColor)
    }
    uiview.addSubview(messageLabel)
    tbl.backgroundView = uiview;
    //tbl.separatorStyle = .singleLine;
}

public func CollectionEmptyMessageCenter(modulename:String, coll:UICollectionView, _ isCenter: Bool) {
   
    var strY = 0.0
    var strH = coll.frame.size.height
    var uiview = UIView()
    if isCenter {
        //strY =  Double(uiview.center.y)
        strH =  CGFloat(Double(SCREENHEIGHT() - 300))
    }
    uiview = UIView(frame: Frame_XYWH(0, 0, coll.frame.size.width, CGFloat(strH)))
    
    if isCenter {
           strY =  Double(uiview.center.y)
       }
    let messageLabel = UILabel(frame: Frame_XYWH(30, CGFloat(strY), SCREENWIDTH() - 60, 50))
    messageLabel.font = UIFont.init(name: FT_Regular, size: 15)
    messageLabel.text = modulename //"\("No " + modulename + " Available.")"
    messageLabel.textColor = themeAppWhiteLightColor
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    
    if(modulename.count > 0) {
        messageLabel.setViewBottomBorder(borderColor: themeAppWhiteExtraLightColor)
    }
    uiview.addSubview(messageLabel)
    coll.backgroundView = uiview;
    //tbl.separatorStyle = .singleLine;
}


func checkSearchBarActive(searchFriends:UISearchBar) -> Bool {
    if searchFriends.isFirstResponder && searchFriends.text != "" {
        return true
    }
    else if(searchFriends.text != "")
    {
        return true
    }
    else {
        return false
    }
}
//MARK:-  Check Device is iPad or not

public  var isPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

public var isPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

public var isStatusBarHidden: Bool
{
    get {
        return UIApplication.shared.isStatusBarHidden
    }
    set {
        UIApplication.shared.isStatusBarHidden = newValue
    }
}

public var mostTopViewController: UIViewController? {
    get {
        let mostTop = UIApplication.shared.keyWindow?.rootViewController
        if let mostTopPresented = mostTop?.presentedViewController{
            return mostTopPresented
        }
        return mostTop
    }
    set {
        UIApplication.shared.keyWindow?.rootViewController = newValue
    }
}

//MARK:- Random str
func randomString(length: Int) -> String
{
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

func randomString() -> String
{
    var text = ""
    text = text.appending(CurrentTimeStamp)
    text = text.replacingOccurrences(of: ".", with: "")
    return text
}
//MARK:- Font
public func FontWithSize(_ fname: String,_ fsize: Int) -> UIFont
{
    return UIFont(name: fname, size: CGFloat(fsize)) ?? UIFont.init()
}

//MARK:- Color
func setColor(_ color: ColorCodes) -> UIColor {
    return UIColor(named: color.rawValue)!
}

//MARK:- Color
public func Color_RGBA(_ R: Int,_ G: Int,_ B: Int,_ A: Int) -> UIColor
{
    return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha :CGFloat(A))
}
public func RGBA(_ R: Int,_ G: Int,_ B: Int,_ A: CGFloat) -> UIColor
{
    return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha :A)
}
public func Color_Hex(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
public func createGradientLayer(view:UIView,colorset:[UIColor],framerect:CGRect)
{
    let layer = CAGradientLayer()
    layer.frame = framerect
    layer.colors = colorset
    view.layer.addSublayer(layer)
}

public func hideMessage()
{
     //AJMessage.hide()
    SwiftMessages.hide()
}

public func showMessageWithRetry(_ bodymsg:String ,_ msgtype:Int,buttonTapHandler: ((_ button: UIButton) -> Void)?)
{
    //Work in progress
}

/*public func showMessage(_ bodymsg:String)
{
    hideMessage()
    AJMessage.show(title: "", message: bodymsg, duration: 2.0, position: .top
        , status: .info)
}*/

public func showMessage(_ bodymsg:String)
{
    let warning = MessageView.viewFromNib(layout: .cardView)
    warning.configureTheme(.warning)
    warning.configureDropShadow()
    warning.configureTheme(backgroundColor: themeGrayColor, foregroundColor: .white, iconImage: UIImage.init(named: "ic_warning"), iconText: "")
    warning.configureContent(title: bodymsg, body: "", iconText: "")
    warning.button?.isHidden = true
    var warningConfig = SwiftMessages.defaultConfig
    warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
    SwiftMessages.show(config: warningConfig, view: warning)
}

public func showMessageNew(_ bodymsg:String)
{
    let view = MessageView.viewFromNib(layout: .statusLine)
    var config = SwiftMessages.Config()
    
    // Disable the default auto-hiding behavior.
    config.duration = .seconds(seconds: 10)

    view.configureDropShadow()
    view.configureContent(body: bodymsg)
    view.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    view.configureTheme(backgroundColor: setColor(.app_light_green), foregroundColor: .white, iconImage: UIImage.init(named: "ic_warning"), iconText: "")
    view.bodyLabel?.font = FontWithSize(FT_Medium, 15)
    view.titleLabel?.isHidden = true
    view.button?.isHidden = true
    //    view.iconImageView?.isHidden = true
    view.iconLabel?.isHidden = true
    SwiftMessages.show(view: view)
}

//MARK:- Frames
public func Frame_XYWH(_ originx: CGFloat,_ originy: CGFloat,_ fwidth: CGFloat,_ fheight: CGFloat) -> CGRect
{
    return CGRect(x: originx, y:originy, width: fwidth, height: fheight)
}

public func randomColor() -> UIColor
{
    let r: UInt32 = arc4random_uniform(255)
    let g: UInt32 = arc4random_uniform(255)
    let b: UInt32 = arc4random_uniform(255)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
}

//MARK:- Platform
struct Platform
{
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

//MARK:- Time Processing
func covertTimeToLocalZone(time:String) -> Date
{
    let dateFormat = "yyyy-MM-dd HH:mm:ss"
    let inputTimeZone = NSTimeZone(abbreviation: "UTC")
    let inputDateFormatter = DateFormatter()
    inputDateFormatter.timeZone = inputTimeZone as TimeZone?
    inputDateFormatter.dateFormat = dateFormat
    let date = inputDateFormatter.date(from: time)
    let outputTimeZone = NSTimeZone.local
    let outputDateFormatter = DateFormatter()
    outputDateFormatter.timeZone = outputTimeZone
    outputDateFormatter.dateFormat = dateFormat
    let outputString = outputDateFormatter.string(from: date!)
    return outputDateFormatter.date(from: outputString)! as Date
}

public var CurrentTimeStamp: String
{
    return "\(Int64(Date().timeIntervalSince1970 * 1000))"
}

//MARK:- Time Ago Function

func timeAgoSinceStrDate(strDate:String, numericDates:Bool) -> String{
    
    let date = convertDateAccordingDeviceTime(dategiven: strDate)
    
    //PV
    return timeAgoSinceDate(date: date as Date, numericDates: numericDates)
    //return DateFormater.generateTimeForGivenDate(strDate: date)
}

func timeAgoSinceDate(date:Date, numericDates:Bool) -> String
{
    let calendar = NSCalendar.current
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let now = NSDate()
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
    if (components.year! >= 2)
    {
        return "\(components.year!)" + " years ago"
    }
    else if (components.year! >= 1)
    {
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    }
    else if (components.month! >= 2) {
        return "\(components.month!)" + " months ago"
    }
    else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    }
    else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)" + " weeks ago"
    }
    else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    }
    else if (components.day! >= 2) {
        return "\(components.day!)" + " days ago"
    }
    else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    }
    else if (components.hour! >= 2) {
        return "\(components.hour!)" + " hours ago"
    }
    else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour"
        }
    }
    else if (components.minute! >= 2)
    {
        return "\(components.minute!)" + " min ago"
    } else if (components.minute! > 1){
        if (numericDates){
            return "1 min ago"
        } else {
            return "A min"
        }
    }
    else if (components.second! >= 3) {
        return "\(components.second!)" + " sec ago"
    } else {
        return "now"
    }
}

func convertDateAccordingDeviceTime(dategiven:String) -> NSDate
{
    if dategiven.contains("null") == false
    {
        var strDate = dategiven.replacingOccurrences(of: " ", with: "T")
        if strDate.components(separatedBy: ".").count < 2{
            strDate = "\(strDate).000Z"
        }
        
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        /*if dategiven.contains("'") == false{
         dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSZ"
         }*/
        let inputTimeZone = NSTimeZone(abbreviation: "UTC")
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.timeZone = inputTimeZone as TimeZone?
        inputDateFormatter.dateFormat = dateFormat
        let date = inputDateFormatter.date(from: strDate)
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = dateFormat
        
        let outputString = outputDateFormatter.string(from: date!)
        
        return outputDateFormatter.date(from: outputString)! as NSDate
    }
    else
    {
        return Date() as NSDate
    }
}

func convertDateAccordingDeviceTimeString(dategiven:String) -> String
{
    let inputDateFormatter = DateFormatter()
    let outputDateFormatter = DateFormatter()
    
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    let inputTimeZone = NSTimeZone(abbreviation: "UTC")
    
    inputDateFormatter.timeZone = inputTimeZone as TimeZone?
    inputDateFormatter.dateFormat = dateFormat
    let date = inputDateFormatter.date(from: dategiven)
    let outputTimeZone = NSTimeZone.local
    
    outputDateFormatter.timeZone = outputTimeZone
    outputDateFormatter.dateFormat = dateFormat
    let outputString = outputDateFormatter.string(from: date!)
    return outputString
}

//MARK:- Animation
func addActivityIndicatior(activityview:UIActivityIndicatorView,button:UIButton)
{
    activityview.isHidden = false
    activityview.startAnimating()
    button.isEnabled = false
    button.backgroundColor = RGBA(181, 131, 0, 0.4)
}
func hideActivityIndicatior(activityview:UIActivityIndicatorView,button:UIButton)
{
    activityview.isHidden = true
    activityview.stopAnimating()
    button.isEnabled = true
    button.backgroundColor = RGBA(181, 131, 0, 1.0)
}


//MARK:- Country code
func setDefaultCountryCode(strCountryName: String) -> String
{
    //    let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
    return getCountryPhonceCode(strCountryName)
}

//MARK:- Image/Video Processing
public func Set_Local_Image(imageName :String) -> UIImage
{
    return UIImage(named:imageName)!
}

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}

func fixOrientationOfImage(image: UIImage) -> UIImage?
{
    if image.imageOrientation == .up
    {return image}
    var transform = CGAffineTransform.identity
    switch image.imageOrientation
    {
    case .down, .downMirrored:
        transform = transform.translatedBy(x: image.size.width, y: image.size.height)
        transform = transform.rotated(by: CGFloat(Double.pi))
    case .left, .leftMirrored:
        transform = transform.translatedBy(x: image.size.width, y: 0)
        transform = transform.rotated(by:  CGFloat(Double.pi / 2))
    case .right, .rightMirrored:
        transform = transform.translatedBy(x: 0, y: image.size.height)
        transform = transform.rotated(by:  -CGFloat(Double.pi / 2))
    default:
        break
    }
    switch image.imageOrientation
    {
    case .upMirrored, .downMirrored:
        transform = transform.translatedBy(x: image.size.width, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    case .leftMirrored, .rightMirrored:
        transform = transform.translatedBy(x: image.size.height, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    default:
        break
    }
    guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
        return nil
    }
    context.concatenate(transform)
    switch image.imageOrientation
    {
    case .left, .leftMirrored, .right, .rightMirrored:
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
    default:
        context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
    }
    guard let CGImage = context.makeImage() else {
        return nil
    }
    return UIImage(cgImage: CGImage)
}

func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void)
{
    let urlAsset = AVURLAsset(url: inputURL, options: nil)
    let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720)
    //AVAssetExportPreset640x480)//AVAssetExportPresetMediumQuality
    exportSession!.outputURL = outputURL
    exportSession!.outputFileType = AVFileType.mp4
    exportSession!.shouldOptimizeForNetworkUse = true
    exportSession!.exportAsynchronously { () -> Void in
        handler(exportSession!)
    }
}

func getCountryPhonceCode (_ country : String) -> String
{
    let countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]
    let cname = country.uppercased()
    if countryDictionary[cname] != nil
    {
        return countryDictionary[cname]!
    }
    else
    {
        return cname
    }
}
//MARK:- Check string is available or not
public func isLike(source: String , compare: String) ->Bool
{
    var exists = true
    ((source).lowercased().range(of: compare) != nil) ? (exists = true) :  (exists = false)
    return exists
}

//Mark : string to dictionary
public func convertStringToDictionary(str:String) -> [String: Any]? {
    //let strDecodeMess : String = str.base64Decoded!
    //if let data = strDecodeMess.data(using: .utf8) {
    if let data = str.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
//Mark : dictionary to string
public func convertDictionaryToJSONString(dic:NSDictionary) -> String? {
    do{
        let jsonData: Data? = try JSONSerialization.data(withJSONObject: dic, options: [])
        var myString: String? = nil
        if let aData = jsonData {
            myString = String(data: aData, encoding: .utf8)
        }
        return myString
    }catch{
        print(error)
    }
    return ""
}

public func convertArrayToJSONString(dic:Any) -> String? {
    do{
        let jsonData: Data? = try JSONSerialization.data(withJSONObject: dic, options: [])
        var myString: String? = nil
        if let aData = jsonData {
            myString = String(data: aData, encoding: .utf8)
        }
        return myString
    }catch{
        print(error)
    }
    return ""
}

//MARK:- Calculate heght of label
public func calculatedHeight(string :String,withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.height
}

public func calculatedWidth(string :String,withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.width
}

//MARK:- Mile to Km

public func mileToKilometer(myDistance : Int) -> Float
{
    return Float(myDistance) * 1.60934
}

//MARK:- Kilometer to Mile
public func KilometerToMile(myDistance : Double) -> Double {
    return (myDistance) * 0.621371192
}

public func DegreesToRadians(degrees: Float) -> Float {
    return Float(Double(degrees) * .pi / 180)
}

//MARK:- NULL to NIL
public func NULL_TO_NIL(value : AnyObject?) -> AnyObject? {
    
    if value is NSNull {
        return "" as AnyObject?
    } else {
        return value
    }
}
//MARK:- Log trace
public func DLog<T>(message:T,  file: String = #file, function: String = #function, lineNumber: Int = #line ) {
    #if DEBUG
    if message is String {
        print(message)
    }
    #endif
}

//MARK:- File Manager

func getDocumentsDirectoryURL() -> URL? {
    let fileManager = FileManager.default
    do {
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        return documentDirectory
    }
    catch{
        print(error)
    }
    return nil
}

func saveFileDataLocally(data:Data, with FileName:String)->Bool{
    let filepath = getDocumentsDirectoryURL()?.appendingPathComponent(FileName)
    do{
        try data.write(to: filepath!, options: .atomic)
        return true
    }catch{
        print(error.localizedDescription)
        return false
    }
}

func getLocallySavedFileData(With FileName:String) -> Data?{
    let filepath = (getDocumentsDirectoryURL()?.appendingPathComponent(FileName))!
    if isFileLocallySaved(fileUrl: filepath){
        return try? Data.init(contentsOf: filepath)
    }else{
        return nil
    }
}

func removeFileFromLocal(_ filename: String) {
    let fileManager = FileManager.default
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(filename).absoluteString
    
    do{
        try fileManager.removeItem(atPath: filePath)
    }
    catch{
        //print("Could not delete file -:\(error.localizedDescription) ")
    }
}

func isFileLocallySaved(fileUrl:URL) -> Bool{
    let fileName = fileUrl.lastPathComponent
    let filePath = getDocumentsDirectoryURL()?.appendingPathComponent(fileName)
    let fileManager = FileManager.default
    // Check if file exists
    if fileManager.fileExists(atPath: filePath!.path) {
        return true
    } else {
        return false
    }
}

func getLocallySavedFileURL(with fileUrl:URL) -> URL? {
    if(isFileLocallySaved(fileUrl: fileUrl)){
        let fileName = fileUrl.lastPathComponent
        let filePath = getDocumentsDirectoryURL()?.appendingPathComponent(fileName)
        return filePath
    }
    return nil
}

func timeFormatted(_ totalSeconds: Int) -> String? {
    let seconds: Int = totalSeconds % 60
    let minutes: Int = (totalSeconds / 60) % 60
    let hours: Int = totalSeconds / 3600
    var timeString = ""
    var formatString = ""
    if hours > 0 {
        formatString = hours == 1 ? "%d hour" : "%d hours"
        timeString = timeString + (String(format: formatString, hours))
    }
    if minutes > 0 || hours > 0 {
        formatString = minutes == 1 ? " %d minute" : " %d minutes"
        timeString = timeString + (String(format: formatString, minutes))
    }
    if seconds > 0 || hours > 0 || minutes > 0 {
        formatString = seconds == 1 ? " %d second" : " %d seconds"
        timeString = timeString + (String(format: formatString, seconds))
    }
    
    timeString = "\(hours):\(minutes):\(seconds)"
    timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    
    return timeString
}

func postNotification(with Name:String, andUserInfo userInfo:[AnyHashable : Any]? = nil){
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name), object: nil, userInfo: userInfo)
    //NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Name),object: nil))
}




func checkSearchBarActive(searchbar:UISearchBar) -> Bool {
    if searchbar.isFirstResponder && searchbar.text != "" {
        return true
    }
    else if(searchbar.text != "")
    {
        return true
    }
    else {
        return false
    }
}



//Payal mem
func fileSize(url: URL?) -> String {
    
    guard let filePath = url?.path else {
        return "0"
    }
    do {
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let size = attribute[FileAttributeKey.size] as? NSNumber
        {
            return "\((size).uint64Value)"
        }
    } catch {
        //print("Error: \(error)")
    }
    return "0"
}

func fileSizeInMB(_ bts:String) -> String
{
    if (bts == "0") { return "\(0) MB" }
    //let value = String(format: "%.2f MB", Int(bts).aDoubleOrEmpty() / 1000000.0)
    let bytes : Int64 = Int64(bts)!
    let value = ByteCountFormatter.string(fromByteCount: bytes, countStyle: ByteCountFormatter.CountStyle.binary)
    //print("value: \(value)")
    return value
}

func fileSizedetail(url: URL?) -> String {
    guard let filePath = url?.path else {
        return "\(0) MB"
    }
    
    do {
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let size = attribute[FileAttributeKey.size] as? NSNumber {
            //return String(format: "%.2f MB", size.doubleValue / 1000000.0)
            
            let value = ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: ByteCountFormatter.CountStyle.binary)
            return value
        }
    } catch {
        //print("Error: \(error)")
    }
    return "\(0) MB"
}


func timeAgoSinceStrDate1(strDate:String, numericDates:Bool,isFutur:Bool = false) -> String{
    
    
    let date = convertDateAccordingDeviceTime(dategiven: strDate)
    
    if(isFutur == true)
    {
        return timeAgoSinceDateFuture(date: date as Date, numericDates: numericDates)
    }
    else
    {
        return timeAgoSinceDate(date: date as Date, numericDates: numericDates)
    }
    //PV
    
    //return DateFormater.generateTimeForGivenDate(strDate: date)
}

func timeAgoSinceDateFuture(date:Date, numericDates:Bool) -> String
{
    let calendar = NSCalendar.current
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let now = NSDate()
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
    if (abs(components.year!) >= 2)
    {
        return "\(abs(components.year!))" + " years from now"
    }
    else if (abs(components.year!) >= 1)
    {
        if (numericDates){
            return "\(abs(components.year!)) year from now"
        } else {
            return "Next year"
        }
    }
    else if (abs(components.month!) >= 2) {
        return "\(abs(components.month!))" + " months from now"
    }
    else if (abs(components.month!) >= 1){
        if (numericDates){
            return "\(abs(components.month!)) month from now"
        } else {
            return "Next month"
        }
    }
    else if (abs(components.weekOfYear!) >= 2) {
        return "\(abs(components.weekOfYear!))" + " weeks from now"
    }
    else if (abs(components.weekOfYear!) >= 1){
        if (numericDates){
            return "\(abs(components.weekOfYear!)) week from now"
        } else {
            return "Next week"
        }
    }
    else if (abs(components.day!) >= 2) {
        return "\(abs(components.day!))" + " days from now"
    }
    else if (abs(components.day!) >= 1){
        if (numericDates){
            return "\(abs(components.day!)) day from now"
        } else {
            return "Tomorrow"
        }
    }
    else if (abs(components.hour!) >= 2) {
        return "\(abs(components.hour!))" + " hours from now"
    }
    else if (abs(components.hour!) >= 1){
        if (numericDates){
            return "\(abs(components.hour!)) hour from now"
        } else {
            return "An hour from now"
        }
    }
    else if (abs(components.minute!) >= 2)
    {
        return "\(abs(components.minute!))" + " min from now"
    } else if (abs(components.minute!) > 1){
        if (numericDates){
            return "\(abs(components.minute!)) min from now"
        } else {
            return "A min from now"
        }
    }
    else if (abs(components.second!) >= 3) {
        return "\(abs(components.second!))" + " sec from now"
    } else {
        return "Just now"
    }
}

//MARK:- Mutable String Method
func makeAttributedString(firstString: String, secondString: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let str = "\(firstString) \(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:0,length:firstString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range1)
    return myMutableString
}

//MARK:- dictionary Of Filtered By
func dictionaryOfFilteredBy(dict: NSDictionary) -> NSDictionary {
    
    let replaced: NSMutableDictionary = NSMutableDictionary(dictionary : dict)
    let blank: String = ""
    
    for (key, _) in dict
    {
        let object = dict[key] as AnyObject
        
        if (object.isKind(of: NSNull.self))
        {
            replaced[key] = blank as AnyObject?
        }
        else if (object is [AnyHashable: AnyObject])
        {
            replaced[key] = dictionaryOfFilteredBy(dict: object as! NSDictionary)
        }
        else if (object is [AnyObject])
        {
            replaced[key] = arrayOfFilteredBy(arr: object as! NSArray)
        }
        else
        {
            replaced[key] = "\(object)" as AnyObject?
        }
    }
    return replaced
}

func arrayOfFilteredBy(arr: NSArray) -> NSArray {
    
    let replaced: NSMutableArray = NSMutableArray(array: arr)
    let blank: String = ""
    
    for i in 0..<arr.count
    {
        let object = arr[i] as AnyObject
        
        if (object.isKind(of: NSNull.self))
        {
            replaced[i] = blank as AnyObject
        }
        else if (object is [AnyHashable: AnyObject])
        {
            replaced[i] = dictionaryOfFilteredBy(dict: arr[i] as! NSDictionary)
        }
        else if (object is [AnyObject])
        {
            replaced[i] = arrayOfFilteredBy(arr: arr[i] as! NSArray)
        }
        else
        {
            replaced[i] = "\(object)" as AnyObject
        }
        
    }
    return replaced
}


func errorMessage(myDict: NSDictionary) -> String  {
    if let errordict = myDict["errors"] as? NSDictionary,
        errordict.count > 0 {
        var strerr = ""
        for (offset: index,element: (key: _,value: value)) in errordict.enumerated() {
            
            if let mymsg = value as? String {
                if index == errordict.count - 1 {
                    strerr = strerr + "\(mymsg)"
                } else {
                    strerr = strerr + "\(mymsg)\n"
                }
            }
        }
        if strerr != "" {
            return strerr
        } else {
            if let errmsg = myDict["message"] as? String {
                return errmsg
            }
        }
    } else {
        if let errmsg = myDict["message"] as? String {
            return errmsg
        }
    }
    return ""
}

func errorMessagenew(myArr: NSArray) -> String  {
    for msg in myArr {
        return msg as? String ?? ""
    }
    return ""
}


//MARK: with animation
func DisplayWithAnimation(lbl: UILabel) {
    lbl.alpha = 0
    UIView.animate(
        withDuration: 0.5,
        delay: 0.03,
        options: UIView.AnimationOptions.allowUserInteraction,
        animations: {
            lbl.alpha = 1
    })
}


//MARK:- String To QRCode
func convertStringToQRCode(text: String) -> UIImage {
    let size : CGSize = CGSize(width: 500, height: 500)
    let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
    let filter = CIFilter(name: "CIQRCodeGenerator")!
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("L", forKey: "inputCorrectionLevel")
    let qrcodeCIImage = filter.outputImage!
    let colorParameters = [
        "inputColor0": CIColor(color: setColor(.app_light_green)), // Foreground
        "inputColor1": CIColor(color: .white) // Background
        ]
    let colored = qrcodeCIImage.applyingFilter("CIFalseColor", parameters: colorParameters)
    let cgImage = CIContext(options:nil).createCGImage(colored, from: colored.extent)
    UIGraphicsBeginImageContext(CGSize(width: size.width * UIScreen.main.scale, height:size.height * UIScreen.main.scale))
    
    let context = UIGraphicsGetCurrentContext()
    context!.interpolationQuality = .none
    context?.draw(cgImage!, in: CGRect(x: 0.0,y: 0.0,width: context!.boundingBoxOfClipPath.width,height: context!.boundingBoxOfClipPath.height))
    let preImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    let qrCodeImage = UIImage(cgImage: (preImage?.cgImage!)!, scale: 1.0/UIScreen.main.scale, orientation: .downMirrored)
    return qrCodeImage
}

//
func UTCToLocal(UTCDateString: String) -> String  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let UTCDate = dateFormatter.date(from: UTCDateString)
    dateFormatter.dateFormat = "dd MMM yyyy" // Output Format
    dateFormatter.timeZone = TimeZone.current
    let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
    return UTCToCurrentFormat
    
}

func localToUTC(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: dt!)
}

func showAlertOnKeyWindow(title: String, strMessage : String, time: Double, completion : (()->Void)? )  {
     
     var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
     topWindow?.rootViewController = UIViewController()
     topWindow?.windowLevel = UIWindow.Level.alert + 1
     
     let alert = UIAlertController(title: title, message: strMessage, preferredStyle: .alert)
     topWindow?.makeKeyAndVisible()
     topWindow?.rootViewController?.present(alert, animated: true, completion:{
         
         DispatchQueue.main.asyncAfter(deadline: .now() + time) { [] in
             
             topWindow?.isHidden = true
             topWindow = nil
             completion?()
             
         }
     })
     
 }


func ShowAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
        
    }
    alert.addAction(action)
    if #available(iOS 13.0, *) {
        alert.overrideUserInterfaceStyle = .dark
    } else {
        // Fallback on earlier versions
    }
    alert.present(alert, animated: true, completion: nil)
}


extension UITableView {

    func scrollToBottom(){
        if(self.numberOfSections > 0)
        {
            DispatchQueue.main.async {
                let indexPath = IndexPath(
                    row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                    section: self.numberOfSections - 1)
                if self.hasRowAtIndexPath(indexPath: indexPath) {
                    self.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


//MARK:-DownloadVideo from URL
func DownloadVideoFromURL(urlString: String) {
    DispatchQueue.global(qos: .background).async {
        if let url = URL(string: urlString),
           let urlData = NSData(contentsOf: url) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath="\(documentsPath)/\(CurrentTimeStamp).mp4"
            DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                }) { completed, error in
                    if completed {
                        print("Video is saved!")
                        DispatchQueue.main.async {
                            showMessage("Your Video is saved!")
                        }
                    }
                }
            }
        }
    }
}

/*
//MARk:- Genrate Deeplink
func GenerateDeeplinkForChallange(ChallangeId : Int, Success:@escaping (_ url: String?, _ error: NSError?) -> Void) {
    guard let link = URL(string: "http://192.241.137.149?challenge=\(ChallangeId)") else { return }
    let dynamicLinksDomainURIPrefix = "https://hinotes.page.link"
    let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
    //
    linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = true
    //
    linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.hinotes")
    //linkBuilder?.iOSParameters?.appStoreID = "123456789"
    //
    linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.hinotes")
    //
    guard let longDynamicLink = linkBuilder?.url else { return }
    print("The long URL is: \(longDynamicLink)")
    
    linkBuilder?.options = DynamicLinkComponentsOptions()
    linkBuilder?.options?.pathLength = .short
    linkBuilder?.shorten(completion: { (url, warnings, error) in
        if error == nil {
            if let shortUrl = url {
                Success("\(shortUrl)",nil)
            }
        } else {
            Success(nil, error as NSError?)
        }
    })
}

func GenerateDeeplinkForHashTag(TagId : Int, Success:@escaping (_ url: String?, _ error: NSError?) -> Void) {
    guard let link = URL(string: "http://192.241.137.149?tag=\(TagId)") else { return }
    let dynamicLinksDomainURIPrefix = "https://hinotes.page.link"
    let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
    //
    linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = true
    //
    linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.hinotes")
    //linkBuilder?.iOSParameters?.appStoreID = "123456789"
    //
    linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.hinotes")
    //
    guard let longDynamicLink = linkBuilder?.url else { return }
    print("The long URL is: \(longDynamicLink)")
    
    linkBuilder?.options = DynamicLinkComponentsOptions()
    linkBuilder?.options?.pathLength = .short
    linkBuilder?.shorten(completion: { (url, warnings, error) in
        if error == nil {
            if let shortUrl = url {
                Success("\(shortUrl)",nil)
            }
        } else {
            Success(nil, error as NSError?)
        }
    })
}
*/


func cropVideo(atURL url:URL) -> String {
    let asset = AVURLAsset(url: url)
    let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
    var outputURL = URL(string:NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!)
    
    let fileManager = FileManager.default
    do {
        try fileManager.createDirectory(at: outputURL!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        
    }
    
    outputURL?.appendPathComponent("output.mp4")
    // Remove existing file
    do {
        try fileManager.removeItem(at: outputURL!)
    }
    catch {
        
    }
    
    exportSession.outputURL = outputURL
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.outputFileType = AVFileType.mov
    let start = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600) // you will modify time range here
    let duration = CMTimeMakeWithSeconds(30.0, preferredTimescale: 600)
    let range = CMTimeRangeMake(start: start, duration: duration)
    exportSession.timeRange = range
    exportSession.exportAsynchronously {
        switch(exportSession.status) {
        case .completed: break
        //
        case .failed: break
        //
        case .cancelled: break
        //
        default: break
        }
    }
    
    let SavedStrURL = saveVideo(urlString: "\(exportSession.outputURL!)", fileName: CurrentTimeStamp)
    
    return SavedStrURL
}

func saveVideo(urlString:String, fileName:String) -> String {
    var SavedURL = ""
    DispatchQueue.main.async {
        let url = URL(string: urlString)
        let videoData = try? Data.init(contentsOf: url!)
        let videoNameFromUrl = "\(fileName).\(url?.pathExtension ?? "")"
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hinotes") {
            let contairURLWithName = containerURL.appendingPathComponent(videoNameFromUrl)
            do {
                try videoData?.write(to: contairURLWithName, options: .atomic)
                print(contairURLWithName.path)
                SavedURL = contairURLWithName.path
                print("video successfully saved!")
            } catch {
                print("video could not be saved")
            }
        }
    }
    return SavedURL
}

//MARK:- get Image From First & Last Name
func getImageFromFirstAndLastName(firstName: String, lastname: String) -> UIImage {
    let lblNameInitialize = UILabel()
    var image = UIImage()
    lblNameInitialize.frame.size = CGSize(width: 50.0, height: 50.0)
    lblNameInitialize.textColor = UIColor.black
    
    if firstName.count > 0 {
        if lastname.count > 0 {
            lblNameInitialize.text = String(firstName.first!) + String(lastname.first!)
        } else {
            lblNameInitialize.text = String(firstName.first!)
        }
    }
    
    lblNameInitialize.textAlignment = NSTextAlignment.center
    lblNameInitialize.backgroundColor = .clear
    lblNameInitialize.font = UIFont(name: "Nunito-ExtraBold", size: 16.0)
    lblNameInitialize.layer.cornerRadius = 25.0
    
    UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
    lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}


func clearTempFolder() {
    let fileManager = FileManager.default
    let tempFolderPath = NSTemporaryDirectory()
    do {
        let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
        for filePath in filePaths {
            try fileManager.removeItem(atPath: tempFolderPath + filePath)
        }
    } catch {
        print("Could not clear temp folder: \(error)")
    }
}

func clearDocumentDirectory(){
    let fileManager = FileManager.default
    let error: NSErrorPointer = nil
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    do {
        let directoryContents: NSArray = try fileManager.contentsOfDirectory(atPath: dirPath) as NSArray
        
        if directoryContents.count > 0 {
            for path in directoryContents {
                try fileManager.removeItem(atPath: dirPath + "\(path)")
            }
        } else {
            print("Could not retrieve directory: \(String(describing: error))")
        }
    } catch {
        print("Could not clear temp folder: \(error)")
    }
}

func addMediumHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

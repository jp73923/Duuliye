//
//  HttpRequestManager.swift
//  Copyright © 2016 PayalUmraliya. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import AVKit

//Encoding Type
let URL_ENCODING = URLEncoding.default
let JSON_ENCODING = JSONEncoding.default

//Web Service Result

public enum RESPONSE_STATUS : NSInteger
{
    case INVALID
    case VALID
    case MESSAGE
}
protocol UploadProgressDelegate
{
    func didReceivedProgress(progress:Float)
}
    
protocol DownloadProgressDelegate
{
    func didReceivedDownloadProgress(progress:Float,filename:String)
    func didFailedDownload(filename:String)
}

class HttpRequestManager
{
    static let sharedInstance = HttpRequestManager()
    var additionalHeader = ["Accept": "application/json"]
    var responseObjectDic = Dictionary<String, AnyObject>()
    var URLString : String!
    var Message : String!
    var resObjects:AnyObject!
    var alamoFireManager = Alamofire.SessionManager.default
    var delegate : UploadProgressDelegate?
    var downloadDelegate : DownloadProgressDelegate?
    // METHODS
    init()
    {
        alamoFireManager.session.configuration.timeoutIntervalForRequest = 120 //seconds
        alamoFireManager.session.configuration.httpAdditionalHeaders = additionalHeader
    }
    //MARK:- Cancel Request
    func cancelAllAlamofireRequests(responseData:@escaping ( _ status: Bool?) -> Void)
    {
        alamoFireManager.session.getTasksWithCompletionHandler
            {
                dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
                responseData(true)
        }
    }
    
    /*func getTocken() -> String
    {
        return UserDefaultManager.getStringFromUserDefaults(key: kToken)
    }*/
    
    //MARK:- GET
    //CURRENTLY NOT IN USE BECAUSE THIS IS GET
    func getRequest(endpointurl:String,
                    service:String,
                    parameters:NSDictionary,
                    keyname:NSString,
                    message:String,
                    showLoader:Bool,
                    responseData:@escaping  (_ error: NSError?,_ responseArray: NSArray?, _ responseDict: NSDictionary?) -> Void)
    {
        if isConnectedToNetwork()
        {
            if(showLoader)
            {
                showLoaderHUD()
            }
            
            if !(service == APIRegister || service == APILogin) {
                additionalHeader = [//"Accept": "application/json",
                                    "Authorization":GetAPIToken()]
            }
            else {
                additionalHeader = ["Accept": "application/json",
                                    "Content-Type":"application/x-www-form-urlencoded"]
            }
            
            DLog(message: "\nURL : \(endpointurl) \nParam :\( parameters) \nHeader: \(additionalHeader)")
            ShowNetworkIndicator(xx: true)
            
            alamoFireManager.request(endpointurl, method: .get, parameters: parameters as? [String : AnyObject], headers: additionalHeader).responseString(completionHandler: { (responseString) in
                
                print(responseString.value ?? "error")
                ShowNetworkIndicator(xx: false)
                if(responseString.value == nil)
                {
                    hideLoaderHUD()
                    responseData(responseString.error as NSError?,nil,nil)
                }
                else
                {
                    var strResponse = "\(responseString.value!)"
                    strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    
                    let arr = strResponse.components(separatedBy: "\n")
                    
                    var dict : [String:Any]?
                    for jsonString in arr{
                        if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                        {
                            do {
                                dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                                print("JSON is valid.")
                            } catch {
                                //print("Error deserializing JSON: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    let str = dict?[kMessage] as? String ?? ServerResponseError
                    
                    self.Message = str
                    let responseStatus = dict?[kSuccess] as? Int ?? 0
                    //print(responseStatus)
                    switch (responseStatus)
                    {
                    case RESPONSE_STATUS.VALID.rawValue:
                        self.resObjects = dict as AnyObject
                        
                        if(keyname != "")
                        {
                            self.parseData(
                                dicResponse: self.resObjects as! NSDictionary,
                                service: service,
                                parseKey:keyname,
                                completionData: {(arrData) -> () in
                                    hideLoaderHUD()
                                    if(arrData.count > 0)
                                    {
                                        responseData(nil,arrData,self.resObjects as? NSDictionary)
                                    }
                                    else
                                    {
                                        responseData(nil,arrData,self.resObjects as? NSDictionary)
                                        //showStatusbarMessage(self.Message!, 3)
                                    }
                            })
                        }
                        else
                        {
                            hideLoaderHUD()
                            responseData(nil,nil,self.resObjects as? NSDictionary)
                        }
                        
                        break
                    case RESPONSE_STATUS.INVALID.rawValue:
                        hideLoaderHUD()
                        self.resObjects = nil
                        showMessage(self.Message)
                        break
                    default :
                        break
                    }
                }
                
            })
        }
    }
    
    //MARK:- POST for Video
    func requestWithPostMultipartParam(endpointurl:String, isImage:Bool,parameters:NSDictionary,responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?, _ responseDict: AnyObject?) -> Void)
    {
        if isConnectedToNetwork()
        {
           //additionalHeader = ["Accept": "application/json", "Authorization": "Bearer " +  getTocken()]
            showLoaderHUD()
            
            DLog(message: "URL : \(endpointurl) \nParam :")
            alamoFireManager.upload(multipartFormData:{ multipartFormData in
                for (key, value) in parameters
                {
                    if value is Data {
                        if key as! String == "class_video" {
                            multipartFormData.append(value as! Data, withName: key as! String, fileName: "video.mp4", mimeType: "video/mp4")
                        }
                        else {
                            multipartFormData.append(value as! Data, withName: key as! String, fileName: "image.jpg", mimeType: "image/jpeg")
                        }
                    }
                    else if value is URL{
                        
                        let url = value as! URL
                        
                        let fileExt = (url.lastPathComponent.components(separatedBy: ".").last!).lowercased()
                        var mime = ""
                        
                        switch fileExt{
                        case "xls":
                            mime = "application/vnd.ms-excel"
                            break
                        case "xlsx":
                            mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                            break
                        case "doc":
                            mime = "application/msword"
                            break
                        case "docx":
                            mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                            break
                        case "pdf":
                            mime = "application/pdf"
                            break
                        case "rtf":
                            mime = "application/rtf"
                            break
                        case "txt":
                            mime = "text/plain"
                            break
                        default:
                            break
                        }
                        
                        var fileData:Data? = nil
                        do{
                            fileData = try Data.init(contentsOf: url)
                            multipartFormData.append(fileData!, withName: key as! String, fileName: "jm.\(fileExt)", mimeType: mime)
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                    else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                    }
                }
            }, to: endpointurl, method:.post, headers:additionalHeader, encodingCompletion:
            { encodingResult in
                switch encodingResult
                {
                    case .success(let upload, _, _):
                        upload.responseString(completionHandler:{(responseString) in
                            print(responseString.value ?? "error")
                            ShowNetworkIndicator(xx: false)
                            if(responseString.value == nil)
                            {
                                responseData(nil, responseString.error as NSError?, nil, responseString.error as AnyObject?)
                            }
                            else
                            {
                                var strResponse = "\(responseString.value!)"
                                strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                                
                                let arr = strResponse.components(separatedBy: "\n")
                                
                                var dict : [String:Any]?
                                for jsonString in arr{
                                    if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                                    {
                                        do {
                                            dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                                            print("JSON is valid.")
                                        } catch {
                                            //print("Error deserializing JSON: \(error.localizedDescription)")
                                        }
                                    }
                                }
                                
                                let str = dict?[kMessage] as? String ?? ServerResponseError
                                
                                self.Message = str
                                let responseStatus = dict?[kStatus] as? Int ?? 0
                                //print(responseStatus)
                                switch (responseStatus)
                                {
                                case RESPONSE_STATUS.VALID.rawValue:
                                    self.resObjects = dict as AnyObject
                                    break
                                case RESPONSE_STATUS.INVALID.rawValue:
                                    self.resObjects = nil
                                    //showMessage(errorMessage(myDict: dict! as NSDictionary))
                                    break
                                    
                                default :
                                    break
                                }
                                responseData(self.resObjects, nil, self.Message, responseString.value as AnyObject?)
                            }
                    })
                    break
                    case .failure(let encodingError):
                            print("ENCODING ERROR: ",encodingError)
                            responseData(nil, nil, nil, nil)
                }
            })
        }
    }
    
    //requestWithPostJsonParam
    func requestWithPostJsonParam( endpointurl:String,
                                   service:String,
                                   parameters:NSDictionary,
                                   keyname:NSString,
                                   message:String,
                                   showLoader:Bool,
                                   responseData:@escaping  (_ error: NSError?,_ responseArray: NSArray?, _ responseDict: NSDictionary?) -> Void)
    {
        if isConnectedToNetwork()
        {
            if(showLoader)
            {
                showLoaderHUD()
            }
            if !(service == APIRegister || service == APILogin) {
                additionalHeader = ["Accept": "application/json",
                                    //"Content-Type":"application/x-www-form-urlencoded",
                                    /*"Authorization":GetAPIToken()*/]
            }
            else {
                additionalHeader = ["Accept": "application/json",
                                    "Content-Type":"application/x-www-form-urlencoded"]
            }
            
            DLog(message: "\nURL : \(endpointurl) \nParam :\( parameters) \nHeader :\(additionalHeader)")
            ShowNetworkIndicator(xx: true)
            
            //additionalHeader = ["Accept": "application/json"]
            alamoFireManager.request(endpointurl, method: .post, parameters: parameters as? Parameters, headers: additionalHeader)
                .responseString(completionHandler: { (responseString) in
                    print(responseString.value ?? "error")
                    hideLoaderHUD()
                    ShowNetworkIndicator(xx: false)
                    if(responseString.value == nil)
                    {
                        hideLoaderHUD()
                        responseData(responseString.error as NSError?,nil,nil)
                    }
                    else
                    {
                        var strResponse = "\(responseString.value!)"
                        strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        
                        let arr = strResponse.components(separatedBy: "\n")
                        var dict : [String:Any]?
                        for jsonString in arr{
                            if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                            {
                                do {
                                    dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                                    print("JSON is valid.")
                                } catch {
                                    //print("Error deserializing JSON: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        let str = dict?[kMessage] as? String ?? ServerResponseError
                        self.Message = str
                        let responseStatus = dict?[kSuccess] as? String ?? ""
                        //Added in android so I need this changes in iOS
                        let statusCode = dict?[kSuccessCode] as? Int ?? 0

                        //print(responseStatus)
                        if responseStatus != "" {
                            switch (responseStatus)
                            {
                            case "success":
                                self.resObjects = dict as AnyObject
                                
                                if(keyname != "")
                                {
                                    hideLoaderHUD()
                                    responseData(nil,nil,self.resObjects as? NSDictionary)
                                }
                                else
                                {
                                    hideLoaderHUD()
                                    responseData(nil,nil,self.resObjects as? NSDictionary)
                                }
                                
                                break
                            case "fail":
                                hideLoaderHUD()
                                self.resObjects = nil
                                //showMessage(self.Message)
                                if dict != nil {
                                    if endpointurl.contains(APILogin) {
                                        showMessage("Mobile number is not registered with us!")
                                    } else {
                                        showMessage(dict?["msg"] as? String ?? "")
                                        responseData(nil,nil,nil)
                                    }
                                }else {
                                    showMessage(ServerResponseError)
                                }
                                
                                let err = NSError.init(domain: "Domain", code: 7874, userInfo: ["description" : self.Message!])
                             //   responseData(err,nil,nil)
                                break
                            default :
                                break
                            }
                        } else {
                            switch (statusCode)
                            {
                            case 200:
                                self.resObjects = dict as AnyObject
                                
                                if(keyname != "")
                                {
                                    hideLoaderHUD()
                                    responseData(nil,nil,self.resObjects as? NSDictionary)
                                }
                                else
                                {
                                    hideLoaderHUD()
                                    responseData(nil,nil,self.resObjects as? NSDictionary)
                                }
                                
                                break
                            case 400,404,321:
                                hideLoaderHUD()
                                self.resObjects = nil
                                //showMessage(self.Message)
                                if dict != nil {
                                    showMessage(errorMessage(myDict: dict! as NSDictionary))
                                }else {
                                    showMessage(ServerResponseError)
                                }
                                
                                let err = NSError.init(domain: "Domain", code: 7874, userInfo: ["description" : self.Message!])
                                responseData(err,nil,nil)
                                break
                            case 401:
                                break
                               // showMessage("Unauthorized!")
                              //  APP_DELEGATE.GoToLogin()
                            default :
                                self.resObjects = dict as AnyObject
                                
                                if(keyname != "")
                                {
                                    hideLoaderHUD()
                                    responseData(nil,nil,self.resObjects as? NSDictionary)
                                }
                                else
                                {
                                    hideLoaderHUD()
                                    responseData(nil,nil,self.resObjects as? NSDictionary)
                                }
                                
                                break
                            }
                        }

                    }
                })
        }
    }
    
    
    //MARK:- Delete method
    
    func deleteMethod() {

        alamoFireManager.request("https://my-json-server.typicode.com/typicode/demo/posts/1", method: .delete, parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }

                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }
    }
    
    
    //Delete Request
    func DeleteRequest( endpointurl:String,
                        service:String,
                        parameters:NSDictionary,
                        keyname:NSString,
                        message:String,
                        showLoader:Bool,
                        responseData:@escaping  (_ error: NSError?,_ responseArray: NSArray?, _ responseDict: NSDictionary?) -> Void)
    {
        if isConnectedToNetwork()
        {
            if(showLoader)
            {
                showLoaderHUD()
            }
            if !(service == APIRegister || service == APILogin) {
                additionalHeader = ["Accept": "application/json",
                                    //"Content-Type":"application/x-www-form-urlencoded",
                                    "Authorization":GetAPIToken()]
            }
            else {
                additionalHeader = ["Accept": "application/json",
                                    "Content-Type":"application/x-www-form-urlencoded"]
            }
            
            DLog(message: "\nURL : \(endpointurl) \nParam :\( parameters) \nHeader :\(additionalHeader)")
            ShowNetworkIndicator(xx: true)
            
            //additionalHeader = ["Accept": "application/json"]
            alamoFireManager.request(endpointurl, method: .delete, parameters: parameters as? Parameters, headers: additionalHeader)
                .responseString(completionHandler: { (responseString) in
                    print(responseString.value ?? "error")
                    ShowNetworkIndicator(xx: false)
                    if(responseString.value == nil)
                    {
                        hideLoaderHUD()
                        responseData(responseString.error as NSError?,nil,nil)
                    }
                    else
                    {
                        var strResponse = "\(responseString.value!)"
                        strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        
                        let arr = strResponse.components(separatedBy: "\n")
                        
                        var dict : [String:Any]?
                        for jsonString in arr{
                            if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                            {
                                do {
                                    dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                                    print("JSON is valid.")
                                } catch {
                                    //print("Error deserializing JSON: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        let str = dict?[kMessage] as? String ?? ServerResponseError
                        self.Message = str
                        let responseStatus = dict?[kSuccess] as? Int ?? 0
                        //print(responseStatus)
                        switch (responseStatus)
                        {
                        case RESPONSE_STATUS.VALID.rawValue:
                            self.resObjects = dict as AnyObject
                            
                            if(keyname != "")
                            {
                                self.parseData(
                                    dicResponse: self.resObjects as! NSDictionary,
                                    service: service,
                                    parseKey:keyname,
                                    completionData: {(arrData) -> () in
                                        hideLoaderHUD()
                                        if(arrData.count > 0)
                                        {
                                            responseData(nil,arrData,self.resObjects as? NSDictionary)
                                        }
                                        else
                                        {
                                            //showStatusbarMessage(self.Message!, 3)
                                            responseData(nil,arrData,self.resObjects as? NSDictionary)
                                            //showMessage(self.Message)
                                        }
                                })
                            }
                            else
                            {
                                hideLoaderHUD()
                                responseData(nil,nil,self.resObjects as? NSDictionary)
                            }
                            
                            break
                        case RESPONSE_STATUS.INVALID.rawValue:
                            hideLoaderHUD()
                            self.resObjects = nil
                            //showMessage(self.Message)
                            if dict != nil {
                                showMessage(errorMessage(myDict: dict! as NSDictionary))
                            }else {
                                showMessage(ServerResponseError)
                            }
                            
                            let err = NSError.init(domain: "Domain", code: 7874, userInfo: ["description" : self.Message!])
                            responseData(err,nil,nil)
                            break
                        default :
                            break
                        }
                    }
                })
        }
    }
    
    
    //MARK:- Video Uploading
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
                handler(nil)
                return
            }
            
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4 //AVFileTypeQuickTimeMovie (m4v)
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.exportAsynchronously { () -> Void in
                handler(exportSession)
            }
        }
    
    
    //MARK:- Data Parsing
    func parseData( dicResponse:NSDictionary,
                   service:String,
                   parseKey:NSString,
                   completionData:@escaping(_ arrData:NSMutableArray)->())
    {
       
        let arrResponseData = NSMutableArray()
        for (key, _) in dicResponse
        {
            if(key as! String == parseKey as String)
            {
                switch service{
                    
                /*case APIRegister, APILogin:
                    let jsonData = JSON(dicResponse[parseKey] as! NSDictionary)
                    let objData:ClassUserData = ClassUserData.init(fromJson: jsonData)
                    arrResponseData.add(objData)
                    completionData(arrResponseData)
                    break
                    
                case APIGetUpcomingClass:
                    let jsonData = (dicResponse[parseKey] as! NSDictionary)["record"] as! NSArray
                    for dic in jsonData {
                        let jsonData = JSON(dic)
                        let objData:ClassUpcomingClasses = ClassUpcomingClasses.init(fromJson: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetRandomClass:
                    let jsonData = dicResponse[parseKey] as! NSArray
                    for dic in jsonData {
                        let jsonData = JSON(dic)
                        let objData:ClassUpcomingClasses = ClassUpcomingClasses.init(fromJson: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetWorkoutcategory:
                    let jsonData = dicResponse[parseKey] as! NSArray
                    for dic in jsonData {
                        let jsonData = JSON(dic)
                        let objData:ClassWorkoutcategory = ClassWorkoutcategory.init(fromJson: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetworkout_types:
                    let jsonData = dicResponse[parseKey] as! NSArray
                    for dic in jsonData {
                        let jsonData = JSON(dic)
                        let objData:ClassWorkoutType = ClassWorkoutType.init(fromJson: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetbody_parts:
                    let jsonData = dicResponse[parseKey] as! NSArray
                    for dic in jsonData {
                        let jsonData = JSON(dic)
                        let objData:ClassBodyType = ClassBodyType.init(fromJson: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break*/
                    
                    
                /*case APIVerify:
                    let jsonData = JSON(dicResponse[parseKey] as! NSDictionary)
                    arrResponseData.add(jsonData)
                    completionData(arrResponseData)
                    break
                    
                case APIGetHashtagList:
                    let jsonData = dicResponse[parseKey] as! NSArray
                    for dic in jsonData {
                        let jsonData = JSON(dic)
                        let objData:ClassVideoHashtag = ClassVideoHashtag.init(fromJson: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break*/
                    
                
                    
                default:
                    completionData(arrResponseData)
                    break
                }
                return
            }
        }
    }

}

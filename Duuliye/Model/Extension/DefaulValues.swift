import UIKit
class UserDefaultManager {
    class func setObjectValueToUserDefaults(idValue: AnyObject, ForKey strKey: String) {
        let defaults = UserDefaults.standard
        defaults.set(idValue, forKey: strKey)
        defaults.synchronize()
        
    }
    
    class func getObjectValueFromUserDefaults_ForKey(strKey: String) -> AnyObject {
        let defaults = UserDefaults.standard
        var obj: AnyObject? = nil
        obj = defaults.object(forKey: strKey) as AnyObject?
        return obj!
    }
    
    class func setDoubleToUserDefaults(value: Double , key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getDoubleFromUserDefaults(key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    
    class func setFloatToUserDefaults(value: Float , key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getFloatFromUserDefaults(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    class func setBooleanToUserDefaults(value: Bool , key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getBooleanFromUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func setIntToUserDefaults(value: Int , key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getIntFromUserDefaults(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    class func setStringToUserDefaults(value: String , key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getStringFromUserDefaults(key: String) -> String {
        if(UserDefaults.standard.string(forKey: key) == nil) { return "" }
        else { return UserDefaults.standard.string(forKey: key)! }
    }
    
    class func setCustomObjToUserDefaults(CustomeObj: AnyObject , key: String) {
        let defaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: CustomeObj)
        defaults.set(encodedData, forKey: key)
        defaults.synchronize()
    }
    
    class func getCustomObjFromUserDefaults(key: String) -> AnyObject {
        let defaults = UserDefaults.standard
        let decoded  = defaults.object(forKey: key) as! NSData
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data)! as AnyObject
        return decodedTeams
    }
    
    class func setCustomObjToUserDefaultsInBackgroundThread(CustomeObj: AnyObject , key: String) {
        runInBackground {
            let defaults = UserDefaults.standard
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: CustomeObj)
            defaults.set(encodedData, forKey: key)
            defaults.synchronize()
        }
    }
    
    class func removeCustomObject(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    class func iskeyAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    class func clearUserdefaullts() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != kAppDeviceToken { defaults.removeObject(forKey: key) }
        }
    }
    
    
    //MARK:-
    class func setDict(dict: NSDictionary, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey:key)
    }
    
    class func getDict(key: String) -> NSDictionary {
        let data = UserDefaults.standard.object(forKey: key) as! NSData
        let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
        return object;
    }
    
    class func setArrayToUserDefaults(value: NSMutableArray , key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getArrayFromUserDefaults(key: String) -> NSMutableArray {
        return UserDefaults.standard.mutableArrayValue(forKey: key)
    }
}




extension Double {
   /// Rounds the double to decimal places value
   func rounded(toPlaces places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}

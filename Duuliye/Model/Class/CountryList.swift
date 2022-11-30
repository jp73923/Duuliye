//
//  CountryList.swift
//  Duuliye
//
//  Created by Developer on 09/09/22.
//

import Foundation
import SwiftyJSON

public class CountryList: NSObject, NSCoding {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    
    
    
    /*"_id": "6133757b2050f8dcab0502bf",
     "name": "Ethiopia",
     "code": "ET",
     "country_code": "+251",
     "flag": "https://cdn.britannica.com/12/12-004-A40EEB6F/Flag-Ethiopia.jpg"*/
    
      private struct SerializationKeys {
      static let id = "_id"
      static let name = "name"
      static let code = "code"
      static let countrycode = "country_code"
      static let flag = "flag"
      

    }

    // MARK: Properties
    public var id: String?
    public var name: String?
    public var code: String?
    public var countrycode: String?
    public var flag: String?
    

    // MARK: SwiftyJSON Initalizers
    /**
    Initates the class based on the object
    - parameter object: The object of either Dictionary or Array kind that was passed.
    - returns: An initalized instance of the class.
    */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }

    /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public init(json: JSON) {
        id = json[SerializationKeys.id].string
        name = json[SerializationKeys.name].string
        code = json[SerializationKeys.code].string
        countrycode = json[SerializationKeys.countrycode].string
        flag = json[SerializationKeys.flag].string
        

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : Any] {

        var dictionary: [String : Any] = [ : ]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = code { dictionary[SerializationKeys.code] = value }
        if let value = countrycode { dictionary[SerializationKeys.countrycode] = value }
        if let value = flag { dictionary[SerializationKeys.flag] = value }
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
        self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
        self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? String
        self.countrycode = aDecoder.decodeObject(forKey: SerializationKeys.countrycode) as? String
        self.flag = aDecoder.decodeObject(forKey: SerializationKeys.flag) as? String
        

    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(name, forKey: SerializationKeys.name)
        aCoder.encode(code, forKey: SerializationKeys.code)
        aCoder.encode(countrycode, forKey: SerializationKeys.countrycode)
        aCoder.encode(flag, forKey: SerializationKeys.flag)
        
    }

}


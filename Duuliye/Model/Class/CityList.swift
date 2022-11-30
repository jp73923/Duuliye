//
//  CityList.swift
//  Duuliye
//
//  Created by Developer on 14/06/22.
//

import Foundation
import SwiftyJSON

public class CityList: NSObject, NSCoding {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    
    private struct SerializationKeys {
      static let id = "_id"
      static let cityName = "city_name"
      static let code = "code"
      static let airportname = "airport_name"
      

    }

    // MARK: Properties
    public var id: String?
    public var cityName: String?
    public var code: String?
    public var airportName: String?
    

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
        cityName = json[SerializationKeys.cityName].string
        code = json[SerializationKeys.code].string
        airportName = json[SerializationKeys.airportname].string
        

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : Any] {

        var dictionary: [String : Any] = [ : ]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = cityName { dictionary[SerializationKeys.cityName] = value }
        if let value = code { dictionary[SerializationKeys.code] = value }
        if let value = airportName { dictionary[SerializationKeys.airportname] = value }
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
        self.cityName = aDecoder.decodeObject(forKey: SerializationKeys.cityName) as? String
        self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? String
        self.airportName = aDecoder.decodeObject(forKey: SerializationKeys.airportname) as? String
        

    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(cityName, forKey: SerializationKeys.cityName)
        aCoder.encode(code, forKey: SerializationKeys.code)
        aCoder.encode(airportName, forKey: SerializationKeys.airportname)
        
    }

}


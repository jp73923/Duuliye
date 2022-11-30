//
//  Companies.swift
//  Duuliye
//
//  Created by Developer on 22/06/22.
//

import Foundation
import SwiftyJSON

public class Companies: NSObject, NSCoding {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    
    private struct SerializationKeys {
      static let id = "_id"
      static let name = "name"
      static let logo = "logo"
     
      

    }

    // MARK: Properties
    public var id: String?
    public var name: String?
    public var logo: String?
   
    

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
        logo = json[SerializationKeys.logo].string
       
        

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : Any] {

        var dictionary: [String : Any] = [ : ]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = logo { dictionary[SerializationKeys.logo] = value }
       
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
        self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
        self.logo = aDecoder.decodeObject(forKey: SerializationKeys.logo) as? String
        

    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(name, forKey: SerializationKeys.name)
        aCoder.encode(logo, forKey: SerializationKeys.logo)
       
        
    }

}


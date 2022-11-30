//
//  History.swift
//  Duuliye
//
//  Created by Developer on 01/08/22.
//

import Foundation

import SwiftyJSON

public class History: NSObject, NSCoding {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
      static let id = "_id"
      static let ticketid = "ticket_id"
      static let userid = "user_id"
      static let compname = "comp_name"
      static let fromcity = "from_city"
      static let tocity = "to_city"
      static let fare = "fare"
      static let ticketurl = "ticket_url"
      

    }

    // MARK: Properties
    public var id : String?
    public var ticketid: String?
    public var userid: String?
    public var compname: String?
    public var fromcity: String?
    public var tocity: String?
    public var fare: Int?
    public var ticketurl: String?
    

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
        ticketid = json[SerializationKeys.ticketid].string
        userid = json[SerializationKeys.userid].string
        compname = json[SerializationKeys.compname].string
        fromcity = json[SerializationKeys.fromcity].string
        tocity = json[SerializationKeys.tocity].string
        fare = json[SerializationKeys.fare].int
        ticketurl = json[SerializationKeys.ticketurl].string
     
    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : Any] {

        var dictionary: [String : Any] = [ : ]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = ticketid { dictionary[SerializationKeys.ticketid] = value }
        if let value = userid { dictionary[SerializationKeys.userid] = value }
        if let value = compname { dictionary[SerializationKeys.compname] = value }
        if let value = fromcity { dictionary[SerializationKeys.fromcity] = value }
        if let value = tocity { dictionary[SerializationKeys.tocity] = value }
        if let value = fare { dictionary[SerializationKeys.fare] = value }
        if let value = ticketurl { dictionary[SerializationKeys.ticketurl] = value }
        
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.ticketid = aDecoder.decodeObject(forKey: SerializationKeys.ticketid) as? String
    self.userid = aDecoder.decodeObject(forKey: SerializationKeys.userid) as? String
    self.compname = aDecoder.decodeObject(forKey: SerializationKeys.compname) as? String
    self.fromcity = aDecoder.decodeObject(forKey: SerializationKeys.fromcity) as? String
    self.tocity = aDecoder.decodeObject(forKey: SerializationKeys.tocity) as? String
    self.fare = aDecoder.decodeObject(forKey: SerializationKeys.fare) as? Int
    self.ticketurl = aDecoder.decodeObject(forKey: SerializationKeys.ticketurl) as? String
  
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(ticketid, forKey: SerializationKeys.ticketid)
        aCoder.encode(userid, forKey: SerializationKeys.userid)
        aCoder.encode(compname, forKey: SerializationKeys.compname)
        aCoder.encode(fromcity, forKey: SerializationKeys.fromcity)
        aCoder.encode(tocity, forKey: SerializationKeys.tocity)
        aCoder.encode(fare, forKey: SerializationKeys.fare)
        aCoder.encode(ticketurl, forKey: SerializationKeys.ticketurl)
        
    }

}


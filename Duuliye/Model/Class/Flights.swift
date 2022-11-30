//
//  Flights.swift
//  Duuliye
//
//  Created by Developer on 16/06/22.
//

import Foundation
import SwiftyJSON

public class Flights: NSObject, NSCoding {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
      static let id = "_id"
      static let scheduleid = "schedule_id"
      static let compname = "comp_name"
      static let complogo = "comp_logo"
      static let fromcity = "from_city"
      static let tocity = "to_city"
      static let fare = "fare"
      static let flightnumber = "flight_number"
      static let enroute = "en_route"
      static let departuredate = "departure_date"
      static let departuretime = "departure_time"
      static let arrivaldate = "arrival_date"
      static let arrivaltime = "arrival_time"
      static let curency = "curency"

    }

    // MARK: Properties
    public var id: String?
    public var scheduleid: String?
    public var compname: String?
    public var complogo: String?
    public var fromcity: String?
    public var tocity: String?
    public var fare: Int?
    public var flightnumber: String?
    public var enroute: Int?
    public var departuredate: String?
    public var departuretime: String?
    public var arrivaldate: String?
    public var arrivaltime: String?
    public var curency: String?

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
        scheduleid = json[SerializationKeys.scheduleid].string
        compname = json[SerializationKeys.compname].string
        complogo = json[SerializationKeys.complogo].string
        fromcity = json[SerializationKeys.fromcity].string
        tocity = json[SerializationKeys.tocity].string
        fare = json[SerializationKeys.fare].int
        flightnumber = json[SerializationKeys.flightnumber].string
        enroute = json[SerializationKeys.enroute].int
        departuredate = json[SerializationKeys.departuredate].string
        departuretime = json[SerializationKeys.departuretime].string
        arrivaldate = json[SerializationKeys.arrivaldate].string
        arrivaltime = json[SerializationKeys.arrivaltime].string
        curency = json[SerializationKeys.curency].string
    
    
    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : Any] {

        var dictionary: [String : Any] = [ : ]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = scheduleid { dictionary[SerializationKeys.scheduleid] = value }
        if let value = compname { dictionary[SerializationKeys.compname] = value }
        if let value = complogo { dictionary[SerializationKeys.complogo] = value }
        if let value = fromcity { dictionary[SerializationKeys.fromcity] = value }
        if let value = tocity { dictionary[SerializationKeys.tocity] = value }
        if let value = fare { dictionary[SerializationKeys.fare] = value }
        if let value = flightnumber { dictionary[SerializationKeys.flightnumber] = value }
        if let value = enroute { dictionary[SerializationKeys.enroute] = value }
        if let value = departuredate { dictionary[SerializationKeys.departuredate] = value }
        if let value = departuretime { dictionary[SerializationKeys.departuretime] = value }
        if let value = arrivaldate { dictionary[SerializationKeys.arrivaldate] = value }
        if let value = arrivaltime { dictionary[SerializationKeys.arrivaltime] = value }
        if let value = curency { dictionary[SerializationKeys.curency] = value }
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.scheduleid = aDecoder.decodeObject(forKey: SerializationKeys.scheduleid) as? String
    self.compname = aDecoder.decodeObject(forKey: SerializationKeys.compname) as? String
    self.complogo = aDecoder.decodeObject(forKey: SerializationKeys.complogo) as? String
    self.fromcity = aDecoder.decodeObject(forKey: SerializationKeys.fromcity) as? String
    self.tocity = aDecoder.decodeObject(forKey: SerializationKeys.tocity) as? String
    self.fare = aDecoder.decodeObject(forKey: SerializationKeys.fare) as? Int
    self.flightnumber = aDecoder.decodeObject(forKey: SerializationKeys.flightnumber) as? String
    self.enroute = aDecoder.decodeObject(forKey: SerializationKeys.enroute) as? Int
    self.departuredate = aDecoder.decodeObject(forKey: SerializationKeys.departuredate) as? String
    self.departuretime = aDecoder.decodeObject(forKey: SerializationKeys.departuretime) as? String
    self.arrivaldate = aDecoder.decodeObject(forKey: SerializationKeys.arrivaldate) as? String
    self.arrivaltime = aDecoder.decodeObject(forKey: SerializationKeys.arrivaltime) as? String
    self.curency = aDecoder.decodeObject(forKey: SerializationKeys.curency) as? String
        
        

    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(scheduleid, forKey: SerializationKeys.scheduleid)
        aCoder.encode(compname, forKey: SerializationKeys.compname)
        aCoder.encode(complogo, forKey: SerializationKeys.complogo)
        aCoder.encode(fromcity, forKey: SerializationKeys.fromcity)
        aCoder.encode(tocity, forKey: SerializationKeys.tocity)
        aCoder.encode(fare, forKey: SerializationKeys.fare)
        aCoder.encode(flightnumber, forKey: SerializationKeys.flightnumber)
        aCoder.encode(enroute, forKey: SerializationKeys.enroute)
        aCoder.encode(departuredate, forKey: SerializationKeys.departuredate)
        aCoder.encode(departuretime, forKey: SerializationKeys.departuretime)
        aCoder.encode(arrivaldate, forKey: SerializationKeys.arrivaldate)
        aCoder.encode(arrivaltime, forKey: SerializationKeys.arrivaltime)
        aCoder.encode(curency, forKey: SerializationKeys.curency)
    }

}



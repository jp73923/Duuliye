//
//  ClassUser.swift
//
//  Created by Jay on 11/04/22
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ClassUser: NSObject, NSCoding {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
      static let userid = "user_id"
      static let phone = "phone"
      static let lastName = "last_name"
      static let firstName = "first_name"
      static let email = "email"
      static let passport = "passport"
      static let token = "token"
        static let countryCode = "country_code"
        static let countryName = "country_name"

    }

    // MARK: Properties
    public var userid: String?
    public var phone: String?
    public var lastName: String?
    public var firstName: String?
    public var email: String?
    public var passport: String?
    public var token: String?
    public var countryCode: String?
    public var countryName: String?

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
        userid = json[SerializationKeys.userid].string
        email = json[SerializationKeys.email].string
        lastName = json[SerializationKeys.lastName].string
        firstName = json[SerializationKeys.firstName].string
        passport = json[SerializationKeys.passport].string
        phone = json[SerializationKeys.phone].string
        token = json[SerializationKeys.token].string
        countryCode = json[SerializationKeys.countryCode].string
        countryName = json[SerializationKeys.countryName].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : Any] {

        var dictionary: [String : Any] = [ : ]
        if let value = userid { dictionary[SerializationKeys.userid] = value }
        if let value = passport { dictionary[SerializationKeys.passport] = value }
        if let value = lastName { dictionary[SerializationKeys.lastName] = value }
        if let value = firstName { dictionary[SerializationKeys.firstName] = value }
        if let value = email { dictionary[SerializationKeys.email] = value }
        if let value = userid { dictionary[SerializationKeys.userid] = value }
        if let value = phone
        { dictionary[SerializationKeys.phone] = value }
        if let value = token
        { dictionary[SerializationKeys.token] = value }
        if let value = countryCode
        { dictionary[SerializationKeys.countryCode] = value }
        if let value = countryName
        { dictionary[SerializationKeys.countryName] = value }
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.userid = aDecoder.decodeObject(forKey: SerializationKeys.userid) as? String
        self.lastName = aDecoder.decodeObject(forKey: SerializationKeys.lastName) as? String
        self.firstName = aDecoder.decodeObject(forKey: SerializationKeys.firstName) as? String
        self.email = aDecoder.decodeObject(forKey: SerializationKeys.email) as? String
        self.passport = aDecoder.decodeObject(forKey: SerializationKeys.passport) as? String
        self.phone = aDecoder.decodeObject(forKey: SerializationKeys.phone) as? String
        self.token = aDecoder.decodeObject(forKey: SerializationKeys.token) as? String
        self.countryName = aDecoder.decodeObject(forKey: SerializationKeys.countryName) as? String
        self.countryCode = aDecoder.decodeObject(forKey: SerializationKeys.countryCode) as? String

    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(userid, forKey: SerializationKeys.userid)
        aCoder.encode(lastName, forKey: SerializationKeys.lastName)
        aCoder.encode(firstName, forKey: SerializationKeys.firstName)
        aCoder.encode(email, forKey: SerializationKeys.email)
        aCoder.encode(passport, forKey: SerializationKeys.passport)
        aCoder.encode(phone, forKey: SerializationKeys.phone)
        aCoder.encode(token, forKey: SerializationKeys.token)
        aCoder.encode(countryCode, forKey: SerializationKeys.countryCode)
        aCoder.encode(countryName, forKey: SerializationKeys.countryName)
    }

}

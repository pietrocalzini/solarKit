//
//  Utils.swift
//  SolarPosition
//
//  Created by Pietro Calzini on 12/10/2016.
//  Copyright © 2016 Pietro Calzini. All rights reserved.
//

import UIKit

class Utils{
    
    /**
     Function to calculate the time number code from a date
     
     - Parameter date: The date from which to extract the time zone.
     - Returns: Time zone number.
     
     */
    
    static func localTimeZoneNumberForDate(date: Date)->Int{
        var localTimeZoneAbbreviation: String { return NSTimeZone.local.abbreviation(for: date) ?? ""}
        let index1 = localTimeZoneAbbreviation.index(localTimeZoneAbbreviation.startIndex, offsetBy: 3)
        let timeZoneCode = localTimeZoneAbbreviation.substring(from: index1)
        return Int(timeZoneCode)!
    }
    
    /**
     Function to extract the time zone number from a time zone code
     
     - Parameter localTimeZoneAbbreviation: Time zone code.
     - Returns: Time zone number.
     
     */
    
    static func localTimeZoneNumber(localTimeZoneAbbreviation: String)->Int{
        let index1 = localTimeZoneAbbreviation.index(localTimeZoneAbbreviation.startIndex, offsetBy: 3)
        let timeZoneCode = localTimeZoneAbbreviation.substring(from: index1)
        return Int(timeZoneCode)!
    }
    
    /**
     Function to convert radian angle to degree angle
     
     - Parameter angleDeg: The angle in degrees.
     - Returns: The angle in radians.
     
     */
    
    static func degToRad(_ angleDeg:Double) ->Double{
        return (M_PI * angleDeg / 180.0);
    }
    
    /**
     
     Function to convert radian angle to degree angle
     
     - Parameter radToDeg: The angle in radians.
     - Returns: The angle in degrees.
     
     */
    
    static func radToDeg(_ angleRad:Double) ->Double{
        return (180.0 * angleRad / M_PI);
    }
    
    /**
     
     Function to convert latitude and longitude from degrees-minutes-seconds to degrees
     - Parameter coordinate: The latitude or longitude to convert.
     - Returns: The coordinate in degree.
     
     */
    
    static func toDegrees(_ degrees: Double, minutes: Double, seconds: Double) ->Double{
        return degrees + minutes/60 + seconds/3600;
    }
    
    /**
     
     Function to convert latitude and longitude from degrees to degrees-minutes-seconds
     - Parameter coordinate: The latitude or longitude to convert.
     - Returns: An array containing the coordinate in degrees, minutes and seconds.
     
     */
    
    static func toDegreesMinutesSeconds(coordinate: Double) ->[Double]{
        let minutes = modf(coordinate).1*60
        let seconds = modf(minutes).1*60
        let degrees = modf(coordinate).0
        return [degrees,minutes,seconds];
    }
    
}

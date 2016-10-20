//
//  Utils.swift
//  SolarPosition
//
//  Created by Pietro Calzini on 12/10/2016.
//  Copyright © 2016 Pietro Calzini.
//  Inspired by http://www.esrl.noaa.gov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class Utils{
    
    /**
     Function to calculate the time zone number code from a date
     
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

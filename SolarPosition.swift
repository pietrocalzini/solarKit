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

class SolarPosition{
    
    /**
     
     Function to convert a calendar day into a Julian day.
     
     - Parameter year: 4 digits year.
     - Parameter day: Day of the month in range 1-31.
     - Parameter month: Month of the year in range 1-12.
     - Returns: The Julian day corresponding to the date.
     
     */
    
    public func calcJD(_ year: Int,month: Int, day: Int) -> Double{
        var m = month
        var y = year
        if(month <= 2) {
            y = year + 1
            m = month + 12
        }
        let A = floor(Double(year/100))
        let B = 2 - A + floor(A/4)
        let part1 = floor(365.25 * (Double(y + 4716)))
        let part2 = floor(30.6001 * (Double(m+1)))
        let JD = part1 + part2 + Double(day) + B - 1524.5
        return JD
        
    }
    
    /**
     
     Function to convert Julian Day to centuries since J2000.0.
     
     - Parameter jd: The Julian Day to convert
     - Returns: The T value corresponding to the Julian Day.
     
     */
    
    public func calcTimeJulianCent(_ jd: Double) -> Double{
        let T = (jd - 2451545.0)/36525.0
        return T
    }
    
    /**
     
     Function to calculate the Geometric Mean Anomaly of the Sun
     
     - Parameter t: Number of Julian centuries since J2000.0
     - Returns: The Geometric Mean Anomaly of the Sun in degrees
     
     */
    
    public func calcGeomMeanAnomalySun(_ t: Double) -> Double {
        let M = 357.52911 + t * (35999.05029 - 0.0001537 * t);
        return M;
    }
    
    /**
     
     Function to calculate the true anamoly of the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0
     - Returns: Sun true anomaly in degrees
     
     */
    
    public func calcSunTrueAnomaly(_ t:Double) -> Double {
        let m = calcGeomMeanAnomalySun(t);
        let c = calcSunEqOfCenter(t);
        let v = m + c;
        return v;
    }
    
    /**
     
     Function to calculate the equation of center for the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0
     - Returns: The equation of center for the sun in degrees.
     
     */
    
    public func calcSunEqOfCenter(_ t: Double) -> Double {
        let m = calcGeomMeanAnomalySun(t);
        let mrad = ((m * M_PI) / 180);
        let sinm = sin(mrad);
        let sin2m = sin(mrad+mrad);
        let sin3m = sin(mrad+mrad+mrad);
        
        let C = sinm * (1.914602 - t * (0.004817 + 0.000014 * t)) + sin2m * (0.019993 - 0.000101 * t) + sin3m * 0.000289;
        return C;
    }
    
    /**
     
     Function to calculate the eccentricity of earth's orbit.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: The unitless eccentricity .
     
     */
    
    public func calcEccentricityEarthOrbit(_ t:Double) -> Double{
        let e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);
        return e;
    }
    
    /**
     
     Function to calculate the distance to the sun in AU.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Sun's radius vector in Astnomic Units.
     
     */
    
    public func calcSunRadVector(_ t: Double)->Double{
        let v = calcSunTrueAnomaly(t);
        let e = calcEccentricityEarthOrbit(t);
        let R = (1.000001018 * (1 - e * e)) / (1 + e * cos(Utils.degToRad(v)));
        return R;
    }
    
    /**
     
     Function to calculate the right ascension of the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Sun's rigth ascension in degrees.
     
     */
    
    public func calcSunRtAscension(_ t:Double) -> Double{
        let e = calcObliquityCorrection(t);
        let lambda = calcSunApparentLong(t);
        let tananum = (cos(Utils.degToRad(e)) * sin(Utils.degToRad(lambda)));
        let tanadenom = (cos(Utils.degToRad(lambda)));
        let alpha = Utils.radToDeg(atan2(tananum, tanadenom));
        return alpha;
    }
    
    /**
     
     Function to calculate the declination of the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Sun's declination in degrees  .
     
     */
    
    public func calcObliquityCorrection(_ t:Double) -> Double {
        let e0 = calcMeanObliquityOfEcliptic(t);
        let omega = 125.04 - 1934.136 * t;
        let e = e0 + 0.00256 * cos(Utils.degToRad(omega));
        return e;		// in degrees
    }
    
    /**
     
     Function to calculate the mean obliquity of the ecliptic.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Mean obliquity in degrees  .
     
     */
    
    public func calcMeanObliquityOfEcliptic(_ t:Double) -> Double{
        let seconds = 21.448 - t*(46.8150 + t*(0.00059 - t*(0.001813)));
        let e0 = 23.0 + (26.0 + (seconds/60.0))/60.0;
        return e0;
    }
    
    /**
     
     Function to calculate the apparent longitude of the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Sun's apparent longitude in degrees .
     
     */
    
    public func calcSunApparentLong(_ t:Double) -> Double{
        let o = calcSunTrueLong(t);
        let omega = 125.04 - 1934.136 * t;
        let lambda = o - 0.00569 - 0.00478 * sin(Utils.degToRad(omega));
        return lambda;		// in degrees
    }
    
    /**
     
     Function to calculate the true longitude of the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Sun's true longitude in degrees.
     
     */
    
    public func calcSunTrueLong(_ t: Double) -> Double {
        let l0 = calcGeomMeanLongSun(t);
        let c = calcSunEqOfCenter(t);
        let O = l0 + c;
        return O;		// in degrees
    }
    
    /**
     
     Function to calculate the Geometric Mean Longitude of the Sun.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: The Geometric Mean Longitude of the Sun in degrees.
     
     */
    
    public func calcGeomMeanLongSun(_ t: Double) ->Double{
        var L0 = 280.46646 + t * (36000.76983 + 0.0003032 * t);
        while(L0 > 360.0)
        {
            L0 -= 360.0;
        }
        while(L0 < 0.0)
        {
            L0 += 360.0;
        }
        return L0;
    }
    
    /**
     
     Function to calculate the declination of the sun.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Sun's declination in degrees.
     
     */
    
    public func calcSunDeclination(_ t:Double) ->Double{
        let e = calcObliquityCorrection(t);
        let lambda = calcSunApparentLong(t);
        let sint = sin(Utils.degToRad(e)) * sin(Utils.degToRad(lambda));
        let theta = Utils.radToDeg(asin(sint));
        return theta;		// in degrees
    }
    
    /**
     
     Function to calculate the difference between true solar time and mean solar time.
     
     - Parameter t: Number of Julian centuries since J2000.0.
     - Returns: Equation of time in minutes of time.
     
     */
    
    public func calcEquationOfTime(_ t:Double)->Double{
        let epsilon = calcObliquityCorrection(t);
        let l0 = calcGeomMeanLongSun(t);
        let e = calcEccentricityEarthOrbit(t);
        let m = calcGeomMeanAnomalySun(t);
        
        var y = tan(Utils.degToRad(epsilon)/2.0);
        y *= y;
        
        let sin2l0 = sin(2.0 * Utils.degToRad(l0));
        let sinm   = sin(Utils.degToRad(m));
        let cos2l0 = cos(2.0 * Utils.degToRad(l0));
        let sin4l0 = sin(4.0 * Utils.degToRad(l0));
        let sin2m  = sin(2.0 * Utils.degToRad(m));
        
        let Etime = y * sin2l0 - 2.0 * e * sinm + 4.0 * e * y * sinm * cos2l0
            - 0.5 * y * y * sin4l0 - 1.25 * e * e * sin2m;
        
        return Utils.radToDeg(Etime)*4.0;
    }
    
    /**
     
     Function to calculate.
     
     - Parameter
     - Returns:
     
     */
    
    public func timenow(hour: Int, min: Int, sec: Int, zone: Int)->Double{
        let h = Double(hour)
        let m = Double(min/60)
        let s = Double(sec/3600)
        let z = Double(zone)
        let timenow = h + m + s + z
        return timenow
    }
    
    /**
     
     Function to calculate.
     
     - Parameter
     - Returns:
     
     */
    
    private func solarTimeFix(long: Double, z: Int, eqTime: Double)->Double{
        let solarTimeFix = eqTime - 4.0 * long + 60.0 * Double(z);
        return solarTimeFix;
    }
    
    /**
     
     Function to calculate the true solar time.
     
     - Parameter solarFixtime: the fix time of the sun.
     - Parameter sec: Seconds.
     - Parameter min: Minutes.
     - Parameter hour: Hour.

     - Returns: the true solar time
     
     */
    
    private func trueSolarTime(solarTimeFix: Double, hour: Double, min: Double, sec: Double)->Double{
        var trueSolarTime = hour * 60.0 + min + sec/60.0 + solarTimeFix;
        while (trueSolarTime > 1440)
        {
            trueSolarTime -= 1440;
        }
        return trueSolarTime;
    }
    
    /**
     
     Function to calculate.
     
     - Parameter
     - Returns:
     
     */
    
    private func hourAngle(trueSolarTime: Double)->Double{
        var hourAngle = trueSolarTime / 4.0 - 180.0;
        
        if (hourAngle < -180)
        {
            hourAngle += 360.0;
        }
        return hourAngle;
    }
    
    /**
     
     Function to calculate the zenith of the sun
     
     - Parameter lat: Latitude.
     - Parameter long: Longitude.
     - Parameter sec: Seconds.
     - Parameter min: Minutes.
     - Parameter hour: Hour.
     - Parameter z: Time zone number.
     - Parameter day: Day of the year.
     - Parameter z: Month of the year.
     - Parameter z: Year.
     
     - Returns: The zenith of the sun in degrees
     
     */
    
    public func calcZenith(_ lat: Double, long: Double, sec:Double, min: Double, hour: Double, z: Int, day: Int, month: Int, year: Int)->Double{
        
        let ss = sec
        let mm = min
        let hh = hour
        let zone = z
        
        let timenow = Double(hh) + mm/60 + ss/3600 + Double(zone)
        
        let JD = calcJD(year, month: month, day: day)
        let T = calcTimeJulianCent(JD + timenow/24.0)
        let solarDec = calcSunDeclination(T);
        let eqTime = calcEquationOfTime(T);
        
        let solarTimeFix = self.solarTimeFix(long: long, z:zone, eqTime: eqTime);
        let trueSolarTime = self.trueSolarTime(solarTimeFix: solarTimeFix, hour: hh, min: mm, sec: ss)
        
        //var hourAngle = calcHourAngle(timenow, longitude, eqTime);
        let hourAngle =  self.hourAngle(trueSolarTime: trueSolarTime)
        
        let haRad = Utils.degToRad(hourAngle)
        
        var csz = sin(Utils.degToRad(lat)) * sin(Utils.degToRad(solarDec)) + cos(Utils.degToRad(lat)) * cos(Utils.degToRad(solarDec)) * cos(haRad);
        
        if (csz > 1.0)
        {
            csz = 1.0;
        } else if (csz < -1.0)
        {
            csz = -1.0;
        }
        
        let zenith = Utils.radToDeg(acos(csz));
        return zenith;
    }
    
    /**
     
     Function to calculate the solar azimuth at a specific location in a specific moment in time
     
     - Parameter lat: Latitude.
     - Parameter long: Longitude.
     - Parameter sec: Seconds.
     - Parameter min: Minutes.
     - Parameter hour: Hour.
     - Parameter z: Time zone number.
     - Parameter day: Day of the year.
     - Parameter z: Month of the year.
     - Parameter z: Year.

     - Returns: The solar azimuth in degrees from North
     
     */
    
    public func calcAzimuth(_ lat: Double, long: Double, sec:Double, min: Double, hour: Double, z: Int, day: Int, month: Int, year: Int)->Double{
        
        var azRad :Double
        var azimuth :Double
        let timenow = Double(hour) + min/60 + sec/3600 + Double(z)
        
        let JD = calcJD(year, month: month, day: day)
        let T = calcTimeJulianCent(JD + timenow/24.0)
        let solarDec = calcSunDeclination(T);
        let eqTime = calcEquationOfTime(T);
        
        let solarTimeFix = self.solarTimeFix(long: long, z:z, eqTime: eqTime);
        let trueSolarTime = self.trueSolarTime(solarTimeFix: solarTimeFix, hour: hour, min: min, sec: sec)
        
        let hourAngle =  self.hourAngle(trueSolarTime: trueSolarTime)
        
        let zenith = calcZenith(lat, long: long, sec: sec, min: min, hour: hour, z: z, day: day, month: month, year: year)
        
        let azDenom = ( cos(Utils.degToRad(lat)) *
            sin(Utils.degToRad(zenith)) );
        if (abs(azDenom) > 0.001) {
            azRad = ((sin(Utils.degToRad(lat)) * cos(Utils.degToRad(zenith)) ) - sin(Utils.degToRad(solarDec))) / azDenom;
            if (abs(azRad) > 1.0) {
                if (azRad < 0) {
                    azRad = -1.0;
                } else {
                    azRad = 1.0;
                }
            }
            
            azimuth = 180.0 - Utils.radToDeg(acos(azRad));
            if (hourAngle > 0.0) {
                azimuth = -azimuth;
            }
        } else {
            if (lat > 0.0) {
                azimuth = 180.0;
            } else {
                azimuth = 0.0;
            }
        }
        if (azimuth < 0.0) {
            azimuth += 360.0;
        }
        
        let solarZenith = calcSolarZenith(zenith: zenith)
        
        if(solarZenith < 108.0) {
            azimuth = (floor(100*azimuth))/100;
        } else {
            azimuth = -1.0
        }
        
        return azimuth;
    }
    
    /**
     
     Function to calculate the solar zenith
     
     - Parameter zenith: The zenith of the sun
     - Returns: The solar zenith
     
     */
    
    public func calcSolarZenith(zenith: Double)->Double{
        
        var refractionCorrection:Double
        let exoatmElevation = 90.0 - zenith;
        if (exoatmElevation > 85.0) {
            refractionCorrection = 0.0;
        } else {
            let te = tan (Utils.degToRad(exoatmElevation));
            if (exoatmElevation > 5.0) {
                refractionCorrection = 58.1 / te - 0.07 / (te*te*te) + 0.000086 / (te*te*te*te*te);
            } else if (exoatmElevation > -0.575) {
                refractionCorrection = 1735.0 + exoatmElevation *
                    (-518.2 + exoatmElevation * (103.4 +
                        exoatmElevation * (-12.79 +
                            exoatmElevation * 0.711) ) );
            } else {
                refractionCorrection = -20.774 / te;
            }
            refractionCorrection = refractionCorrection / 3600.0;
        }
        
        let solarZen = zenith - refractionCorrection;
        return solarZen;
    }
    
    /**
     
     Function to calculate the solar elevation
     
     - Parameter solarZenith: The solar zenith.
     - Returns: Solar Elevation
     
     */
    
    public func calcSolarelevation(solarZenith: Double)->Double{
        
        var elevation:Double
        
        if(solarZenith < 108.0) {
            
            elevation = (floor(100*(90.0 - solarZenith)))/100;
            
        } else {
            
            elevation = -1.0
        }
        return elevation;
    }
}

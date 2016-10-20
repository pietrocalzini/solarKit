# solarKit
☀️🌎 Swift kit to work with astronomical calculations, coordinates and constants
## Usage

```swift
let solarPosition:SolarPosition = SolarPosition();
solarPosition.calcAzimuth(_ lat: 32.234, long: 12.234, sec:12, min: 12, hour: 2, z: 0, day: 1, 
month: 3, year: 2016)
```
###Solar calculations
Convert a calendar day into a Julian day
```swift
calcJD(_ year: Int,month: Int, day: Int) -> Double
```
Convert Julian Day to centuries since J2000.0
```swift
calcTimeJulianCent(_ jd: Double) -> Double
```
Calculate the Geometric Mean Anomaly of the Sun
```swift
calcGeomMeanAnomalySun(_ t: Double) -> Double 
```
Calculate the true anamoly of the sun
```swift
calcSunTrueAnomaly(_ t:Double) -> Double
```
Calculate the equation of center for the sun
```swift
calcSunEqOfCenter(_ t: Double) -> Double
```
Calculate the eccentricity of earth's orbit
```swift
calcEccentricityEarthOrbit(_ t:Double) -> Double
```
Calculate the distance to the sun in AU
```swift
calcSunRadVector(_ t: Double)->Double
```
Calculate the right ascension of the sun.
```swift
calcSunRtAscension(_ t:Double) -> Double
```
Calculate the declination of the sun.
```swift
calcObliquityCorrection(_ t:Double) -> Double
```
Calculate the mean obliquity of the ecliptic.
```swift
calcMeanObliquityOfEcliptic(_ t:Double) -> Double
```
Calculate the apparent longitude of the sun.
```swift
calcSunApparentLong(_ t:Double) -> Double
```
Calculate the true longitude of the sun.
```swift
calcSunTrueLong(_ t: Double) -> Double
```
Calculate the Geometric Mean Longitude of the Sun.
```swift
calcGeomMeanLongSun(_ t: Double) ->Double
```
Calculate the declination of the sun.
```swift
calcSunDeclination(_ t:Double) ->Double
```
Calculate the difference between true solar time and mean solar time
```swift
calcEquationOfTime(_ t:Double)->Double
```
Calculate the true solar time
```swift
trueSolarTime(solarTimeFix: Double, hour: Double, min: Double, sec: Double)->Double
```
Calculate the zenith of the sun
```swift
calcZenith(_ lat: Double, long: Double, sec:Double, min: Double, hour: Double, z: Int, day: Int,
month: Int, year: Int)->Double
```
Calculate the solar azimuth at a specific location in a specific moment in time
```swift
calcAzimuth(_ lat: Double, long: Double, sec:Double, min: Double, hour: Double, z: Int, day: Int, 
month: Int, year: Int)->Double
```
Calculate the solar zenith
```swift
calcSolarZenith(zenith: Double)->Double
```
Calculate the solar elevation
```swift
calcSolarelevation(solarZenith: Double)->Double
```
##Utilities
A collection of useful functions to work with coordinates and time zones

Calculate the time zone number code from a date
```swift
localTimeZoneNumberForDate(date: Date)->Int
```
Extract the time zone number from a time zone code
```swift
localTimeZoneNumberForDate(date: Date)->Int
```
Convert degree angle to radian angle
```swift
degToRad(_ angleDeg:Double) ->Double
```
Convert radian angle to degree angle
```swift
radToDeg(_ angleRad:Double) ->Double
```
Convert latitude and longitude from degrees-minutes-seconds to degrees
```swift
toDegrees(_ degrees: Double, minutes: Double, seconds: Double) ->Double
```
convert latitude and longitude from degrees to degrees-minutes-seconds
```swift
toDegreesMinutesSeconds(coordinate: Double) ->[Double]
```
Check out some info about the functions [here](http://www.esrl.noaa.gov/gmd/grad/solcalc/glossary.html)

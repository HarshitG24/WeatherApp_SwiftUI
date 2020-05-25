//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Harshit Gajjar on 5/24/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class LocationManager: NSObject, ObservableObject{
    
    private let locationManager = CLLocationManager()
    
    var location: CLLocation? = nil
    var json: JSON = JSON({})
    @Published var forecast = [Forecast]()
    @Published var weather: Weather? = nil
    
    override init() {
        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        self.locationManager.distanceFilter = kCLDistanceFilterNone
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        self.startUpdating()
        
    }
    
    func startUpdating(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func FetchLocation(lat: CLLocationDegrees, long: CLLocationDegrees){
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(appid)").responseJSON { response in
            
            if response.result.isSuccess{
                
                self.jsonData(json: JSON(response.result.value!))
                
            }else{
                print("invalid")
            }
        
        }
    }
    
    func fetchForecast(lat: CLLocationDegrees, long: CLLocationDegrees){
         var arr = [Forecast]()
        Alamofire.request("https://samples.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(long)&cnt=3&appid=\(appid)").responseJSON { (response) in
            
            if response.result.isSuccess{
                let json = JSON(response.result.value!)
              
            for i in 0...2 {
                
                let id = Int(json["list"][i]["weather"][0]["id"].double!)
                let temp = "\(Int(json["list"][i]["temp"]["max"].double! - 273.15)) °C"
                arr.append(
                    Forecast(id: i, day: self.dayFinder(i: i), imageName:self.weatherImageId(id: id), temperature: temp)
                )
                
                
                self.forecast = arr
            }
                print(self.forecast.count)
            }else{
                print("invalid")
            }
        }
    }
    
    func fetchLocation(city: String){
            Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=57406fc83a2d732e87e13a10f577caa3").responseJSON { (response) in
                
                if(response.result.isSuccess){
                    let json = JSON(response.result.value!)
                    self.jsonData(json: json)
                    
                    let lat = json["coord"]["lat"].doubleValue as CLLocationDegrees
                    let lon = json["coord"]["lon"].doubleValue as CLLocationDegrees
                    
                    self.fetchForecast(lat: lat, long: lon)
                }else{
                    print("invalid")
                }
            }
    }
    
    func dayFinder(i: Int)->String{
        let f = DateFormatter()

        return i == 0 ? "Tomorrow" : (f.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) + i])
    }
    
    func jsonData(json: JSON){
        let temporay = json["main"]["temp"].double
        let temp = "\(Int(temporay! - 273.15)) °C"
        let description = json["weather"][0]["description"]
        let maxtemp = "\(Int(json["main"]["temp_max"].double! - 273.15)) °C"
        let mintemp = "\(Int(json["main"]["temp_min"].double! - 273.15)) °C"
        let weatherImg = json["weather"][0]["id"]
        let pressure = "\(json["main"]["pressure"]) hPa"
        let name = "\(json["name"])"
        let feellike = "\(Int(json["main"]["feels_like"].double! - 273.15)) °C"
        let humidity = "\(Int(json["main"]["humidity"].double!)) %"
        
        self.weather = Weather(temperature: "\(temp)", cityName: "\(description)", description: "\(description)", maxtemp: "\(maxtemp)", mintemp: "\(mintemp)", weatherImg: "\(weatherImg)", pressure: "\(pressure)", name: "\(name)", feelslike: feellike, humidity: humidity)
    }
    
    func weatherImageId(id: Int) ->String{
         switch id {
         case 200...232:
             return "1"
             
         case 300...321:
             return "2"
             
         case 500...531:
             return "3"
             
         case 600...622:
             return "4"
             
         case 701...781:
             return "5"
             
         case 800:
             return "7"
             
         case 801...804:
             return "8"
         default:
             return ""
         }
     }
}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("this function called")
        guard let location = locations.last else{
            return
        }
        
        self.location = location
        self.FetchLocation(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        self.fetchForecast(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error)" )
    }
}

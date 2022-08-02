//
//  ViewController.swift
//  Viren_iOS_Lab03
//
//  Created by Viren Rakholiya on 01/08/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherUpdate: UILabel!
    
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayWeatherImages()
        searchTextField.delegate = self
        locationManager.delegate = self
    }

    @IBAction func onLocationTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func onSearchTapped(_ sender: UIButton) {
        loadWeather(search: searchTextField.text)
    }
    
    private func displayWeatherImages(){
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan, .systemYellow, .systemGray6])
        
        weatherConditionImage.preferredSymbolConfiguration = config
        weatherConditionImage.image = UIImage(systemName: "cloud.sun.rain")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        loadWeather(search: searchTextField.text)
        return true
    }
    
    private func loadWeather(search:String?){
            guard let search = search else {
                return
            }

            guard let url=getURL(query: search) else{
                print("Could not get URL")
                return
            }

            let session=URLSession.shared
            
            let dataTask=session.dataTask(with: url) { data, response, error in
                   print("Network call complete")
                
                guard error == nil else{
                    print("Recevied Error")
                    return
                }
                
                guard let data = data else {
                    print("No data found")
                    return
                }
                
                if let weatherResponse=self.parseJSON(data: data){
                    print(weatherResponse.location.name)
                    print(weatherResponse.current.temp_c)
                    print(weatherResponse.current.condition)
                    
                    DispatchQueue.main.async { [self] in
                        self.locationLabel.text=weatherResponse.location.name
                        self.temperatureLabel.text="\(weatherResponse.current.temp_c)C"
                        self.weatherUpdate.text="\(weatherResponse.current.condition.text)"
                        let config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemYellow,.systemGray6])

                        self.weatherConditionImage.preferredSymbolConfiguration = config
                        if(weatherResponse.current.condition.code==1000)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"sun.max.fill")
                        } else if(weatherResponse.current.condition.code==1003)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                        }
                        else if(weatherResponse.current.condition.code==1003)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                        }
                        else if(weatherResponse.current.condition.code==1183)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.drizzle")
                        }
                        else if(weatherResponse.current.condition.code==1183)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.heavyrain")
                        }
                        else if(weatherResponse.current.condition.code==1210)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"snowflake")
                        }
                    }
                }
            }
            
            dataTask.resume()
        }
    private func parseJSON(data:Data)->WeatherResponse?{
            let decoder=JSONDecoder()
            var weather:WeatherResponse?
            
            do{
                weather = try decoder.decode(WeatherResponse.self,from:data)
            }catch{
                print(error)
            }
            
            return weather
        }
}

struct WeatherResponse:Decodable{
    let location:Location
    let current:Weather
}
struct Location:Decodable{
    let name:String
}
struct Weather:Decodable{
    let temp_c:Float
    let condition:WeatherCondition
}
struct WeatherCondition:Decodable{
    let text:String
    let code:Int
}

private func getURL(query:String)->URL?{

    let baseURL = "https://api.weatherapi.com/v1/"
    let currentEndpoint="current.json"
    let apikey="caa848f85eaf4cfa96f184042220208"
    
    guard let url="\(baseURL)\(currentEndpoint)?key=\(apikey)&q=\(query)"
    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
       return nil
   }
    
    return URL(string: url)
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got Location")
        
        if let location = locations.last{
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude, Logitude: \(latitude), \(longitude)")
            
            guard let url=getURL(query: "\(latitude), \(longitude)") else{
                print("Could not get URL")
                return
            }

            let session=URLSession.shared
            
            let dataTask=session.dataTask(with: url) { data, response, error in
                   print("Network call complete")
                
                guard error == nil else{
                    print("Recevied Error")
                    return
                }
                
                guard let data = data else {
                    print("No data found")
                    return
                }
                
                if let weatherResponse=self.parseJSON(data: data){
                    print(weatherResponse.location.name)
                    print(weatherResponse.current.temp_c)
                    print(weatherResponse.current.condition)
                    
                    DispatchQueue.main.async { [self] in
                        self.locationLabel.text=weatherResponse.location.name
                        self.temperatureLabel.text="\(weatherResponse.current.temp_c)C"
                        self.weatherUpdate.text="\(weatherResponse.current.condition.text)"
                        let config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemYellow,.systemGray6])

                        self.weatherConditionImage.preferredSymbolConfiguration = config
                        if(weatherResponse.current.condition.code==1000)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"sun.max.fill")
                        } else if(weatherResponse.current.condition.code==1003)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                        }
                        else if(weatherResponse.current.condition.code==1003)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.fill")
                        }
                        else if(weatherResponse.current.condition.code==1183)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.drizzle")
                        }
                        else if(weatherResponse.current.condition.code==1183)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"cloud.heavyrain")
                        }
                        else if(weatherResponse.current.condition.code==1210)
                        {
                            self.weatherConditionImage.image=UIImage(systemName:"snowflake")
                        }
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
}

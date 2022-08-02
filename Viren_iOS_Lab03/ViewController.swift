//
//  ViewController.swift
//  Viren_iOS_Lab03
//
//  Created by Viren Rakholiya on 01/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayWeatherImages()
    }

    @IBAction func onLocationTapped(_ sender: UIButton) {
    }
    
    @IBAction func onSearchTapped(_ sender: UIButton) {
    }
    
    private func displayWeatherImages(){
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemOrange, .systemGray6])
        
        weatherConditionImage.preferredSymbolConfiguration = config
        
        weatherConditionImage.image = UIImage(systemName: "cloud.sun.rain")
        
    }
}


//
//  ViewController.swift
//  GetWeather
//
//  Created by Anuranjan Bose on 14/06/20.
//  Copyright © 2020 Anuranjan Bose. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, DataController {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
    }
    
    private func bindTextField() {
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.getWeather(for: city)
                    }
                }
            }).disposed(by: disposeBag)
        
        /*
        self.cityNameTextField.rx.value
            .subscribe(onNext: { city in
                if let city = city {
                    if  city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.getWeather(for: city)
                    }
                }
            }).disposed(by: disposeBag)
        */
    }
    
    private func getWeather(for city: String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        
        /* before
        URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(WeatherResult.empty)
            .subscribe(onNext: { result in
                let weather = result.weather
                self.displayWeather(weather)
            })
        .disposed(by: disposeBag)
        */
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(WeatherResult.empty)
        
        /// Bind the search to text fields
        search.map { "\($0.weather.temperature) ℉"}
            .bind(to: self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.weather.humidity) 💦"}
            .bind(to: self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temperature) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "NA"
            self.humidityLabel.text = "NA"
        }
    }

}


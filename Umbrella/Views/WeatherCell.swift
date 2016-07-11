//
//  WeatherCell.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

extension WeatherIcon {
    
    var imageName: String? {
        let name: String?
        switch self {
        case .ClearSkyDay: name = "sunny"
        case .ClearSkyNight: name = "clear-night"
        case .CloudyDay: name = "cloudy"
        case .CloudyNight: name = "cloudy-night"
        case .Rain: name = "raining"
        case .Mist: name = "mist"
        case .Thunderstorm: name = "thunder"
        case .Snow: name = "snow"
        case .Overcast: name = "overcast"
        }
        return name
    }
    
    var image: UIImage? {
        guard let imageName = imageName else { return nil }
        return UIImage(named: imageName)
    }
}

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var weatherImageView: UIImageView?
    
    @IBOutlet weak var descriptionLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var temperatureLabel: UILabel?
    
    let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    var weather: Weather? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        guard let weather = weather else {
            return
        }
        
        weatherImageView?.image = weather.icon?.image
        
        descriptionLabel?.text = weather.description.capitalizedString
        descriptionLabel?.textColor = Defaults.Color.Primary.base
        
        let locale = NSLocale.currentLocale()
        temperatureLabel?.text = weather.temperature.descriptionForLocale(locale)
        temperatureLabel?.textColor = Defaults.Color.Primary.base
        
        timeLabel?.text = formatter.stringFromDate(weather.start)
        timeLabel?.textColor = Defaults.Color.Primary.base
    }
}

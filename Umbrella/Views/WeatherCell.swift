//
//  WeatherCell.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

extension WeatherIcon {
    var image: UIImage? {
        
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
        
        guard let imageName = name else { return nil }
        return UIImage(named: imageName)
    }
}

class WeatherCell: UITableViewCell {
    
    @IBOutlet var weatherImageView: UIImageView?
    
    @IBOutlet var descriptionLabel: UILabel?
    
    @IBOutlet var timeLabel: UILabel?
    
    @IBOutlet var temperatureLabel: UILabel?
    
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
        
        temperatureLabel?.text = weather.temperature.converted(to: .Celsius).description
        
        timeLabel?.text = formatter.stringFromDate(weather.start)
    }
}

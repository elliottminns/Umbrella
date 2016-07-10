//
//  WeatherHeaderView.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

class WeatherHeaderView: UIView {
    
    let locationLabel: UILabel
    
    let temperatureLabel: UILabel
    
    let descriptionLabel: UILabel
    
    let forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
        locationLabel = UILabel()
        temperatureLabel = UILabel()
        descriptionLabel = UILabel()
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        backgroundColor = Defaults.Color.Primary.base
        setupViews()
    }
    
    func setupViews() {
        setupLocationLabel()
        setupDescriptionLabel()
        setupTemperatureLabel()
    }
    
    func loadLabel(label: UILabel, withFontSize size: Defaults.Fonts = .Normal) {
        label.textColor = Defaults.Color.White.base
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = size.font
        addSubview(label)
    }
    
    func setupLocationLabel() {
        locationLabel.text = forecast.placeName
        loadLabel(locationLabel, withFontSize: .Header)
        let constraints = loadLabelConstraints(forLabel: locationLabel,
                                               withTopView: self)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func loadLabelConstraints(forLabel label: UILabel,
                                       withTopView view: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint]
        
        if #available(iOS 9.0, *) {
            
            let topAnchor: NSLayoutAnchor
            if view == self {
                topAnchor = self.topAnchor
            } else {
                topAnchor = view.bottomAnchor
            }
            
            constraints = [
                label.topAnchor.constraintEqualToAnchor(topAnchor),
                label.heightAnchor.constraintEqualToAnchor(heightAnchor,
                    multiplier: 0.32),
                label.leftAnchor.constraintEqualToAnchor(leftAnchor),
                label.rightAnchor.constraintEqualToAnchor(rightAnchor)
            ]
        } else {
            
            let topAttribute: NSLayoutAttribute = view == self ? .Top : .Bottom
            
            constraints = [
                NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top,
                    relatedBy: .Equal, toItem: view, attribute: topAttribute,
                    multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .Height,
                    relatedBy: .Equal, toItem: self, attribute: .Height,
                    multiplier: 0.32, constant: 0),
                NSLayoutConstraint(item: label, attribute: .Left,
                    relatedBy: .Equal, toItem: self, attribute: .Left,
                    multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .Right,
                    relatedBy: .Equal, toItem: self, attribute: .Right,
                    multiplier: 1, constant: 0),
            ]
        }
        
        return constraints
    }
    
    func setupTemperatureLabel() {
        loadLabel(temperatureLabel, withFontSize: .Header)
        let locale = NSLocale.currentLocale()
        temperatureLabel.text = forecast.currentTemperature?
            .descriptionForLocale(locale)
        
        let constraints = loadLabelConstraints(forLabel: temperatureLabel,
                                               withTopView: descriptionLabel)
        NSLayoutConstraint.activateConstraints(constraints)
        
    }
    
    func setupDescriptionLabel() {
        loadLabel(descriptionLabel, withFontSize: .Large)
        descriptionLabel.text = forecast.weather.first?.description.capitalizedString
        let constraints = loadLabelConstraints(forLabel: descriptionLabel,
                                               withTopView: locationLabel)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
}
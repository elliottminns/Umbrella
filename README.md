# Umbrella

## Build Instructions

### Xcode
To build umbrella, you need to have Xcode 7.0.0 and above, available [here](https://developer.apple.com/xcode/downloads/).

### Dependencies
Once downloaded, you also need to install the dependencies using Carthage in order to run the unit tests. If you do not already have Carthage, you can either install it via [homebrew](http://brew.sh) or via [direct download](https://github.com/Carthage/Carthage/releases).

Once Carthage is available, you can then install the dependencies via the below command:

```
$ carthage update --platform iOS
```

This will install the two dependencies of [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble)

### Deployment

Once you have your dependencies installed, Open up the `Umbrella.xcodeproj` file in the cloned directory.

Once the project is opened, select your deployment device from the top dropdown menu and press run. 

## Testing

Umbrella is tested using [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Nimble/Nimble) for Behaviour Unit Tests. And Xcode's UI testing for Functional UI Tests. To test the application, press CMD + U or select Test from the Product menu. Code coverage is also enabled via Xcode's code coverage option. 

## Open Weather API Key

This app uses an API Key obtained from [Open Weather Map](http://openweathermap.org). To ensure future usage for your own version, you should generate an API Key for yourself and link it to the app. 

You can generate an API key [here](http://openweathermap.org/appid).

Once you have signed up and created an APP ID, you need to then replace the current APP ID in the code. 

To do so, you should open up the file named `Configurations.plist` found in the directory root of the project, or under Configurations in the xcode tree view. There you will see a field called `OpenWeatherMap-APPID` which contains a token string. Replacing that token with your own APP ID will allow the app to use your own token. 

If the token does not exist in the configuration, or the file is deleted. Then the app will crash at run time to alert the developer.

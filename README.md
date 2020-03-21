# GameX iOS App (Swift)

GameX developed for case study with architectural experiments.

## Architectures

+ [Repository Pattern](https://medium.com/tiendeo-tech/ios-repository-pattern-in-swift-85a8c62bf436) (for communicating remote and local database)

+ MVVM-R: MVVM pattern with navigation logic separated from ViewController to ‘Router’ classes with protocols for don’t be affected for the UI changes and more readable code.

## Dependencies

All dependencies isolated with protocols for two reasons; if we decided change dependency its makes it very easy (just create a new class for changed dependency with this protocols and inject it) and more testable.

+ [Moya](https://github.com/Moya/Moya)
+ [Realm Database](https://realm.io)
+ [Kingfisher](https://github.com/onevcat/Kingfisher)

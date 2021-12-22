# Brightwheel

This app shows the 100 top repositories contributors.

Please install cocoa pods before launching the project:

$ pod install

This app uses VIPER architecture. 
Swinject for dependency injection. 
Moya for interaction with the API.
RxSwift for handling concurrences and threading.

The project has 4 main folders which are:

Business: It contains all use cases for this app.
DataAccess: It contains all kinds of repositories local, rest, and mock.
DI: It contains the main class for introducing dependency injection on the app.
UI: It contains the view controllers, custom views, and helpers for building the UI side.

Note:
In order to avoid the limit for requests of GitHub API is needed to set an "access_token", please set this in the Data.plist this the path to the file "Brightwheel/Brightwheel/DataAccess/Data.plist" in this file there is a row called credentials this is a dictionary into it there is a key called "accessToken" please set their value with your access_token.

Later in the RestRepository file this is the file path "Brightwheel/Brightwheel/DataAccess/RestRepository.swift" change this line self.addoAuth(false) to self.addoAuth(true) and that is all.


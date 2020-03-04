## iOS Version Integration 

#### Integrating the SDK with the Project 

1. Install CocoaPods if not present

2. Create a new repository to host your private pod spec

3. Add the repository to your local installation of cocoapods by running
```
pod repo add NAME URL
```

Replacing the url and name with the specific ones from your repository.


4. Get the latest source code for the sdk from [Github](https://github.com/eservice-electronic-payments/iOS_SDK) and upload it to your private repository.

5. Update the podspec with the link to your private repository. You can use the podspec provided in our repository as a guideline.
```
s.source           = { :git => YOURLINK, :tag => 1.0 }
```

Replace your link to point to your repository and latest version to the version included in the provided podspec file from [Github](https://github.com/eservice-electronic-payments/iOS_SDK)

6. Publish the new version to your private pod. This will also set up the repository when you run it for the first time.

```
pod repo push REPO_NAME SPEC_NAME.podspec
```

7. Add `pod ‘SPEC_NAME’` to your project pods list as in example below: 

```
source 'PRIVATESPECURL' . 
source 'https://github.com/CocoaPods/Specs.git' . 
project 'my-app.xcodeproj'   
platform :ios, '10.0' target 'my-app'   
do   
pod 'SPEC_NAME', '~> 1.0' 
end   
```

Make sure that `PRIVATESPECURL` points to your spec repository and it is listed ABOVE the official cocoapods spec.

A more in depth guide on setting up a private Cocoapods can be found [here](https://guides.cocoapods.org/making/private-cocoapods.html)



## Using the SDK

1. Retrieve the Mobile Cashier URL and session token from the IPG Turnkey Gateway API (see Section 1.1 of the IPG Gateway - 2 - AUTH-PURCHASE-VERIFY - Hosted Payment Page document, other API calls are documented similarly)

In the example provided in the [iOS Repository](https://github.com/eservice-electronic-payments/iOS_SDK), which can be cloned, a demo session token and Mobile Cashier URL are obtained via the SessionProvider.swift class.

This is an example of the request object:
```
struct SessionRequestData {
    let tokenUrl: URL
    let action: String?
    let customerID: String
    let customerFirstName: String?
    let customerLastName: String?
    let amount: Double?
    let currency: String?
    let country: String?
    let language: String?
    
    let merchantNotificationUrl: String?
    let merchantLandingPageUrl: String?
    let allowOriginUrl: String?
    
    let myriadFlowId: String
```
A full example can be found in `SessionRequestData.swift` of the example app. The response from the server is an `Evo.Session` object.


The merchant must implement a session token and Mobile Cashier URL request mechanism between the merchant server and the iOS app.


2. To display the Webpage via the SDK, after having obtained the Evo.Session, use either

`EVOWebViewController` as a full-screen controller, or
`EVOWebView` as a custom view to start Mobile Cashier URL.

2a. `EVOWebViewController` can be treated as any UIViewController, so it can be pushed, presented, etc. You generally want to embed it in a UINavigationController. That’s supported out of the box by using:

```
let webViewController = EVOWebViewController(session: session) { [weak self] status in
  //Implement your callback to get the payment status
}
        
let navigationController = webViewController.embedInNavigationController()
navigationController.navigationBar.tintColor = .darkText //Styling
present(navigationController, animated: true)//present the navigation controller
```

The session will be automatically started in viewDidLoad without requiring any action on your behalf.


2b.  `EVOWebView` is a subclass of UIView, so it can be used inside any existing UIViewController.

EVOWebViewController automatically handles most of the logic needed for the payment process for you, but if you want more control you can embed a EVOWebView inside your custom UIViewController. 

Use the `start(session, callback)` function to start the payment process.  

- The first parameter is a `Evo.Session` struct. You should create one prior to starting cashier and pass required data in the initializer. 

```
struct Session { 
	let mobileCashierUrl: URL         
	let token: String         
	let merchantId: String 
}
```

3. In both cases the callback parameter is a closure. Use it to obtain the Evo.Status ​enum to learn about the payment-related transaction result.

```
enum Status: String {         
      case success = "success"
      case cancelled = "cancel"
      case failed = "failure"
      case timeout = "timeout"
      case undetermined = "undetermined"
      case started = "paymentStarted"            
}
```

In some cases, the payment process will take more than one step to finish, as with 3DSecure or other authentication methods. This will not need to be handled by your application and it is taken care automatically for you by the framework.

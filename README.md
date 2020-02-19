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

Make sure that 'PRIVATESPECURL' points to your spec repository and it is listed ABOVE the official cocoapods spec.

A more in depth guide on setting up a private Cocoapods can be found [here](https://guides.cocoapods.org/making/private-cocoapods.html)

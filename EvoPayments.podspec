Pod::Spec.new do |spec|
  spec.name         = "EvoPayments"
  spec.version      = "1.0"
  spec.summary      = "A library to easily integrate EvoPayments to your iOS app."

  spec.description  = <<-DESC
  A library to easily integrate EvoPayments to your iOS app.
  See README.md for more information.
                   DESC

  spec.homepage     = "https://github.com/eservice-electronic-payments/iOS_SDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = "Intelligent Payments Ltd."
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/eservice-electronic-payments/iOS_SDK", :tag => "1.0" }
  spec.source_files  = "EvoPayments/EvoPayments/Sources/**/*.swift"
  spec.vendored_frameworks = "EvoPayments/EvoPayments/Sources/Libraries/ipworks3ds_sdk.xcframework"
  spec.swift_version = "5.0"
end

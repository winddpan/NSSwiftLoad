## NSSwiftLoad

easily bridge Objective-C +load to Swift

## Usage

#### Step1. import NSSwiftLoader.h and NSSwiftLoader.m into your project

#### Step2. 
``` 
class SwiftClassNeedsToStaticLoad: NSSwiftLoadProtocol {
    class func swiftLoad() {
		print("swiftLoaded!")
    }
} 
```
#import <UIKit/UIKit.h>

//! Project version number for ipworks3ds_sdk.
FOUNDATION_EXPORT double ipworks3ds_sdkVersionNumber;

//! Project version string for ipworks3ds_sdk.
FOUNDATION_EXPORT const unsigned char ipworks3ds_sdkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ipworks3ds_sdk/PublicHeader.h>

#import "IPWorks3DSClient.h"


@interface BundleReserveCapacity: NSObject

+ (void)configTextCmdName NS_SWIFT_NAME(configTextCmdName());

+ (void)directoryServerCertStoreTypeShowWhiteBox: (int) flag NS_SWIFT_NAME(directoryServerCertStoreTypeShowWhiteBox(_:));

+ (void)portsAppend NS_SWIFT_NAME(portsAppend());

@end
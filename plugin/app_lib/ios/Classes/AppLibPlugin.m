#import "AppLibPlugin.h"
#if __has_include(<app_lib/app_lib-Swift.h>)
#import <app_lib/app_lib-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_lib-Swift.h"
#endif

@implementation AppLibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppLibPlugin registerWithRegistrar:registrar];
}
@end

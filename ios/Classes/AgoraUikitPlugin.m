#import "AgoraUikitPlugin.h"
#if __has_include(<agora_uikit/agora_uikit-Swift.h>)
#import <agora_uikit/agora_uikit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "agora_uikit-Swift.h"
#endif

@implementation AgoraUikitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAgoraUikitPlugin registerWithRegistrar:registrar];
}
@end

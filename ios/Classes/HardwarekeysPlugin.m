#import "HardwarekeysPlugin.h"
#import <hardwarekeys/hardwarekeys-Swift.h>

@implementation HardwarekeysPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHardwarekeysPlugin registerWithRegistrar:registrar];
}
@end

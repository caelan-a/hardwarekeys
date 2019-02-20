#import "HardwarekeysPlugin.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "JPSVolumeButtonHandler.h"
#import <hardwarekeys/hardwarekeys-Swift.h>
#import <objc/runtime.h>

@implementation HardwarekeysPlugin

    + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

        FLTStreamHandler* streamHandler = [[FLTStreamHandler alloc] init];
        FlutterEventChannel* channel = [FlutterEventChannel eventChannelWithName:@"github.caelana.hardwarekeys"
        binaryMessenger:[registrar messenger]];
        [channel setStreamHandler:streamHandler];

    }

@end

@implementation FLTStreamHandler
    - (FlutterError*) onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
        NSLog(@"Started log");
        eventSink(@"Started sink");

        self.homeKeyStreamHandler = [[FLTHomeKeyStreamHandler alloc] init];
        self.keyStreamHandler = [[FLTKeyStreamHandler alloc] init];

        [self.homeKeyStreamHandler onListen: eventSink];
        [self.keyStreamHandler onListen: eventSink];
        return nil;
    }

    - (FlutterError*)onCancelWithArguments:(id)arguments {
      [self.keyStreamHandler onCancel];
      [self.homeKeyStreamHandler onCancel];
      return nil;
    }

@end

@implementation FLTHomeKeyStreamHandler

  -(void) onHomePressed {
    self.eventSink(@"home");
  }
  
  - (FlutterError*) onListen:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;

    [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(onHomePressed)q
    name:UIApplicationWillResignActiveNotification 
    object:nil];

    return nil;
  }

  - (FlutterError*)onCancel{
    
    return nil;
  }
@end


@implementation FLTKeyStreamHandler
  - (FlutterError*) onListen: (FlutterEventSink)eventSink {
        self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
          eventSink(@"volume_up");
          NSLog(@"Volume_up");
        } downBlock:^{
          NSLog(@"Volume_down");          
          eventSink(@"volume_down");
        }];

        // Start
        [self.volumeButtonHandler startHandler:YES]; 
        NSLog(@"Volume Button Handler listening");
        eventSink(@"Volume Button Handler listening");
        return nil;
  }

  - (FlutterError*)onCancel{
    [self.volumeButtonHandler stopHandler];
    return nil;
  }
@end
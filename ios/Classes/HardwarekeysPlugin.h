#import <Flutter/Flutter.h>
#import "JPSVolumeButtonHandler.h"


@interface HardwarekeysPlugin : NSObject<FlutterPlugin>

@end

@interface FLTKeyStreamHandler : NSObject
@property (strong, nonatomic) JPSVolumeButtonHandler *volumeButtonHandler;
 - (void)onListen: (FlutterEventSink)eventSink;
 - (FlutterError*)onCancel;
@end

@interface FLTHomeKeyStreamHandler : NSObject
@property (strong, nonatomic) FlutterEventSink eventSink;
 - (void)onListen: (FlutterEventSink)eventSink;
 - (FlutterError*)onCancel;
@end

@interface FLTStreamHandler : NSObject <FlutterStreamHandler>
@property (strong, nonatomic) FLTKeyStreamHandler *keyStreamHandler;
@property (strong, nonatomic) FLTHomeKeyStreamHandler *homeKeyStreamHandler;
@property (strong, nonatomic) FlutterEventSink eventSink;
@end


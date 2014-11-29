#import <CoreMotion/CoreMotion.h>
@interface MTStopwatchControlsView : UIView
@end
@interface MTCircleButton : UIButton
  - (id)initWithSize:(unsigned long long)arg1;
  - (void)setColor:(unsigned long long)arg1 forState:(unsigned long long)arg2;
@end
@protocol StopWatchControlsTarget <NSObject>
- (void)startLapTimer;
- (void)pauseLapTimer;
@end

static MTCircleButton *sprintButton;
static MTStopwatchController *controller;
static BOOL timerOn;
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
static CMMotionManager *motionManager;
%hook MTStopwatchControlsView
  - (id)initWithTarget:(id)arg1 {
     self = %orig;
     if (self) {
      sprintButton = [(MTCircleButton *)[%c(MTCircleButton) alloc] initWithSize:1];
     }
    return self;
  }
  - (void)layoutSubviews {
	%orig;
	UIView *buttonsView;
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
	  buttonsView = self;
	}
	else {
	  buttonsView = MSHookIvar<UIView *>(self,"_buttonsBackgroundView");
	}
	float space = (DEVICE_WIDTH - 225)/4;
	sprintButton.frame = CGRectMake(space,21,75,75);
		
	[sprintButton setTitle:@"Ready" forState:UIControlStateHighlighted];
	[(MTCircleButton *)sprintButton setColor:2 forState:UIControlStateHighlighted];
	[sprintButton setTitle:@"Sprint" forState:UIControlStateNormal];
	[(MTCircleButton *)sprintButton setColor:4 forState:UIControlStateNormal];
	
	[sprintButton addTarget:self action:@selector(buttonHold) forControlEvents:UIControlEventTouchDown];
	[sprintButton addTarget:self action:@selector(buttonRelease) forControlEvents:UIControlEventTouchUpInside];
	[sprintButton addTarget:self action:@selector(buttonRelease) forControlEvents:UIControlEventTouchUpOutside];

	[buttonsView addSubview:sprintButton];
	
	controller = MSHookIvar<MTStopwatchController *>(self, "_controller");
		
	MTCircleButton *rightButton = MSHookIvar<MTCircleButton *>(controller, "_rightButton");
	MTCircleButton *leftButton = MSHookIvar<MTCircleButton *>(controller, "_leftButton");
		

	leftButton.frame = CGRectMake((2 * space) + 75,21,75,75);
	rightButton.frame = CGRectMake((2 * space) + 150,21,75,75);
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
	  sprintButton.frame = CGRectMake(space,204,75,75);
	  leftButton.frame = CGRectMake((2 * space) + 75,204,75,75);
	  rightButton.frame = CGRectMake((3 * space) + 150,204,75,75);
	}

   }
 %new
 - (void)buttonHold {
    id <StopWatchControlsTarget> target = MSHookIvar<id <StopWatchControlsTarget> >(controller,"_target");
    motionManager = [[CMMotionManager alloc] init];
    [motionManager setAccelerometerUpdateInterval:0.01];
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMAccelerometerData *data, NSError *error){

      if (data.acceleration.y > 1 && !timerOn) {

      if (data.acceleration.y > 1) {

	[target startLapTimer];
	[sprintButton setTitle:@"Release" forState:UIControlStateNormal];
	[(MTCircleButton *)sprintButton setColor:1 forState:UIControlStateNormal];
	[sprintButton setTitle:@"Release" forState:UIControlStateHighlighted];
	[(MTCircleButton *)sprintButton setColor:1 forState:UIControlStateHighlighted];
	timerOn = YES;
      }
    }];
 }
 %new
 - (void)buttonRelease {
    id <StopWatchControlsTarget> target = MSHookIvar<id <StopWatchControlsTarget> >(controller,"_target");
    if (timerOn){
      [target pauseLapTimer]; 
      [sprintButton setTitle:@"Ready" forState:UIControlStateHighlighted];
      [(MTCircleButton *)sprintButton setColor:2 forState:UIControlStateHighlighted];
      [sprintButton setTitle:@"Sprint" forState:UIControlStateNormal];
      [(MTCircleButton *)sprintButton setColor:4 forState:UIControlStateNormal];
     
      timerOn = NO;
    }
      [motionManager stopAccelerometerUpdates];
      [motionManager release];
      motionManager = nil;
 }
 - (void)dealloc {
    [sprintButton release];
    sprintButton = nil;
    
    %orig;
 }
%end

%hook MTCircleButton
  - (void)setColor:(unsigned long long)arg1 forState:(unsigned long long)arg2 {
    if (arg1 == 4) {
      [self setTitleColor:[UIColor orangeColor] forState:arg2];

      if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
	[self setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Applications/MobileTimer.app/circle_borderless.png"] forState:arg2];
      }
      else {
	[self setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Applications/MobileTimer.app/circle_orange.png"] forState:arg2];
      }

    }
    else {
      %orig;
    }
  }
%end
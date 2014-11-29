#import <Preferences/Preferences.h>
#import <Social/Social.h>

@interface sprinttimerprefsListController: PSListController {
}
@end

@implementation sprinttimerprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"sprinttimerprefs" target:self] retain];
	}
	return _specifiers;
}
- (id)navigationItem {
    UINavigationItem *item = [super navigationItem];
    UIButton *buttonTwitter = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTwitter setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/sprinttimerprefs.bundle/heart.png"] forState:UIControlStateNormal];
    buttonTwitter.frame = CGRectMake(0,0,35,35);
    UIBarButtonItem *heart = [[[UIBarButtonItem alloc] initWithCustomView:buttonTwitter] autorelease];
    [buttonTwitter addTarget:self action:@selector(tweeter) forControlEvents:UIControlEventTouchUpInside];
    item.rightBarButtonItem = heart;
    return item;
}
- (void)tweeter {
    SLComposeViewController *tweeter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweeter setInitialText:@"Check out Sprint Timer. A tweak by @broganminerdev which allows you to accurately self-time sprints."];
    [(UIViewController *)self presentViewController:tweeter animated:YES completion:nil];
}
- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=LFHXZJZWNJBWQ&lc=US&item_name=Brogan%20Miner&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"]];
}
- (void)viewSource {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.github.com/broha22/sprint-timer"]];

}
@end

// vim:ft=objc

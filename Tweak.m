#import <UIKit/UIKit.h>

// ====== غيّر هذي القيم ======
#define CHANNEL_URL   @"https://t.me/LuoXueModX"
#define CHANNEL_NAME  @"قناة المطور"
// ============================

static NSString *const kDoneKey = @"mydylib.channel.opened";
static UIWindow *gGate = nil;

@interface GateVC : UIViewController
@end

@implementation GateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];

    UILabel *title = [UILabel new];
    title.text = CHANNEL_NAME;
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:26];
    title.textAlignment = NSTextAlignmentCenter;

    UILabel *sub = [UILabel new];
    sub.text = @"لاستخدام التطبيق، افتح قناة المطور أولاً";
    sub.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    sub.font = [UIFont systemFontOfSize:15];
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 0;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"فتح القناة" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn.backgroundColor = [UIColor colorWithRed:0.16 green:0.62 blue:0.89 alpha:1.0];
    btn.layer.cornerRadius = 14;
    [btn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[title, sub, btn]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:32],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-32],
        [btn.heightAnchor constraintEqualToConstant:50],
    ]];
}

- (void)openChannel {
    NSURL *url = [NSURL URLWithString:CHANNEL_URL];
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL ok) {
        if (!ok) return;
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:kDoneKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            gGate.hidden = YES;
            gGate = nil;
        });
    }];
}

@end

static void ShowGateIfNeeded(void) {
    if (gGate) return;
    if ([NSUserDefaults.standardUserDefaults boolForKey:kDoneKey]) return;

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        if (scene.activationState != UISceneActivationStateForegroundActive) continue;

        gGate = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
        gGate.windowLevel = UIWindowLevelAlert + 100;
        gGate.rootViewController = [GateVC new];
        [gGate makeKeyAndVisible];
        return;
    }
}

__attribute__((constructor))
static void DylibInit(void) {
    [NSNotificationCenter.defaultCenter
        addObserverForName:UIApplicationDidBecomeActiveNotification
                    object:nil
                     queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *n) { ShowGateIfNeeded(); }];
}

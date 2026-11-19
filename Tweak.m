#import <UIKit/UIKit.h>

// نافذة التطبيق الرئيسية
static UIWindow *KeyWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) {
            if (w.isKeyWindow) return w;
        }
    }
    return nil;
}

static void ShowAlert(NSString *title, NSString *message) {
    UIViewController *vc = KeyWindow().rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    if (!vc) return;
    UIAlertController *a = [UIAlertController alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [vc presentViewController:a animated:YES completion:nil];
}

// يشتغل تلقائياً عند تحميل الدايلب
__attribute__((constructor))
static void DylibInit(void) {
    NSLog(@"[MyDylib] loaded");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        ShowAlert(@"MyDylib", @"تم تحميل الدايلب بنجاح");
    });
}

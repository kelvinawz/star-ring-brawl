#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface GameDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@end

@implementation GameDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSURL *resources = [[NSBundle mainBundle] resourceURL];
    NSURL *game = [resources URLByAppendingPathComponent:@"index.html"];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:NSMakeRect(0, 0, 1180, 780)];
    [webView loadFileURL:game allowingReadAccessToURL:resources];

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:NSMakeRect(0, 0, 1180, 780)
        styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                   NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable)
        backing:NSBackingStoreBuffered defer:NO];
    window.title = @"星环乱斗";
    window.minSize = NSMakeSize(820, 580);
    window.contentView = webView;
    [window center];
    [window makeKeyAndOrderFront:nil];
    [window makeFirstResponder:webView];
    [NSApp activateIgnoringOtherApps:YES];
    self.window = window;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}
@end

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        GameDelegate *delegate = [GameDelegate new];
        app.delegate = delegate;
        [app setActivationPolicy:NSApplicationActivationPolicyRegular];
        [app run];
    }
    return 0;
}

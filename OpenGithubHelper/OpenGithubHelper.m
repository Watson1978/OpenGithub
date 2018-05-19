#import "OpenGithubHelper.h"

@implementation OpenGithubHelper

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)open: (void (^)(void))completion {
    NSString *dir = [[NSBundle mainBundle] resourcePath];
    NSString *scriptPath = [NSString stringWithFormat:@"%@/open_xcode_file_on_github.rb", dir];

    NSTask *task  = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/ruby";
    task.arguments = @[scriptPath];
    [task launch];

    completion();
}

@end

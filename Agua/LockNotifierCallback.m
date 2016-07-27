//
//  LockNotifierCallback.m
//  Agua
//
//  Created by Edgar Trujillo on 4/18/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LockNotifierCallback.h"
BOOL screen;

static void displayStatusChanged(CFNotificationCenterRef center,
                                 void *observer,
                                 CFStringRef name,
                                 const void *object,
                                 CFDictionaryRef userInfo) {
    
    if ([(__bridge NSString *)name  isEqual: @"com.apple.springboard.lockcomplete"]) {
     //   NSLog(@"Screen is Locked");
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"kDisplayStatusLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@implementation LockNotifierCallback

+ (void(*)(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo))notifierProc {
    return displayStatusChanged;
    }

@end

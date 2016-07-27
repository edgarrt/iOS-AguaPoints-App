//
//  LockNotifierCallback.h
//  Agua
//
//  Created by Edgar Trujillo on 4/18/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

#ifndef LockNotifierCallback_h
#define LockNotifierCallback_h




@interface LockNotifierCallback : NSObject


+ (void(*)(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo))notifierProc;


@end




#endif /* LockNotifierCallback_h */



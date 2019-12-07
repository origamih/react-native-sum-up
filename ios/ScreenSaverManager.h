//
//  ScreenSaverManager.h
//  SumUp
//
//  Created by huy tran on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// #import <SumUpSDK/SumUpSDK.h>
@interface ScreenSaverManager : NSObject
@property (nonatomic, strong) UIViewController *mainView;
+ (id)sharedManager;
+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc ;
+ (void)showModal;
@end


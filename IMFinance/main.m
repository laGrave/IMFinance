//
//  main.m
//  IMFinance
//
//  Created by Igor Mishchenko on 28.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMAppDelegate.h"

#import <ABCalendarPicker/ABCalendarPicker.h>

int main(int argc, char *argv[])
{
    [ABCalendarPicker class];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([IMAppDelegate class]));
    }
}

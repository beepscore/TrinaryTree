//
//  TrinaryTreeAppDelegate.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrinaryTreeViewController;

@interface TrinaryTreeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TrinaryTreeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TrinaryTreeViewController *viewController;

@end


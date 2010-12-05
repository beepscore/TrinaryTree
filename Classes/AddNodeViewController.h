//
//  AddNodeViewController.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNodeViewControllerDelegate <NSObject>
- (void)addNodeViewControllerDidRequestDismissView;
@end

@interface AddNodeViewController : UIViewController <UITextFieldDelegate>
{
    // protected is default
@protected
    id<AddNodeViewControllerDelegate> delegate;
    
}

@property (nonatomic, assign) id<AddNodeViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UITextField *nodeContentTextField;
@property (nonatomic, retain) NSNumber *nodeContent;

@end

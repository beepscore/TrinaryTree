//
//  AddNodeViewController.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrinaryTree;


@protocol AddNodeViewControllerDelegate <NSObject>
- (void)addNodeViewControllerDidRequestDismissView;
@end

@interface AddNodeViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<AddNodeViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *nodeContentTextField;
@property (nonatomic, strong) NSNumber *nodeContent;
@property (nonatomic, strong) TrinaryTree *trinaryTree;

@end

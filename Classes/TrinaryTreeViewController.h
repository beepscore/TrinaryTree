//
//  TrinaryTreeViewController.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
// import AddNodeViewController.h to see the AddNodeViewControllerDelegate protocol declaration
#import "AddNodeViewController.h"
#import "TrinaryTree.h"
@class Node;

@interface TrinaryTreeViewController : UIViewController 
<AddNodeViewControllerDelegate, TrinaryTreeDelegate> 
{

}
@property (nonatomic, retain) TrinaryTree *trinaryTree;


@end


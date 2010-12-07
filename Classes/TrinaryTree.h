//
//  TrinaryTree.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Node;

@protocol TrinaryTreeDelegate <NSObject>
- (void)trinaryTreeDidInsertNode:(Node *)aNode;
@end

@interface TrinaryTree : NSObject
{
    id<TrinaryTreeDelegate> delegate;
}
@property (nonatomic, assign) id<TrinaryTreeDelegate> delegate;

@property (nonatomic, retain) NSMutableSet *nodes;
@property (nonatomic, retain) Node *rootNode;

- (void)insertNode:(Node *)aNode;

- (void)listNodes;

@end

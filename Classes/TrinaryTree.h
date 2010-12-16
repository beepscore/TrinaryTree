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
- (void)trinaryTreeWillDeleteNode:(Node *)aNode;
@end

@interface TrinaryTree : NSObject
{
    id<TrinaryTreeDelegate> delegate;
}
@property (nonatomic, assign) id<TrinaryTreeDelegate> delegate;

@property (nonatomic, retain) NSMutableSet *nodes;
@property (nonatomic, retain) Node *rootNode;

@property (nonatomic, retain) Node *leftOrphanNode;
@property (nonatomic, retain) Node *middleOrphanNode;
@property (nonatomic, retain) Node *rightOrphanNode;

- (void)listTreeBranchStartingAtNode:(Node *)aNode;
- (void)insertNode:(Node *)aNode;
- (void)deleteNode:(Node *)aNode;

@end

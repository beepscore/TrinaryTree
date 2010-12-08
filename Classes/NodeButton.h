//
//  NodeButton.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/8/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Node;

@interface NodeButton : NSObject {

}
@property (nonatomic, retain) Node *node;
@property (nonatomic, retain) UIButton *button;

- (id)initWithNode:(Node *)aNode atPointValue:(NSValue *)aPointValue;
- (void)buttonTapped;

@end

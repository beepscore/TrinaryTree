//
//  Node.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "Node.h"


@implementation Node

- (void)dealloc
{
    // don't retain parent node, don't release it
    self.parentNode = nil;
}

@end

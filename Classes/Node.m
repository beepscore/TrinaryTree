//
//  Node.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "Node.h"


@implementation Node

@synthesize nodeContent;
@synthesize parentNode, leftNode, middleNode, rightNode;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc
{
    [nodeContent release];
    [parentNode release];
    [leftNode release];
    [middleNode release];
    [rightNode release];
    
    [super dealloc];
}


@end

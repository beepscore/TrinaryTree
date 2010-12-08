//
//  NodeButton.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/8/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "NodeButton.h"
#import "Node.h"

@implementation NodeButton

@synthesize node, button;

- (id)initWithNode:(Node *)aNode atPointValue:(NSValue *)aPointValue
{
    self = [super init];
    if (self)
    {
    self.node = aNode;
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.button addTarget:self 
                    action:@selector(buttonTapped)
          forControlEvents:UIControlEventTouchUpInside];
    
    NSString *aNodeButtonTitle = [NSString stringWithFormat:@"%i", self.node.nodeContent.intValue];
    [self.button setTitle:aNodeButtonTitle forState:UIControlStateNormal];
    
    float buttonHeight = 30.0;
    float buttonWidth = 30.0;    
    
    self.button.frame = CGRectMake(aPointValue.CGPointValue.x - (buttonWidth / 2.0),
                                   aPointValue.CGPointValue.y - (buttonHeight / 2.0),
                                   buttonWidth,
                                   buttonHeight);
    }
    return self;
}


- (void)dealloc
{
    [node release];
    [button release];
    
    [super dealloc];
}

- (void)buttonTapped
{
    // Handle nodeButton tapped
    NSLog(@"Hi from node %@!", node.nodeContent);
}


@end

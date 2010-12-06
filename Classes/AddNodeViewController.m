//
//  AddNodeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "AddNodeViewController.h"
#import "Node.h"

@interface AddNodeViewController ()
- (void)dismissView;
- (void)handleTappedDone;
- (void)insertNewNode:(NSNumber *)aNodeContent;
@end

@implementation AddNodeViewController

@synthesize delegate;
@synthesize nodeContentTextField;
@synthesize nodeContent;


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *nodesButton = [[UIBarButtonItem alloc] 
                                    initWithTitle:NSLocalizedString(@"Nodes", @"")
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(dismissView)];
    
    self.navigationItem.leftBarButtonItem = nodesButton;
    [nodesButton release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(handleTappedDone)] autorelease];
    
    // make the text field first responder, which calls up the keyboard
    [[self nodeContentTextField] becomeFirstResponder];
}


// method signature without parameter can be called with a simple selector,
// for use by a UIBarButtonItem
- (void)dismissView
{
    // Call the delegate to dismiss the view
    [self.delegate addNodeViewControllerDidRequestDismissView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.nodeContentTextField = nil;
}


#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning
{    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc
{     
    [nodeContentTextField release];
    [nodeContent release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)aTextField
{
    NSLog(@"%@", @"in textFieldDidEndEditing");
}


- (void)handleTappedDone
{        
    if ((nil == self.nodeContentTextField.text) || [self.nodeContentTextField.text isEqualToString:@""] )
    {
        [self dismissView];
    } else {
        
        // Use a number formatter on string to handle localization and user prefs
        // ref http://stackoverflow.com/questions/169925/how-to-do-string-conversions-in-objective-c
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        // formatter numberFromString: is not a class convenience method (aka factory method).
        NSNumber *cleanedNodeNumber = [formatter numberFromString:self.nodeContentTextField.text];
        [formatter release];
        
        [self insertNewNode:cleanedNodeNumber];
        [self dismissView];
    }
}


#pragma mark -
#pragma mark Add a new object
- (void)insertNewNode:(NSNumber *)aNodeContent
{    
    //Node *newNode = [[Node alloc] init];
    //newNode.nodeContent = aNodeContent;
    // TODO: FIXME memory leak return autoreleased node to trinarytree?
    // add node to a model of trinary tree?  Node needs to walk tree to find place and set it's parent.
    
}

@end

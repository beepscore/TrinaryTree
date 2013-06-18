//
//  AddNodeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "AddNodeViewController.h"
#import "Node.h"
#import "TrinaryTree.h"

@implementation AddNodeViewController

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // make the text field first responder, which calls up the keyboard
    [[self nodeContentTextField] becomeFirstResponder];
}


- (IBAction)dismissView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)aTextField
{
    // NSLog(@"%@", @"in textFieldDidEndEditing");
}


- (IBAction)handleTappedDone:(id)sender
{        
    if ((nil == self.nodeContentTextField.text) || [self.nodeContentTextField.text isEqualToString:@""] )
    {
        [self dismissView:self];
    } else {
        
        // Use a number formatter on string to handle localization and user prefs
        // ref http://stackoverflow.com/questions/169925/how-to-do-string-conversions-in-objective-c
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        // formatter numberFromString: is not a class convenience method (aka factory method).
        NSNumber *cleanedNodeNumber = [formatter numberFromString:self.nodeContentTextField.text];
        
        [self insertNodeWithContent:cleanedNodeNumber];
        [self dismissView:self];
    }
}

#pragma mark - Add a new object
- (void)insertNodeWithContent:(NSNumber *)aNodeContent
{    
    Node *newNode = [[Node alloc] init];
    newNode.nodeContent = aNodeContent;

    [self.trinaryTree insertNode:newNode];
}

@end

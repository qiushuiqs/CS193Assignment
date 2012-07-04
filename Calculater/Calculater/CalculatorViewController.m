//
//  CalculatorViewController.m
//  Calculater
//
//  Created by Mark Xiong on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userInTheMiddleOfEnterANumber;
@property (nonatomic, strong) CalculatorBrain* brain; 
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize description = _description;
@synthesize userInTheMiddleOfEnterANumber = _userInTheMiddleOfEnterANumber;
@synthesize brain = _brain;


-(CalculatorBrain *)brain{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return  _brain;
}


- (IBAction)digitPressed:(UIButton*)sender {   //IBAction == void,  id is point to any object
    NSString *digit = [sender currentTitle];

    if (self.userInTheMiddleOfEnterANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }else {
        self.display.text = digit;
        self.userInTheMiddleOfEnterANumber = YES;
    }

}


- (IBAction)operatorPressed:(UIButton*)sender {
    if (self.userInTheMiddleOfEnterANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result]; //double to string
    self.display.text = resultString;
    self.description.text = [self.brain showTheDescription];
}

- (IBAction)enterPressed {
    if(!([self.display.text doubleValue]||[self.display.text isEqualToString:@"π"])){
        NSLog(@"it is a string");
        [self.brain pushVariable:self.display.text];
    
    }else{
        if([self.display.text isEqualToString:@"π"]) {
           // self.display.text = @"3.14" ;
            double pi = M_PI;
            [self.brain pushOperand:pi]; 
        }
        NSLog(@"pi %@", self.display.text);
        [self.brain pushOperand:[self.display.text doubleValue]];     //string to double
    }
    
    self.description.text = [self.brain showTheDescription];
    self.userInTheMiddleOfEnterANumber = NO;
}

- (IBAction)undoPressed {
    if (self.userInTheMiddleOfEnterANumber && self.display.text.length>0) {
        self.display.text = [self.display.text substringToIndex:(self.display.text.length-1)];
    }else {
        self.description.text = [self.brain removeLastOperand];
        self.display.text =@"0";
    }

}


@end

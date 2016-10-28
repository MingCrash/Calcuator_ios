//
//  ViewController.h
//  Calculator_ios
//
//  Created by 朱志明 on 16/5/22.
//  Copyright © 2016年 朱志明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculateKernel.h"

@interface ViewController : UIViewController{
@private
BOOL IsUserTypeTheOperand;
long operatedValue;
NSMutableArray *stack_formakevalue;
CalculateKernel *delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *resultdisplay;
- (IBAction)operandpress:(UIButton *)sender;
- (IBAction)operationpress:(UIButton *)sender;
- (IBAction)reset:(id)sender;
- (IBAction)equal:(id)sender;

@end


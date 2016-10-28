//
//  ViewController.m
//  Calculator_ios
//
//  Created by 朱志明 on 16/5/22.
//  Copyright © 2016年 朱志明. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    @autoreleasepool {
        stack_formakevalue =[NSMutableArray arrayWithCapacity:42];
        delegate =[[CalculateKernel alloc]init_createDicAndAry];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 输入的是一个操作数就压入栈中，不返回任何都系出去
 输入一个操作符就将栈中的都数弹出来，合并并返回一个成型的数
 */
- (NSString *) makevalue:(NSNumber *)singlenum isTypeOperand:(BOOL)isTypeOperand{
    if (isTypeOperand) {
        [stack_formakevalue addObject:singlenum];
        return nil;
    }else {
        NSInteger digitalplace = 1,result = 0;
        //        for (NSNumber *element in stack_formakevalue){
        //            [element intValue];
        //        }
        
        for(NSInteger i=[stack_formakevalue count]-1;i>=0;i--){
            result=result+[[stack_formakevalue objectAtIndex:i]intValue]*digitalplace;
            [stack_formakevalue removeObjectAtIndex:i];
            digitalplace = digitalplace*10;
        }
        return [NSString stringWithFormat:@"%ld",(long)result];
    }
}

/*
 1.set IsUserTypeTheoperand status as YES
 2.send the operand to makevuale
 3.disply the operand on label
 */
- (IBAction)operandpress:(UIButton *)sender {
    IsUserTypeTheOperand = YES;
    
    int tmp = [sender.titleLabel.text intValue];
    [self makevalue:[NSNumber numberWithInt:tmp] isTypeOperand:IsUserTypeTheOperand];
    
    /*拼接以前的字段，连贯显示数字*/
    _resultdisplay.text = [_resultdisplay.text stringByAppendingString:sender.titleLabel.text];
    
    
}

/*
 1.set IsUserTypeTheoperand status as NO
 2.display the result coherently by appending string
 3.call the makevalue method get the operated value
 */
- (IBAction)operationpress:(UIButton *)sender {
    IsUserTypeTheOperand = NO;
    
    _resultdisplay.text = [_resultdisplay.text stringByAppendingString:sender.titleLabel.text];
    
    NSString *value =[self makevalue:nil isTypeOperand:IsUserTypeTheOperand];
    //先传入生成数的字符串，让其处理
    if ([value intValue] !=0) {
        [delegate opposite_Poland:value isNumber:YES];
    }
    
    //再传按键传入的操作符，因为操作符的效力范围包含住操作数
    [delegate opposite_Poland:sender.titleLabel.text isNumber:IsUserTypeTheOperand];
}
/*
 1.判断stack_formakevalue为空，否则清空stack_formakevalue
 2.判断_OppositePolandStack_S1为空，否则清空_OppositePolandStack_S1
 3.判断_OperationStack_S2为空，否则清空_OperationStack_S2
 4.判断_calcuateStack为空，否则清空_calcuateStack
 5.清空屏幕字段
 */
- (IBAction)reset:(id)sender {
    if ([stack_formakevalue count]!=0) {
        [stack_formakevalue removeAllObjects];
    }
    if ([delegate.OppositePolandStack_S1 count]!=0) {
        [delegate.OppositePolandStack_S1 removeAllObjects];
    }
    if ([delegate.OperationStack_S2 count]!=0) {
        [delegate.OperationStack_S2 removeAllObjects];
    }
    if ([delegate.calcuateStack count]!=0) {
        [delegate.calcuateStack removeAllObjects];
    }
    _resultdisplay.text=@"";
}

/*
 1.判断stack_formakevalue是为空，否则将最后一组操作符弹出形成数，传入opposite_Poland
 2.判断栈S2中仍然存在运算符，那么将这些运算符依次出栈加入到栈S1中，直到栈为空
 3.调用oppositePolandCalculate，计算逆波兰数式
 */
- (IBAction)equal:(id)sender {
    if ([delegate isStackNull:stack_formakevalue]) {
        if ([delegate isStackS2Null]) {
            _resultdisplay.text =[NSString stringWithFormat:@"%f",[delegate oppositePolandCalculate:delegate.OppositePolandStack_S1]];
        }else{
            for (NSInteger i=[delegate.OperationStack_S2 count]-1; i>=0; i--) {
                [delegate.OppositePolandStack_S1 addObject:[delegate.OperationStack_S2 objectAtIndex:i]];
                [delegate.OperationStack_S2 removeObjectAtIndex:i];
            }
            _resultdisplay.text =[NSString stringWithFormat:@"%f",[delegate oppositePolandCalculate:delegate.OppositePolandStack_S1]];
        }
    }else{
        [delegate opposite_Poland:[self makevalue:nil isTypeOperand:NO] isNumber:YES];
        if ([delegate isStackS2Null]) {
            [delegate oppositePolandCalculate:delegate.OppositePolandStack_S1];
        }else{
            for (NSInteger i=[delegate.OperationStack_S2 count]-1; i>=0; i--) {
                [delegate.OppositePolandStack_S1 addObject:[delegate.OperationStack_S2 objectAtIndex:i]];
                [delegate.OperationStack_S2 removeObjectAtIndex:i];
            }
            _resultdisplay.text =[NSString stringWithFormat:@"%f",[delegate oppositePolandCalculate:delegate.OppositePolandStack_S1]];
        }
    }
}
@end



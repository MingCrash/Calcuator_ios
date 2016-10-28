//
//  CalculateKernel.m
//  Calculator_ios
//
//  Created by 朱志明 on 16/5/26.
//  Copyright © 2016年 朱志明. All rights reserved.
//

#import "CalculateKernel.h"

@implementation CalculateKernel

-(id)init_createDicAndAry{
    self = [super init];
    if (nil != self) {
        _OppositePolandStack_S1 =[NSMutableArray arrayWithCapacity:42];
        _OperationStack_S2 =[NSMutableArray arrayWithCapacity:42];
        _calcuateStack =[NSMutableArray arrayWithCapacity:42];
        _PriorityMap =@{@"(":@"0",@"+":@"1",@"-":@"1",@"/":@"2",@"*":@"2",@")":@"3"};
    }
    return self;
}

-(BOOL) isStackNull:(NSMutableArray *)stack{
    if ([stack count]==0) {
        return YES;
    }
    return NO;
}

-(BOOL) isStackS2Null{
    if ([_OperationStack_S2 count]==0) {
        return YES;
    }
    return NO;
}

-(NSInteger) getPriority:(NSString *)operation{
    return [[_PriorityMap objectForKey:operation] integerValue];
}
/*
（1）如果遇到的是数字，我们直接加入到栈S1中.
（2）如果遇到的是左括号，则直接将该左括号加入到栈S2中.
（3）如果遇到的是右括号，那么将栈S2中的运算符一次出栈加入到栈S1中，直到遇到左括号，但是该左括号出栈S2并不加入到栈S1中.
（4）如果遇到的是运算符，包括单目运算符和双目运算符，我们按照下面的规则进行操作：
      （1）如果此时栈S2为空，则直接将运算符加入到栈S2中；
      （2）如果此时栈S2不为空，当前遍历的运算符的优先级大于等于栈顶运算符的优先级，那么直接入栈S2
      （3）如果此时栈S2不为空，当前遍历的运算符的优先级小于栈顶运算符的优先级，则将栈顶运算符一直出栈加入到栈S1中，直到栈为空或者遇到一个运算符的优先级小于等于当前遍历的运算符的优先级，此时将该运算符加入到栈S2中；
（5）直到遍历完整个中序表达式之后，栈S2中仍然存在运算符，那么将这些运算符依次出栈加入到栈S1中，直到栈为空。
*/
-(NSMutableArray *)opposite_Poland:(NSString *)input isNumber:(BOOL)isNumber{
    if (isNumber) {
        [_OppositePolandStack_S1 addObject:input];
         NSLog(@"遇到的是数字%@",input);
    }else{
        if([input isEqualToString:@"("]){
            [_OperationStack_S2 addObject:input];
             NSLog(@"遇到的是左括号");
            //return expression
        }else if ([input isEqualToString:@")"]){
            NSLog(@"遇到的是右括号");
            for (NSInteger i=[_OperationStack_S2 count]-1; i>=0; i--) {
            if ([[_OperationStack_S2 objectAtIndex:i]isEqualToString:@"("]) {
                [_OperationStack_S2 removeObjectAtIndex:i];
                        break;}
                [_OppositePolandStack_S1 addObject:[_OperationStack_S2 objectAtIndex:i]];
                [_OperationStack_S2 removeObjectAtIndex:i];
                }
        }else{
            if ([_OperationStack_S2 count]==0) {
                [_OperationStack_S2 addObject:input];
                NSLog(@"栈S2为空，被插入%@",input);
            }else{
                if ([self getPriority:input]>=[self getPriority:[_OperationStack_S2 objectAtIndex:[_OperationStack_S2 count]-1]]) {
                    [_OperationStack_S2 addObject:input];
                    NSLog(@"栈S2不为空，当前遍历的运算符的优先级%ld大于等于栈顶运算符的优先级",(long)[self getPriority:input]);
                }else{
                    for (NSInteger i =[_OperationStack_S2 count]-1; i>=0; i--) {
                        if ([self getPriority:input]>=[self getPriority:[_OperationStack_S2 objectAtIndex:i]] || [_OperationStack_S2 count]==0) {
                            [_OppositePolandStack_S1 addObject:input];
                            return _OppositePolandStack_S1;
                            }
                            [_OppositePolandStack_S1 addObject:[_OperationStack_S2 objectAtIndex:i]];
                            [_OperationStack_S2 removeObjectAtIndex:i];
                            NSLog(@"栈S2不为空，当前遍历的运算符的优先级%ld小于栈顶运算符的优先级",(long)[self getPriority:input]);
                            }
                    [_OperationStack_S2 addObject:input];
                        }
                    }
                }
    }
    NSLog(@"%@",[_OppositePolandStack_S1 componentsJoinedByString:@""]);
    return _OppositePolandStack_S1;
}
/*
 1.遇到操作数，将其压入栈中
 2.遇到操作符，将栈中的栈顶头两个操作符弹出，按操作符规则计算，计算完毕后将结果重新压回栈中
 3.检测输入的算式存在元素，否则将栈低元素弹出，输出显示
 */
-(double) oppositePolandCalculate:(NSMutableArray *)oppositePolandExpress{
     NSLog(@"%@",[oppositePolandExpress componentsJoinedByString:@""]);
    double reslut =0;
    NSInteger lenght =[oppositePolandExpress count];
    
    for (NSString* element in oppositePolandExpress) {
        if (lenght==0) {
            reslut =[[_calcuateStack objectAtIndex:0] doubleValue];
            break;
        }
        
        if ([element isEqualToString:@"+"]) {
            reslut =[[_calcuateStack objectAtIndex:[_calcuateStack count]-1] doubleValue]+[[_calcuateStack objectAtIndex:[_calcuateStack count]-2] doubleValue];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack addObject:[NSNumber numberWithDouble:reslut]];
            lenght--;
        }else if ([element isEqualToString:@"-"]){
            reslut =[[_calcuateStack objectAtIndex:[_calcuateStack count]-2] doubleValue]-[[_calcuateStack objectAtIndex:[_calcuateStack count]-1] doubleValue];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack addObject:[NSNumber numberWithDouble:reslut]];
            lenght--;
        }else if ([element isEqualToString:@"*"]){
            reslut =[[_calcuateStack objectAtIndex:[_calcuateStack count]-2] doubleValue]*[[_calcuateStack objectAtIndex:[_calcuateStack count]-1] doubleValue];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack addObject:[NSNumber numberWithDouble:reslut]];
            lenght--;
        }else if ([element isEqualToString:@"/"]){
            reslut =[[_calcuateStack objectAtIndex:[_calcuateStack count]-2] doubleValue]/[[_calcuateStack objectAtIndex:[_calcuateStack count]-1] doubleValue];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack removeObjectAtIndex:[_calcuateStack count]-1];
            [_calcuateStack addObject:[NSNumber numberWithDouble:reslut]];
            lenght--;
        }else{
            [_calcuateStack addObject:element];
            lenght--;
        }
    }
    return reslut;
}

@end


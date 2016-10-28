//
//  CalculateKernel.h
//  Calculator_ios
//
//  Created by 朱志明 on 16/5/26.
//  Copyright © 2016年 朱志明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateKernel : NSObject

@property NSMutableArray *OppositePolandStack_S1;
@property NSMutableArray *OperationStack_S2;
@property NSMutableArray *calcuateStack;
@property NSDictionary *PriorityMap;

-(NSMutableArray *) opposite_Poland:(NSString *)input isNumber:(BOOL)isNumber;
-(double) oppositePolandCalculate:(NSMutableArray *)oppositePolandExpress;
-(BOOL) isStackNull:(NSMutableArray *)stack;
-(BOOL) isStackS2Null;
-(id)init_createDicAndAry;
@end
     
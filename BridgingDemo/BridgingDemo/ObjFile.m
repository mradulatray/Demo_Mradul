//
//  ObjFile.m
//  BridgingDemo
//
//  Created by mradulatray on 31/03/23.
//

#import "ObjFile.h"
#import "BridgingDemo-Swift.h"


@implementation ObjFile

-(void)callingMethod {
    NSLog(@"ye function objective c me likha hua he");
    DemoClass *obj = [DemoClass new];
    [obj demoClassFunction];
}
@end

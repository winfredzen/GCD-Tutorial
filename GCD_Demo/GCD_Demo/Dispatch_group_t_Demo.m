//
//  Dispatch_group_t_Demo.m
//  GCD_Demo
//
//  Created by wangzhen on 17/6/12.
//  Copyright © 2017年 whrarest. All rights reserved.
//

#import "Dispatch_group_t_Demo.h"

@interface Dispatch_group_t_Demo ()

@end

@implementation Dispatch_group_t_Demo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_queue_t queue =  dispatch_queue_create("com.wz", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
    dispatch_group_async(group, queue, ^{NSLog(@"blk1");});
    dispatch_group_async(group, queue, ^{NSLog(@"blk2");});
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

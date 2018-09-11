//
//  TTDrawViewController.m
//  TouchTracker
//
//  Created by 吕晴阳 on 2018/9/10.
//  Copyright © 2018年 Lv Qingyang. All rights reserved.
//

#import "TTDrawViewController.h"
#import "TTDrawView.h"

@interface TTDrawViewController ()

@end

@implementation TTDrawViewController

- (void)loadView {
    self.view = [[TTDrawView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

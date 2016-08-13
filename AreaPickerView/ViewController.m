//
//  ViewController.m
//  AreaPickerView
//
//  Created by boleketang on 16/8/11.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import "ViewController.h"
#import "AreaPickerView.h"

@interface ViewController ()<AreaPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AreaPickerView *areaPicker = [[AreaPickerView alloc] initWithDelegate:self title:@"城市选择器"];
    [areaPicker pickerViewSelectRow:5 inComponent:0];
    [areaPicker pickerViewSelectAtAreaCode:@12188];
    [areaPicker showInView:self.view];
    
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

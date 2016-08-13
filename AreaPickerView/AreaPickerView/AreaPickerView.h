//
//  AreaPickerView.h
//  AreaPickerView
//
//  Created by zhuochenming on 16-3-11.
//  Copyright (c) 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaLocation : NSObject

@property (strong, nonatomic) NSString *province;

@property (strong, nonatomic) NSString *city;

@property (strong, nonatomic) NSString *area;

@end


@class AreaPickerView;
@protocol AreaPickerDelegate <NSObject>

@optional

- (void)pickerDidChaneStatus:(AreaPickerView *)picker;

- (void)pickerViewSelectAreaOfCode:(NSNumber *)code;

@end

@interface AreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <AreaPickerDelegate> delegate;

//可以返回当前选择的区域
@property (strong, nonatomic) AreaLocation *locate;

//初始化，默认frame在底部，包含toolbar，不要再设置frame
- (id)initWithDelegate:(id <AreaPickerDelegate>)delegate title:(NSString *)title;

//展示
- (void)showInView:(UIView *)view;

- (void)pickerViewSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)pickerViewSelectAtAreaCode:(NSNumber *)areaCode;

@end

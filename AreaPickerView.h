//
//  AreaPickerView.h
//  AreaPickerView
//
//  Created by zhuochenming on 16-3-11.
//  Copyright (c) 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaLocation.h"

@class AreaPickerView;

@protocol AreaPickerDelegate <NSObject>

@optional

- (void)pickerDidChaneStatus:(AreaPickerView *)picker;

- (void)pickerViewSelectAreaOfCode:(NSNumber *)code;

@end

@interface AreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <AreaPickerDelegate> delegate;

//@property (strong, nonatomic) UIPickerView *locatePicker;

@property (strong, nonatomic) AreaLocation *locate;

- (id)initWithDelegate:(id <AreaPickerDelegate>)delegate;

- (void)showInView:(UIView *)view;

//- (void)cancelPicker;

@end

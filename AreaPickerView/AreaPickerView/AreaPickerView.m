//
//  AreaPickerView.m
//  AreaPickerView
//
//  Created by zhuochenming on 16-3-11.
//  Copyright (c) 2016年 zhuochenming. All rights reserved.
//

#import "AreaPickerView.h"

static CGFloat const TopToobarHeight = 40;

@implementation AreaLocation

@end

@interface AreaPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) UIPickerView *pickerView;

//省份数组
@property (nonatomic, strong) NSArray *provinces;

//城市数组
@property (nonatomic, strong) NSArray *cities;

//地区数组
@property (nonatomic, strong) NSMutableArray *areas;

//区域ID数组
@property (nonatomic, strong) NSMutableArray *codeArray;

//区域ID
@property (nonatomic, strong) NSNumber *areaID;

@end

@implementation AreaPickerView

- (AreaLocation *)locate {
    if (_locate == nil) {
        _locate = [[AreaLocation alloc] init];
    }
    return _locate;
}

#pragma mark - 初始化
- (id)initWithDelegate:(id <AreaPickerDelegate>)delegate title:(NSString *)title {
    self = [super init];
    
    if (self) {
        //加载数据
        self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"areaCode.plist" ofType:nil]];
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"city"];
        self.areas = [NSMutableArray array];
        self.codeArray = [NSMutableArray array];
        
        NSDictionary *areaDic = [[self.cities objectAtIndex:0] objectForKey:@"area"];
        
        for (NSDictionary *nameDic in areaDic) {
            [self.areas addObject:nameDic[@"name"]];
            [self.codeArray addObject:nameDic[@"id"]];
        }
        
        self.locate.province = [[self.provinces objectAtIndex:0] objectForKey:@"name"];
        self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"name"];
        if (self.areas.count > 0) {
            self.locate.area = [self.areas objectAtIndex:0];
            self.areaID = [self.codeArray objectAtIndex:0];
        } else {
            self.locate.area = @"";
        }
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat kWidth = CGRectGetWidth([UIScreen mainScreen].bounds);

        UIPickerView *locatePicker = [[UIPickerView alloc] init];
        
        CGRect pickerFrame = locatePicker.frame;
        pickerFrame.origin.y = TopToobarHeight;
        pickerFrame.size.width = kWidth;
        locatePicker.frame = pickerFrame;
        
        locatePicker.backgroundColor = [UIColor whiteColor];
        locatePicker.dataSource = self;
        locatePicker.delegate = self;
        [self addSubview:locatePicker];
        _pickerView = locatePicker;
        
        [self createSubViewWithTitle:title];
        //代理
        self.delegate = delegate;
    }
    return self;
}

- (void)createSubViewWithTitle:(NSString *)title {
    CGFloat height = CGRectGetHeight(_pickerView.frame) + TopToobarHeight;
    CGFloat top = CGRectGetHeight([UIScreen mainScreen].bounds) - height;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, top, width, height);
    
    CGFloat buttonWidth = 50;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15, 0, buttonWidth, TopToobarHeight);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:75 / 255.0 green:137 / 255.0 blue:220 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftButton];
    
    CGFloat left = (CGRectGetWidth(self.frame) - 150) / 2.0;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 150, TopToobarHeight)];
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:lable];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 15 - TopToobarHeight, 0, buttonWidth, TopToobarHeight);
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:75 / 255.0 green:137 / 255.0 blue:220 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:rightButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TopToobarHeight - 0.5, width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

#pragma mark - pickerView代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [self.provinces count];
            break;
        case 1:
            return [self.cities count];
            break;
        case 2:
            return [self.areas count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [[self.provinces objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [[self.cities objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if ([self.areas count] > 0) {
                self.areaID = [self.codeArray objectAtIndex:row];
                return [self.areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}

#pragma mark - 定制
- (void)pickerViewSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.pickerView selectRow:row inComponent:component animated:YES];
    [self.pickerView reloadComponent:component];
}

- (void)pickerViewSelectAtAreaCode:(NSNumber *)areaCode {
    
    NSInteger a = 0, b = 0, c = 0;
    
    
    for (int i = 0; i < _provinces.count; i++) {
        NSDictionary *cityDic = _provinces[i];
        NSArray *cityArray = cityDic[@"city"];
        for (int j = 0; j < cityArray.count; j++) {
            
            NSDictionary *areaDic = cityArray[i];
            NSArray *areaArray = areaDic[@"area"];
            for (int k = 0; k < areaArray.count; k++) {
                NSDictionary *resultDic = areaArray[i];
                
                if ([areaCode isEqualToNumber:resultDic[@"id"]]) {
                    a = i;
                    b = j;
                    c = k;
                    break;
                }
            }
            
        }
    }
    
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(0.0, 0.0, 100, 30);
 
    lable.textAlignment = NSTextAlignmentCenter;

    lable.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    lable.font = [UIFont systemFontOfSize:14];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
        {
            [self.areas removeAllObjects];
            [self.codeArray removeAllObjects];
            
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"city"];
            NSDictionary *areaDic = [[self.cities objectAtIndex:0] objectForKey:@"area"];
            for (NSDictionary *nameDic in areaDic) {
                [self.areas addObject:nameDic[@"name"]];
                [self.codeArray addObject:nameDic[@"id"]];
            }

            self.locate.province = [[self.provinces objectAtIndex:row] objectForKey:@"name"];
            self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"name"];
            
            if ([self.areas count] > 0) {
                self.areaID = [self.codeArray objectAtIndex:0];
                self.locate.area = [self.areas objectAtIndex:0];
            } else {
                self.locate.area = @"";
            }
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];

            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            break;
        }
        case 1:
        {
            [self.areas removeAllObjects];
            [self.codeArray removeAllObjects];
            
            NSDictionary *areaDic = [[self.cities objectAtIndex:row] objectForKey:@"area"];
            for (NSDictionary *nameDic in areaDic) {
                [self.areas addObject:nameDic[@"name"]];
                [self.codeArray addObject:nameDic[@"id"]];
            }
            
            self.locate.city = [[self.cities objectAtIndex:row] objectForKey:@"name"];
            if ([self.areas count] > 0) {
                self.areaID = [self.codeArray objectAtIndex:0];
                self.locate.area = [self.areas objectAtIndex:0];
            } else {
                self.locate.area = @"";
            }
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
  
            break;
        }
        case 2:
            if ([self.areas count] > 0) {
                self.areaID = [self.codeArray objectAtIndex:row];
                self.locate.area = [self.areas objectAtIndex:row];
            } else {
                self.locate.area = @"";
            }
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}

#pragma mark - 展示
- (void)showInView:(UIView *)view {
    
    UIView *bacView = [[UIView alloc] initWithFrame:view.frame];
    bacView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [bacView addSubview:self];
    
//    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
//    self.alpha = 0;
    [view addSubview:bacView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
}

#pragma mark - 确定
- (void)doneClick {
    if ([self.delegate respondsToSelector:@selector(pickerViewSelectAreaOfCode:)]) {
        [self.delegate pickerViewSelectAreaOfCode:_areaID];
    }
    [self cancelPicker];
}

#pragma mark - 取消
- (void)cancelPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end

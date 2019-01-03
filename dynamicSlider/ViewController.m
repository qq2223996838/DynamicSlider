//
//  ViewController.m
//  dynamicSlider
//
//  Created by mooer on 2019/1/3.
//  Copyright © 2019年 mooer. All rights reserved.
//

#import "ViewController.h"
#import "DataSlider.h"
#import "HexColor.h"

//屏幕宽高
#define MooScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MooScreenHeight [[UIScreen mainScreen] bounds].size.height

//16进制 颜色
#define MooMyColor(Color) [HexColor colorWithHexString:(Color)]

@interface ViewController ()<DataSliderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = MooMyColor(@"#728692");
    
    [self addDataSliderUI];
}

- (void)addDataSliderUI
{
    
    NSArray *sliderNameAry = @[@"testSlider one",
                               @"testSlider two",
                               @"testSlider three",
                               @"testSlider four",
                               @"testSlider five",
                               @"testSlider six"];
    
    
    for (int i = 0; i < sliderNameAry.count; i ++) {
        
        DataSlider * Slider  = [[DataSlider alloc] initWithFrame:CGRectMake(20,100+i*(35+50) , MooScreenWidth - 40, 35)];
        Slider.delegate = self;
        Slider.minValue = 0;
        Slider.maxValue = 100.f;
        Slider.initialValue = 50.f;
        Slider.sliderNameHidden = i>3? YES:NO;
        Slider.moduleName = sliderNameAry[i];
        [self.view addSubview:Slider];
        
    }
    
    return;
}


#pragma mark - DataSliderDelegate
- (void)composeToolDataSliderDataValue:(float )value moduleName:(NSString *)moduleName slidingState:(BOOL )stateBool
{
    NSLog(@"您调整了 - %@  滑块值 -  %.1f",moduleName,value);
    return;
}

@end

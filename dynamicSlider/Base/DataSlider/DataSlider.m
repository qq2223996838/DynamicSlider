//
//  DataSlider.m
//  dynamicSlider
//
//  Created by mooer on 2019/1/3.
//  Copyright © 2019年 mooer. All rights reserved.
//

#import "DataSlider.h"
#import "HexColor.h"

//不重写父类 滑块不能实现点击滑块选择数值。
#import "SuperUISlider.h"

/** 推荐写入pch */
#import "UIView+Extension.h"
#import "UIColor+Category.h"

#define MooDataSliderWidth self.frame.size.width
#define MooDataSliderHeight self.frame.size.height
#define MooDataSliderH 50
#define MooDataSliderThumbW MooDataSliderHeight-2
#define MooDataSliderAmplitude 15

//传控件 取该控件宽高
#define MooVW(view) (view.frame.size.width)
#define MooVH(view) (view.frame.size.height)

//16进制 颜色
#define MooMyColor(Color) [HexColor colorWithHexString:(Color)]

@implementation DataSlider

{
    SuperUISlider *slider;     //滑动条控件
    UILabel  *minLabel;
    UILabel  *maxLabel;
    UILabel  *nameLabel;
    UILabel  *dataLabel;
    UIImageView *numberView;
    BOOL moveState;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sliderNameHidden = NO;
        
        //初始化控件
        [self initializationUI];
        
    }
    return self;
}

-(void)initializationUI
{
    //创建slider
    
    slider = [[SuperUISlider alloc] initWithFrame:CGRectMake(0, 0, MooDataSliderWidth, MooDataSliderHeight)];
    slider.continuous = YES;// 设置可连续变化
    
    slider.backgroundColor = [UIColor clearColor];
    
    slider.value = 0;// 滑动条 初始默认值
    
    slider.minimumValue = 0.0;// 滑动条 最小默认值
    
    slider.maximumValue = 100.0;// 滑动条 最大默认值
    
    _maxValue = 31;
    
    //Color.rgb(49, 61, 255)
    
    //轨道图片
    UIImage *stetchLeftTrack = [self OriginImage:[self createImageWithColor:MooMyColor(@"#222327")] scaleToSize:CGSizeMake(12, MooDataSliderH)];
    UIImage *stetchRightTrack = [self OriginImage:[self createImageWithColor:MooMyColor(@"#222327")] scaleToSize:CGSizeMake(12, MooDataSliderH)];
    
    //滑块图片//clear.png
    UIImage *thumbImage = [self OriginImage:[UIImage imageNamed:@"clear"] scaleToSize:CGSizeMake(MooDataSliderThumbW, MooDataSliderH)];
    
    //设置轨道的图片
    
    [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    
    [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    
    slider.layer.cornerRadius = CGRectGetHeight([slider bounds]) / 2;//边框圆角大小
    slider.layer.masksToBounds = YES;
    
    
    //设置滑块的图片
    
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    
    //滑动滑块添加事件
    
    //滑动过程中不断触发事件
    
    [slider addTarget:self action:@selector(onThumb:) forControlEvents:UIControlEventValueChanged];
    
    //滑动完成添加事件
    
    //滑动完成后触发事件
    
    [slider addTarget:self action:@selector(endThumb:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(endThumb:) forControlEvents:UIControlEventTouchUpOutside];//手指界面外抬起
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTap:)];
    [slider addGestureRecognizer:sliderTap];
    
    [self addSubview:slider];
    
    nameLabel = [self Label];
    nameLabel.frame =  CGRectMake(10,0,100,MooDataSliderHeight);
    nameLabel.text = @" ";
    nameLabel.textColor = MooMyColor(@"#02C2C2");
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.hidden = YES;
    [self addSubview:nameLabel];
    
    minLabel = [self Label];
    minLabel.frame =  CGRectMake(10,0,100,MooDataSliderHeight);
    minLabel.text = @"0";
    minLabel.textColor = MooMyColor(@"#02C2C2");
    minLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:minLabel];
    
    
    maxLabel = [self Label];
    maxLabel.frame =  CGRectMake(MooDataSliderWidth-110,0,100,MooDataSliderHeight);
    maxLabel.text = @"100";
    maxLabel.textColor = MooMyColor(@"#02C2C2");
    maxLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:maxLabel];
    
    numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pl_Pre_Control"]];
    numberView.frame =CGRectMake(50, 1, MooDataSliderHeight-2, MooDataSliderHeight-2);
    numberView.userInteractionEnabled = NO;
    [self addSubview:numberView];
    
    
    dataLabel = [self Label];
    dataLabel.frame = CGRectMake(0,0,MooVW(numberView),MooVH(numberView));
    dataLabel.text = @"0";
    dataLabel.textColor = MooMyColor(@"#F9FBFB");
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [numberView addSubview:dataLabel];
    
    moveState = NO;
    
}

-(void)setModuleName:(NSString *)moduleName
{
    _moduleName = moduleName;
    nameLabel.text = moduleName;
    return;
}
-(void)setMinValue:(float )minValue
{
    _minValue = minValue;
    slider.minimumValue = minValue;
    minLabel.text = [NSString stringWithFormat:@"%.f",minValue];
    return;
}
-(void)setMaxValue:(float )maxValue
{
    _maxValue = maxValue;
    slider.maximumValue = maxValue;
    maxLabel.text = [NSString stringWithFormat:@"%.f",maxValue];
    return;
}
-(void)setInitialValue:(float )initialValue
{
    _initialValue = initialValue;
    slider.value = initialValue;
    dataLabel.text = [NSString stringWithFormat:@"%.f",initialValue];
    [self numberViewX:slider];
    return;
}
- (void)setSliderNameHidden:(BOOL)sliderNameHidden
{
    _sliderNameHidden = sliderNameHidden;
    if (sliderNameHidden == YES) {
        nameLabel.text = _moduleName;
        nameLabel.hidden = NO;
        minLabel.hidden = YES;
    }else{
        minLabel.text = @"0";
        minLabel.hidden = NO;
        nameLabel.hidden = YES;
    }
}

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

-(void)onThumb:(id)x
{
    
    UISlider *slider = x;
    dataLabel.text = [self dataorStr:slider.value];
    
    [self numberViewX:slider];
    
    [self.delegate composeToolDataSliderDataValue:slider.value moduleName:_moduleName slidingState:YES];
    
    if (moveState == NO) {
        [self move:NO];
        moveState = YES;
    }
}

-(void)endThumb:(id)x
{
    UISlider *slider = x;
    dataLabel.text = [self dataorStr:slider.value];
    
    [self numberViewX:slider];
    
    [self.delegate composeToolDataSliderDataValue:slider.value moduleName:_moduleName slidingState:NO];
    
    if (moveState == YES) {
        [self move:YES];
        moveState = NO;
    }
    
}
- (void)sliderTap:(UITapGestureRecognizer *)senderTap
{
    CGPoint touchPoint = [senderTap locationInView:slider];
    CGFloat value = (slider.maximumValue - slider.minimumValue) * (touchPoint.x / slider.frame.size.width );
    [slider setValue:value animated:YES];
    dataLabel.text = [self dataorStr:slider.value];
    
    if (moveState == YES) {
        [self move:YES];
        moveState = NO;
    }
    
    [self numberViewX:slider];
    
    [self.delegate composeToolDataSliderDataValue:slider.value moduleName:_moduleName slidingState:NO];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    //convert point to the white layer's coordinates拿到在self.view上但同时在whiteView上的点，下面的同这里一样，不一一解释了
    point = [self.layer convertPoint:point fromLayer:self.layer]; //get layer using containsPoint:
    if ([numberView.layer containsPoint:point]) {
        
    }
    
}

- (void)numberViewX:(UISlider *)x
{
    float xx = MooDataSliderWidth - numberView.width;
    float xxx = xx / _maxValue;
    numberView.x = xxx * x.value;
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    
    bool pureIntBool;
    NSRange range = [string rangeOfString:@"."];//匹配得到的下标
    string = [string substringFromIndex:range.location+1];//截取范围内的字符串
    if ([string  isEqual: @"0"]) {
        pureIntBool = YES;
    }else{
        pureIntBool = NO;
    }
    return pureIntBool;
}


-(NSString *)dataorStr:(float )f
{
    NSString *str = [NSString stringWithFormat:@"%.1f",f];
    if (f == 0.0) {
        str = [NSString stringWithFormat:@"%.f",f];
    }else{
        str = [NSString stringWithFormat:@"%.f",f];
    }
    return str;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (UILabel *)Label{
    
    UILabel *Label = [[UILabel alloc] init];
    Label.textColor = [UIColor blackColor];
    Label.numberOfLines = 0;
    Label.font = [UIFont fontWithName:@"PingFangTC-Regular" size:(15)];
    return Label;
}

- (UIImage*) createImageWithColor: (UIColor*) color

{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}
// 移动
- (void)move:(BOOL )state
{
    // 位置移动
    if (@available(iOS 9.0, *)) {
        CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
        animation.delegate = self;
        // 执行
        animation.beginTime = CACurrentMediaTime();
        // 持续时间
        animation.duration = .2;
        // 重复次数
        animation.repeatCount = 0;
        // 是否还原
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        
        // 阻尼系数（此值越大弹框效果越不明显）
        animation.damping = 4;
        // 刚度系数（此值越大弹框效果越明显）
        animation.stiffness = 6;
        // 质量大小（越大惯性越大）
        animation.mass = 2.8;
        // 初始速度
        animation.initialVelocity = 10;
        
        if (state == NO) {
            // 起始位置
            animation.fromValue = [NSValue valueWithCGPoint:numberView.layer.position];
            // 终止位置
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(numberView.layer.position.x, numberView.layer.position.y - MooDataSliderAmplitude)];
            numberView.y = numberView.y - numberView.height - 5;
        }else{
            // 起始位置
            animation.fromValue = [NSValue valueWithCGPoint:numberView.layer.position];
            // 终止位置
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(numberView.layer.position.x, numberView.layer.position.y + MooDataSliderAmplitude)];
            numberView.y = numberView.y + numberView.height + 5;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }
        
        
        // 添加动画
        [numberView.layer addAnimation:animation forKey:@"move"];
        
        
    } else {
        // Fallback on earlier versions
    }
}


//动画开始时
- (void)animationDidStart:(CAAnimation *)anim
{
    return;
}

//动画结束时
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //方法中的flag参数表明了动画是自然结束还是被打断,比如调用了removeAnimationForKey:方法或removeAnimationForKey方法，flag为NO，如果是正常结束，flag为YES。
    
    [self numberViewX:slider];
}


@end

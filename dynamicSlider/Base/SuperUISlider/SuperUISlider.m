//
//  SuperUISlider.m
//  dynamicSlider
//
//  Created by mooer on 2019/1/3.
//  Copyright © 2019年 mooer. All rights reserved.
//

#import "SuperUISlider.h"

@implementation SuperUISlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end

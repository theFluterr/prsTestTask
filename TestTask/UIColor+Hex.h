//
//  UIColor+Hex.h
//  meshine
//
//  Created by Steffen Neubauer on 11/08/16.
//  Copyright © 2016 meshine GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;

@end

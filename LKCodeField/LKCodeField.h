//
//  LKCodeField.h
//  Test
//
//  Created by Luka Li on 13/6/2018.
//  Copyright © 2018 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCodeField : UIView <UIKeyInput>

@property (nonatomic, assign) NSInteger numberOfCode;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, strong) UIColor *holderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong, readonly) NSString *text;

- (void)clean;

@end

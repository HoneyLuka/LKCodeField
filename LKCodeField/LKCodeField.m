//
//  LKCodeField.m
//  Test
//
//  Created by Luka Li on 13/6/2018.
//  Copyright © 2018 Luka Li. All rights reserved.
//

#import "LKCodeField.h"
#import "Masonry.h"

@interface LKCodeFieldItemView : UIView

@property (nonatomic, strong) UIView *holder;
@property (nonatomic, strong) UILabel *label;

@end

@implementation LKCodeFieldItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    self.userInteractionEnabled = NO;
    
    UIView *holder = [UIView new];
    holder.userInteractionEnabled = NO;
    holder.layer.cornerRadius = 5;
    [self addSubview:holder];
    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@10);
    }];
    self.holder = holder;
    
    UILabel *label = [UILabel new];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.label = label;
}

- (void)setText:(NSString *)text
{
    if (text.length == 1) {
        self.label.text = text;
        self.holder.hidden = YES;
        return;
    }
    
    self.label.text = @"";
    self.holder.hidden = NO;
}

@end

@interface LKCodeField ()

@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation LKCodeField

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)initDefaultValues
{
    _numberOfCode = 6;
    _itemSpacing = 30;
    _text = @"";
    _itemSize = CGSizeMake(20, 40);
    _holderColor = [UIColor lightGrayColor];
    _textFont = [UIFont systemFontOfSize:30];
}

- (void)_setup
{
    [self initDefaultValues];
    self.stackView = [[UIStackView alloc]initWithFrame:self.bounds];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.spacing = _itemSpacing;
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self initItemViews];
    [self reloadCode];
}

- (void)initItemViews
{
    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < _numberOfCode; i++) {
        LKCodeFieldItemView *itemView = [LKCodeFieldItemView new];
        itemView.holder.backgroundColor = _holderColor;
        itemView.label.textColor = _textColor;
        itemView.label.font = _textFont;
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.itemSize.width));
            make.height.equalTo(@(self.itemSize.height));
        }];
        [self.stackView addArrangedSubview:itemView];
    }
}

- (void)reloadCode
{
    for (int i = 0; i < _numberOfCode; i++) {
        NSString *t = @"";
        if (i < self.text.length) {
            t = [self.text substringWithRange:NSMakeRange(i, 1)];
        }
        
        LKCodeFieldItemView *itemView = self.stackView.arrangedSubviews[i];
        [itemView setText:t];
    }
}

- (void)reloadItemViewsStyle
{
    for (LKCodeFieldItemView *itemView in self.stackView.arrangedSubviews) {
        itemView.holder.backgroundColor = _holderColor;
        itemView.label.textColor = _textColor;
        itemView.label.font = _textFont;
    }
}

#pragma mark - Setter

- (void)setNumberOfCode:(NSInteger)numberOfCode
{
    _numberOfCode = numberOfCode;
    [self initItemViews];
    [self reloadCode];
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self initItemViews];
    [self reloadCode];
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    _itemSpacing = itemSpacing;
    self.stackView.spacing = itemSpacing;
}

- (void)setHolderColor:(UIColor *)holderColor
{
    _holderColor = holderColor;
    [self reloadItemViewsStyle];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self reloadItemViewsStyle];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    [self reloadItemViewsStyle];
}

#pragma mark - Input

- (void)clean
{
    self.text = @"";
    [self reloadCode];
}

- (void)insertText:(NSString *)text
{
    if (text.length != 1) {
        return;
    }
    
    if (self.text.length >= _numberOfCode) {
        return;
    }
    
    NSScanner *scanner = [[NSScanner alloc]initWithString:text];
    BOOL result = [scanner scanInteger:NULL];
    if (!result) {
        return;
    }
    
    self.text = [self.text stringByAppendingString:text];
    [self reloadCode];
}

- (void)deleteBackward
{
    if (!self.text.length) {
        return;
    }
    
    self.text = [self.text substringToIndex:self.text.length - 1];
    [self reloadCode];
}

#pragma mark - Keyboard delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIKeyboardType)keyboardType
{
    return UIKeyboardTypeNumberPad;
}

- (BOOL)hasText
{
    return YES;
}


@end

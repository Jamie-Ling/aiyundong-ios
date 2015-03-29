//
//  GraphicButton.m
//  LoveSports
//
//  Created by zorro on 15/3/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "GraphicButton.h"

@implementation GraphicButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadButtons];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _imageButton.selected = selected;
    _subLabel.textColor = selected ? UIColorRGB(239, 58, 31) : [UIColor lightGrayColor];
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageButton.imageNormal = imageArray[0];
    _imageButton.imageSelecte = imageArray[1];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subLabel.text = subTitle;
}

- (void)loadButtons
{
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.3, self.height)];
    
    _imageButton.backgroundColor = [UIColor clearColor];
    _imageButton.selected = NO;
    _imageButton.userInteractionEnabled = NO;
    [self addSubview:_imageButton];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width * 0.3, 0, self.width * 0.7, self.height)];
    
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.userInteractionEnabled = NO;
    [self addSubview:_subLabel];
    _subLabel.textColor = self.selected ? UIColorRGB(239, 58, 31) : [UIColor lightGrayColor];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

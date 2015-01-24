//
//  ObjectCTools.m
//  MissionSky-iOS
//
//  Created by jamie on 14-11-16.
//  Copyright (c) 2014年 Jamie.ling. All rights reserved.
//


#import "ObjectCTools.h"
#import "AppDelegate.h"
#import "NoPasteTextField.h"


static ObjectCTools *_tools = nil;

@implementation ObjectCTools


/**
 @brief 获取工具集的单例
 */
+(ObjectCTools *)shared
{
    @synchronized(self)
    {
        if (_tools == nil) {
            _tools = [[ObjectCTools alloc] init];
            
        }
        return _tools;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}

#pragma mark ---------------- 主代理等对象获取 -----------------
/**
 @brief 获取主代理对象
 */
- (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark ---------------- 控件封装  -----------------
/**
 *  创建导航条右按钮
 *
 *  @param title     按钮标题
 *  @param obj       按钮作用对象（响应方法的对象）
 *  @param selector  按钮响应的方法
 *  @param imageName 按钮图片名称
 *
 *  @return 右按钮对象
 */
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector ImageName:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    //iOS7之前的版本需要手动设置和屏幕边缘的间距
    if (kIOSVersions < 7.0) {
        leftButton.frame = CGRectInset(leftButton.frame, -10, 0);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return item;
}

/**
 *  创建导航条左按钮
 *
 *  @param title     按钮标题,当为@""空时，选择默认图片vBackBarButtonItemName
 *  @param obj       按钮作用对象（响应方法的对象）
 *  @param selector  按钮响应的方法
 *  @param imageName 按钮图片名称
 *
 *  @return 左按钮对象
 */
- (UIBarButtonItem *)createLeftBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector ImageName:(NSString*)imageName
{
    UIImage *image;
    if ([NSString isNilOrEmpty:imageName ])
    {
        image = [UIImage imageNamed:vBackBarButtonItemName];
    }
    else
    {
        image = [UIImage imageNamed:imageName];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    
    //本应用返回时仍需要显示返回二字
    if ([title isEqualToString:@"返回"]) {
        title = @"  返回";
    }
    
    if ([title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
    }else{
        
    }
    //ios8.0 此方法过时，用下面的方法替代---
    //    CGSize titleSize = [title sizeWithAttributes:[UIFont systemFontOfSize:18]];
    
    UIFont *fnt = [UIFont systemFontOfSize:18];
    // 根据字体得到NSString的尺寸
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    //----------
    
    if (titleSize.width < 44) {
        titleSize.width = 44;
    }
    button.frame = CGRectMake(0, 0, titleSize.width, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:130.0/255 green:56.0/255 blue:23.0/255 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    //    CGPoint tempCenter = button.center;
    //    //图片尺寸不对时，用默认参数进行缩放
    //    [button setFrame:CGRectMake(0, 0, image.size.width / kAllImageZoomSize, image.size.height / kAllImageZoomSize)];
    //    [button setCenter:tempCenter];
    
    //iOS7之前的版本需要手动设置和屏幕边缘的间距
    if (kIOSVersions < 7.0) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

/**
 *  自定义Button,无背景图片
 *
 *  @param frame                  Frame
 *  @param backgroudColor        背景颜色
 *  @param titleNormalColor      按钮标题正常颜色
 *  @param titleHighlightedColor 按钮标题高亮颜色
 *  @param title                 按钮标题文字
 *  @param font                  按钮标题文字大小
 *  @param cornerRadius          按钮外围角度
 *  @param borderWidth           按钮外围线宽度
 *  @param borderColor           按钮颜色
 *  @param accessibilityLabel    标签，可方便相关UI测试找到id
 *
 *  @return 返回自定义按钮
 */
- (UIButton *) getACustomButtonNoBackgroundImage:(CGRect) frame
                                  backgroudColor: (UIColor *) backgroudColor
                                titleNormalColor: (UIColor *) titleNormalColor
                           titleHighlightedColor: (UIColor *) titleHighlightedColor
                                           title: (NSString *) title
                                            font: (UIFont *) font
                                    cornerRadius: (CGFloat ) cornerRadius
                                     borderWidth: (CGFloat) borderWidth
                                     borderColor: (CGColorRef ) borderColor
                              accessibilityLabel: (NSString *) accessibilityLabel
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = frame;
    customButton.backgroundColor = backgroudColor;
    [customButton setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [customButton setTitleColor:titleNormalColor forState:UIControlStateHighlighted];
    [customButton setTitle:title forState:UIControlStateNormal];
    if (titleHighlightedColor != nil)
    {
        [customButton setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    }
    
    customButton.titleLabel.font = font;
    if (cornerRadius)
    {
        customButton.layer.cornerRadius = cornerRadius;
    }
    if (borderWidth)
    {
        customButton.layer.borderWidth = borderWidth;
        customButton.layer.borderColor = borderColor;
    }
    if (accessibilityLabel != nil)
    {
        customButton.accessibilityLabel = accessibilityLabel; //标签，可方便相关UI测试找到id
    }
    
    return customButton;
}

/**
 *  自定义Button，有背景图片
 *
 *  @param fram                           Frame
 *  @param titleNormalColor               按钮标题正常颜色
 *  @param titleHighlightedColor          按钮标题高亮颜色
 *  @param title                          按钮标题文字
 *  @param font                           按钮标题文字大小
 *  @param normalBackgroundImageName      按钮默认背景图片
 *  @param highlightedBackgroundImageName 按钮高亮背景图片
 *  @param accessibilityLabel             标签，可方便相关UI测试找到id
 *
 *  @return 返回自定义按钮
 */
- (UIButton *) getACustomButtonWithBackgroundImage:(CGRect) frame
                                  titleNormalColor: (UIColor *) titleNormalColor
                             titleHighlightedColor: (UIColor *) titleHighlightedColor
                                             title: (NSString *) title
                                              font: (UIFont *) font
                         normalBackgroundImageName: (NSString *) normalBackgroundImageName
                    highlightedBackgroundImageName: (NSString *) highlightedBackgroundImageName
                                accessibilityLabel: (NSString *) accessibilityLabel
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = frame;
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setTitle:title forState:UIControlStateHighlighted];
    [customButton setTitleColor:titleNormalColor forState:UIControlStateNormal];
    if (titleHighlightedColor)
    {
        [customButton setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    }
    customButton.titleLabel.font = font;
    [customButton setBackgroundImage:[UIImage imageNamed:normalBackgroundImageName] forState:UIControlStateNormal];  //设置成backimage才能在上面添加文字
    if (highlightedBackgroundImageName)
    {
        [customButton setBackgroundImage:[UIImage imageNamed:highlightedBackgroundImageName] forState:UIControlStateHighlighted];
    }
    if (accessibilityLabel != nil)
    {
        customButton.accessibilityLabel = accessibilityLabel; //标签，可方便相关UI测试找到id
    }
    return customButton;
}

/**
 *  自定义Lable
 *
 *  @param frame           Frame
 *  @param backgroundColor 背景颜色
 *  @param text            文字内容
 *  @param textColor       文字颜色
 *  @param font            文字大小
 *  @param textAlignment   对齐方式
 *  @param lineBreakMode   换行模式
 *  @param numberOfLines   行数，0表示不限制
 *
 *  @return 自定义Lable
 */
- (UILabel *) getACustomLableFrame: (CGRect) frame backgroundColor: (UIColor *) backgroundColor text: (NSString *) text textColor: (UIColor *) textColor font: (UIFont *) font textAlignment: (NSTextAlignment) textAlignment lineBreakMode: (NSLineBreakMode) lineBreakMode numberOfLines: (int) numberOfLines
{
    UILabel *customLable = [[UILabel alloc] initWithFrame:frame];
    if (backgroundColor != nil)
    {
        customLable.backgroundColor = backgroundColor;
    }
    customLable.text = text;
    if (textColor != nil)
    {
        customLable.textColor = textColor;
    }
    customLable.font = font;
    if (textAlignment)
    {
        customLable.textAlignment = textAlignment;
    }
    //    if (lineBreakMode)
    {
        customLable.lineBreakMode = lineBreakMode;
    }
    //    if (numberOfLines)
    {
        customLable.numberOfLines = numberOfLines;
    }
    
    return customLable;
}

/**
 *   自定义TextFiled
 *
 *  @param frame              Frame
 *  @param backgroundColor    背景颜色
 *  @param placeholder        占位文字
 *  @param textColor          输入文字颜色
 *  @param font               输入文字大小
 *  @param borderStyle        输入框样式
 *  @param textAlignment      文字对齐方式
 *  @param accessibilityLabel 标签，可方便相关UI测试找到id
 *  @param autocorrectionType 自动更正功能样式
 *  @param clearButtonMode    清除按钮模式
 *  @param tag                tag
 *  @param isPassword         是否是密码输入框
 *
 *  @return 返回自定义输入框
 */
- (UITextField *) getACustomTextFiledFrame: (CGRect) frame
                           backgroundColor: (UIColor *)backgroundColor
                               placeholder: (NSString *) placeholder
                                 textColor: (UIColor *) textColor
                                      font: (UIFont *) font
                               borderStyle:(UITextBorderStyle) borderStyle
                             textAlignment: (NSTextAlignment) textAlignment
                        accessibilityLabel: (NSString *) accessibilityLabel
                        autocorrectionType: (UITextAutocorrectionType) autocorrectionType
                           clearButtonMode: (UITextFieldViewMode) clearButtonMode
                                       tag: (NSInteger) tag
                            withIsPassword: (BOOL) isPassword
{
    UITextField *customTextFiled;
    if (isPassword)
    {
        customTextFiled = [[NoPasteTextField alloc] initWithFrame:frame];
        customTextFiled.secureTextEntry = YES;
    }
    else
    {
        customTextFiled = [[UITextField alloc] initWithFrame:frame];
    }
    if (textColor != nil)
    {
        [customTextFiled setTextColor:textColor];
    }
    if (backgroundColor != nil)
    {
        customTextFiled.backgroundColor = backgroundColor;
    }
    if (placeholder != nil)
    {
        customTextFiled.placeholder = placeholder;
    }
    if (font != nil)
    {
        customTextFiled.font = font;
    }
    if (borderStyle)  //如果是nil得自己设置背景框
    {
        customTextFiled.borderStyle = borderStyle;
    }
    if (textAlignment)
    {
        customTextFiled.textAlignment = textAlignment;  //内容对齐方式
    }
    if (accessibilityLabel != nil)
    {
        customTextFiled.accessibilityLabel = accessibilityLabel; //标签，可方便相关UI测试找到id
    }
    if (autocorrectionType)
    {
        customTextFiled.autocorrectionType = autocorrectionType; //是否自动使用iphone更正功能
    }
    if (clearButtonMode)
    {
        customTextFiled.clearButtonMode = clearButtonMode;      //清空按钮样式
    }
    if (tag)
    {
        customTextFiled.tag = tag;
    }
    
    return customTextFiled;
}

/**
 *  进一步定制化-左侧添加包含PaddingView的输入框(填充图片或文字)
 *
 *  @param frame           Frame
 *  @param placeholder     占位文字
 *  @param tag             tag
 *  @param imageName       左侧填充图片名，如非图片设置为空：@"",与paddingViewText优先选择paddingViewText
 *  @param zoomNumber      图片缩放比例  默认为1.0
 *  @param borderStyle     输入框样式
 *  @param keyboardType    键盘样式
 *  @param delegate        代理对象
 *  @param isPassword      是否是密码输入框
 *  @param paddingViewText 左侧填充文字，为空时才选择imageName
 *  @param returnKeyType   键盘Return按钮样式
 *
 *  @return 进一步定制化的输入框
 */
- (UITextField *) getACustomTextFiledWithFrame: (CGRect) frame
                               withPlaceholder: (NSString *) placeholder
                                       withTag: (NSInteger) tag
                             withLeftImaegName: (NSString *) imageName
                                      withZoom: (float) zoomNumber
                               withBorderStyle:(UITextBorderStyle)borderStyle
                              withKeyboardType: (UIKeyboardType) keyboardType
                                    toDelegate: (UIViewController<UITextFieldDelegate> *) delegate
                                withIsPassword: (BOOL) isPassword
                           withPaddingViewText: (NSString *) paddingViewText
                             withReturnKeyType: (UIReturnKeyType) returnKeyType
{
    UITextField *theTextField = [[ObjectCTools shared] getACustomTextFiledFrame:frame backgroundColor:kRGB(234.0, 234.0, 234.0) placeholder:placeholder  textColor:[UIColor blackColor] font:kTextFeildFontSize borderStyle:borderStyle textAlignment:NSTextAlignmentLeft accessibilityLabel:@"did not need this" autocorrectionType:UITextAutocorrectionTypeNo clearButtonMode:UITextFieldViewModeWhileEditing tag:tag withIsPassword:isPassword];
    theTextField.keyboardType = keyboardType;
    
    kCenterTheView(theTextField);
    //设置placeHold字体颜色
    UIColor *tempColor = kHoldPlacerColor;
    theTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: tempColor}];
    
    if (![NSString isNilOrEmpty:paddingViewText ])
    {
        [self getAPaddingView:theTextField withPaddingViewText:paddingViewText];
    }
    else if (![NSString isNilOrEmpty:imageName ])
    {
        [self getAPaddingView:theTextField withImage:imageName withZoomNumber:zoomNumber];
    }
    
    theTextField.delegate = delegate;
    theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    theTextField.returnKeyType = returnKeyType;
    
    return theTextField;
}

//返回textfield的PaddingView（包含图标）
- (UIView *) getAPaddingView: (UITextField *) theTextField withImage: (NSString *) imageName withZoomNumber: (float) zoomNumber
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, theTextField.frame.size.height)];
    theTextField.leftView = paddingView;
    theTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(3, 10, theTextField.frame.size.height / 2.5, theTextField.frame.size.height / 2.0)];
    UIImage *tempImage = [UIImage imageNamed:imageName];
    if (zoomNumber)
    {
        [icon setFrame:CGRectMake(3, 10, tempImage.size.width / zoomNumber, tempImage.size.height / zoomNumber)];   //自动适配
    }
    icon.image =[UIImage imageNamed:imageName];
    [paddingView addSubview: icon];
    icon.center = CGPointMake(paddingView.frame.size.width / 2.0, icon.center.y);
    
    return paddingView;
}

//返回textfield的PaddingView（包含文字和分隔竖线）
- (UIView *) getAPaddingView: (UITextField *) theTextField withPaddingViewText: (NSString *) text
{
    //paddingView
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, theTextField.frame.size.height)];
    theTextField.leftView = paddingView;
    theTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *paddingLabel = [self getACustomLableFrame:paddingView.frame backgroundColor:[UIColor clearColor] text:text textColor:kRGB(40.0, 47.0, 56.0) font:kTextFeildFontSize textAlignment:NSTextAlignmentCenter lineBreakMode:0 numberOfLines:0];
    
    [paddingView addSubview:paddingLabel];
    paddingLabel.center = CGPointMake(paddingView.frame.size.width / 2.0, paddingLabel.center.y);
    
    //竖线
    UIView *aLine = [[UIView alloc] initWithFrame:CGRectMake(paddingLabel.right, 12.0 , 1.0 , theTextField.height - 12.0 * 2)];
    [aLine setBackgroundColor: kHoldPlacerColor];
    [paddingView addSubview:aLine];
    
    return paddingView;
}

/**
 *  自定义UIImageView
 *
 *  @param center        中心位置
 *  @param imageName     图片名字
 *  @param imageZoomSize 图片缩放比例  默认为1.0
 *
 *  @return 自定义UIImageView
 */
- (UIImageView *) getACustomImageViewWithCenter: (CGPoint) center
                                  withImageName: (NSString *) imageName
                              withImageZoomSize: (CGFloat) imageZoomSize
{
    CGFloat zoomsize = 1.0;
    UIImage *theImage = [UIImage imageNamed:imageName];
    if (imageZoomSize)
    {
        zoomsize = imageZoomSize;
    }
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theImage.size.width / zoomsize, theImage.size.height / zoomsize)];
    theImageView.image = theImage;
    theImageView.center = center;
    
    return theImageView;
}

/**
 *  设置UIlable的行距
 *
 *  @param lable       要设置行距的lable对象
 *  @param lableString lable显示的字符串
 *  @param lineSpacing 要设置的行距高度
 */
- (void) setLableLineSpacing:(UILabel *) lable
             withLableString:(NSString *) lableString
             withLineSpacing: (NSInteger) lineSpacing
{
    if ([NSString isNilOrEmpty:lableString ])
    {
        return;
    }
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:lableString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lableString length])];
    [lable setAttributedText:attributedString1];
    //    [lable sizeToFit];
}

/**
 *  设置lable自适应，改变bounds(可以限定宽高的边界),通常设置完后要重新设置位置
 *
 *  @param theLable                  要设置自适应的lable对像
 *  @param maxWidth                  宽度最大值， 为0时不指定
 *  @param minWidth                  宽度最小值， 为0时不指定
 *  @param maxHeight                 高度最大值， 为0时不指定
 *  @param minHeight                 高度最小值， 为0时不指定
 *  @param adjustsFontSizeToFitWidth 是否字体根据宽度自动适应变化尺寸
 */
- (void) setLableSizeToFit:(UILabel *) theLable
              withMaxWidth:(CGFloat) maxWidth
              withminWidth:(CGFloat) minWidth
             withMaxHeight: (CGFloat ) maxHeight
             withminHeight:(CGFloat) minHeight
        withFontToFitWidth: (BOOL) adjustsFontSizeToFitWidth
{
    CGSize frameSize = [theLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:theLable.font, NSFontAttributeName, nil]];
    if (maxWidth && frameSize.width > maxWidth)
    {
        frameSize.width = maxWidth;
    }
    if (minWidth && frameSize.width < minWidth)
    {
        frameSize.width = minWidth;
    }
    if (maxHeight && frameSize.height > maxHeight)
    {
        frameSize.height = maxHeight;
    }
    if (minHeight && frameSize.height < minHeight)
    {
        frameSize.height = minHeight;
    }
    [theLable setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
    [theLable setWidth:frameSize.width];
    [theLable setHeight:frameSize.height];
}

/**
 *  得到一个圆形按钮
 *
 *  @param theSize    按钮的边长
 *  @param imagetName 按钮图片名字
 *
 *  @return 返回生成的这个圆形按钮
 */
- (FlatRoundedButton *) getARoundedButtonWithSize:(CGFloat ) theSize
                                    withImageName: (NSString *) imagetName
{
    FlatRoundedButton *userImageButton = [[FlatRoundedButton alloc] initWithFrame:CGRectMake(0, 0, theSize, theSize)];
    if (![NSString isNilOrEmpty:imagetName])
    {
        // 不做缓存
        [userImageButton setImage:[UIImage imageNamed:imagetName] forState:UIControlStateNormal];
    }
    else
    {
        //设置成默认圆形图片
        [userImageButton setImage:[UIImage imageNamed:kDefaultHeadPhoto] forState:UIControlStateNormal];
    }
    [userImageButton setBorderColor:[UIColor orangeColor]];
    [userImageButton setBorderWidth:0.5];
    
    return userImageButton;
}

#pragma mark ---------------- 缓存数据plist读、写、清除(个人信息数据)-----------------
/**
 *  写入一条数据到plist文件(个人信息数据)
 *
 *  @param object 写入的对象
 *  @param key    写入对象的key
 *
 *  @return YES:写入成功，NO:写入失败
 */
- (BOOL)setobject:(id )object forKey:(NSString *)key
{
    BOOL success = NO;
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSLog(@"****path = %@", pPath);
    NSMutableDictionary *plistDictionary = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithContentsOfFile:pPath];
    if (!plistDictionary)
    {
        plistDictionary = [NSMutableDictionary dictionary];
    }
    [plistDictionary setValue:object forKey:key];
    if (key && object)
    {
        if ([plistDictionary writeToFile:pPath atomically:YES])
        {
            success = YES;
        }
    }
    return success;
}

/**
 @brief 从plist文件读取某条个人信息数据
 @param key 读取对象的key
 @result id 读取得到的对象
 */
- (id)objectForKey:(NSString *)key
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSLog(@"****path = %@", pPath);
    NSDictionary *arrayData = [NSDictionary dictionaryWithContentsOfFile:pPath];
    NSArray *keys = [arrayData allKeys];
    for (NSString *tempKey in keys)
    {
        if ([tempKey isEqualToString:key])
        {
            return [arrayData objectForKey:key];
        }
    }
    return nil;
}

/**
 @brief 从plist文件清除某条个人信息数据
 @param key 清除对象的key
 */
- (void)removeObjectForKey:(NSString *)key
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSMutableDictionary *arrayData = [NSMutableDictionary dictionaryWithContentsOfFile:pPath];
    NSArray *keys = [arrayData allKeys];
    for (NSString *tempKey in keys)
    {
        if ([tempKey isEqualToString:key])
        {
            [arrayData removeObjectForKey:key];
        }
    }
    [arrayData writeToFile:pPath atomically:YES];
}

/**
 *  刷新存在NSUserDefaults的用户信息
 *
 *  @param key   要刷新的信息的key
 *  @param value 要刷新的信息的value
 *
 *  @return 刷新是否成功
 */
- (BOOL) refreshTheUserInfoDictionaryWithKey:(NSString *) key
                                   withValue: (NSString *) value
{
    NSDictionary *userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfo];
    if (userInfoDictionary)
    {
        NSMutableDictionary *newUserInfoDictionary = [NSMutableDictionary dictionaryWithDictionary:userInfoDictionary];
        [newUserInfoDictionary setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:newUserInfoDictionary forKey:kLastLoginUserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

#pragma mark ---------------- URL提取-----------------
/**
 @brief 根据接口名从urls.plist文件获取完整url
 @param serverInterfaceName url的接口名
 @result NSString 获取到的完整url，如果为空字符串代表接口名错误或plist文件配置错误
 */
- (NSString *)getUrlsFromPlistFile: (NSString *)serverInterfaceName
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Urls.plist"];
    
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *urlKey = (NSString*)[data objectForKey:@"MS_ENVIRONMENT"];
    
    NSDictionary *serverAdderssDic = [data objectForKey:@"serverAddress"];
    NSDictionary *serverInterfaceDic = [data objectForKey:@"serverInterface"];
    NSString *urlFullAdderss = @"";
    
    if ([serverAdderssDic objectForKey:urlKey])
    {
        urlFullAdderss = [serverAdderssDic objectForKey:urlKey];
    }
    
    NSDictionary *interfaceUrl = [serverInterfaceDic objectForKey:serverInterfaceName];
    if ([interfaceUrl objectForKey:urlKey])
    {
        NSString *interfaceUrlString = [interfaceUrl objectForKey:urlKey];
        if ([interfaceUrlString hasPrefix:@"http"])
        {
            NSLog(@"get the fullUrl path: %@", interfaceUrlString);
            return interfaceUrlString;
        }
        urlFullAdderss = [NSString stringWithFormat:@"%@%@", urlFullAdderss, interfaceUrlString];
    }
    NSLog(@"get the fullUrl path: %@", urlFullAdderss);
    
    //去掉空格，防止url出错
    urlFullAdderss = [urlFullAdderss stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return urlFullAdderss;
}

/**
 @brief  从urls.plist文件获取服务器url（不带接口）
 @result NSString 获取到的服务器url
 */
- (NSString *)getServerAdderss
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Urls.plist"];
    
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *urlKey = (NSString*)[data objectForKey:@"MS_ENVIRONMENT"];
    NSDictionary *serverAdderssDic = [data objectForKey:@"serverAddress"];
    NSString *urlFullAdderss = @"";
    
    if ([serverAdderssDic objectForKey:urlKey])
    {
        urlFullAdderss = [serverAdderssDic objectForKey:urlKey];
    }
    return urlFullAdderss;
}


#pragma mark ---------------- 格式校验 -----------------
/**
 *  密码校验
 *
 *  @param numString 待校验的密码
 *
 *  @return 校验结果，YES：合格， NO：密码格式不正确
 */
- (BOOL)checkPassword:(NSString *)numString {
    NSString *urlRegex = @"[a-zA-Z0-9_]{6,20}$";  //最少6位，最多20位
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    return [pred evaluateWithObject:numString];
}


/**
 *  邮箱校验
 *
 *  @param str2validate 待校验的邮箱
 *
 *  @return 校验结果，YES：合格， NO：邮箱格式不正确
 */
- (BOOL)checkEmail:(NSString *)str2validate;
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:str2validate];
}

/**
 *  手机号码简单校验并用UIAlertView提示
 *
 *  @param phoneNumberString 等校验的手机号码
 *
 *  @return 校验结果，YES：合格， NO：手机号码格式不正确
 */
- (BOOL) checkPhoneNumberAndShowAlert: (NSString *) phoneNumberString
{
    if ([phoneNumberString stringByReplacingOccurrencesOfString:@" " withString:@""].length !=11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (![[phoneNumberString substringToIndex:1] isEqualToString:@"1"]) {
        UIAlertView	*alertview = [[UIAlertView alloc] initWithTitle:@"手机号码输入不正确，请输入正确的手机号"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertview show];
        return NO;
    }
    return YES;
}

/**
 *  手机号码或者邮箱号码校验
 *
 *  @param numberOrEmailString 待校验的用户名（可能为手机号码或者邮箱号码）
 *
 *  @return 校验结果，YES：合格， NO：手机号码格式及邮箱格式均不正确
 */
- (BOOL)checkPhoneNumberOrEmail: (NSString *) numberOrEmailString
{
    if (![self checkEmail:numberOrEmailString])
    {
        //手机号码简单校验位数
        if (numberOrEmailString.length) {
            if (![[numberOrEmailString substringToIndex:1] isEqualToString:@"1"]) {
                return NO;
            }
            
            if ([numberOrEmailString stringByReplacingOccurrencesOfString:@" " withString:@""].length != 11) {
                
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark ---------------- TableView相关 -----------------
/**
 *  隐藏多余分隔线
 *
 *  @param tableView 需要隐藏分割线的tableView
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    view = nil;
}

#pragma mark ---------------- 摄像头和相册相关的公共类 -----------------
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
@end

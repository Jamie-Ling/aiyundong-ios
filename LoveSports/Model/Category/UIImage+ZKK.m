//
//  UIImage+ZKK.m
//  VPhone
//
//  Created by zorro on 14-10-22.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "UIImage+ZKK.h"
#import "XYSandbox.h"

@implementation UIImage (ZKK)

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage setImageFromFile:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}

+ (UIImage *)setImageFromFile:(NSString *)fileString
{
    return  [UIImage imageWithFile:[[NSBundle mainBundle]pathForResource:fileString ofType:nil]];
}

+ (UIImage *)imageWithFile:(NSString *)path{
    UIImage *img = nil;
    
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
        img = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        img = [UIImage imageWithContentsOfFile:path];
    }
    return img;
}

+ (BOOL)checkPngIsExist:(NSString *)filePath withIndex:(NSString *)imageName
{
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@", [XYSandbox libCachePath], filePath, imageName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (UIImage*) stackBlur:(NSUInteger)inradius
{
    if (inradius < 1){
        return self;
    }
    // Suggestion xidew to prevent crash if size is null
    if (CGSizeEqualToSize(self.size, CGSizeZero)) {
        return self;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
    // First get the image into your data buffer
    CGImageRef inImage = self.CGImage;
    int nbPerCompt = CGImageGetBitsPerPixel(inImage);
    if(nbPerCompt != 32){
        UIImage *tmpImage = [self normalize];
        inImage = tmpImage.CGImage;
    }
    CFDataRef theData = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    CFMutableDataRef m_DataRef = CFDataCreateMutableCopy(0, 0, theData);
    CFRelease(theData);
    UInt8 * m_PixelBuf = (UInt8 *)malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    // Apply stack blur
    const int imageWidth  = CGImageGetWidth(inImage);
    const int imageHeight = CGImageGetHeight(inImage);
    [self.class applyStackBlurToBuffer:m_PixelBuf
                                 width:imageWidth
                                height:imageHeight
                            withRadius:inradius];
    
    // Make new image
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(m_DataRef);
    free(m_PixelBuf);
    return finalImage;
}

- (UIImage *) normalize {
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8, (4 * width),
                                                         genericColorSpace,
                                                         kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;
}

#define SQUARE(i) ((i)*(i))
inline static void zeroClearInt(int* p, size_t count) { memset(p, 0, sizeof(int) * count); }
+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius {
    // Constants
    const int radius = inradius; // Transform unsigned into signed for further operations
    const int wm = w - 1;
    const int hm = h - 1;
    const int wh = w*h;
    const int div = radius + radius + 1;
    const int r1 = radius + 1;
    const int divsum = SQUARE((div+1)>>1);
    
    // Small buffers
    int stack[div*3];
    zeroClearInt(stack, div*3);
    
    int vmin[MAX(w,h)];
    zeroClearInt(vmin, MAX(w,h));
    
    // Large buffers
    int *r = (int *)malloc(wh*sizeof(int));
    int *g = (int *)malloc(wh*sizeof(int));
    int *b = (int *)malloc(wh*sizeof(int));
    zeroClearInt(r, wh);
    zeroClearInt(g, wh);
    zeroClearInt(b, wh);
    
    const size_t dvcount = 256 * divsum;
    int *dv = (int *)malloc(sizeof(int) * dvcount);
    for (int i = 0;i < dvcount;i++) {
        dv[i] = (i / divsum);
    }
    
    // Variables
    int x, y;
    int *sir;
    int routsum,goutsum,boutsum;
    int rinsum,ginsum,binsum;
    int rsum, gsum, bsum, p, yp;
    int stackpointer;
    int stackstart;
    int rbs;
    
    int yw = 0, yi = 0;
    for (y = 0;y < h;y++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        
        for(int i = -radius;i <= radius;i++){
            sir = &stack[(i + radius)*3];
            int offset = (yi + MIN(wm, MAX(i, 0)))*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            
            rbs = r1 - abs(i);
            rsum += sir[0] * rbs;
            gsum += sir[1] * rbs;
            bsum += sir[2] * rbs;
            if (i > 0){
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
        }
        stackpointer = radius;
        
        for (x = 0;x < w;x++) {
            r[yi] = dv[rsum];
            g[yi] = dv[gsum];
            b[yi] = dv[bsum];
            
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (y == 0){
                vmin[x] = MIN(x + radius + 1, wm);
            }
            
            int offset = (yw + vmin[x])*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[(stackpointer % div)*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi++;
        }
        yw += w;
    }
    
    for (x = 0;x < w;x++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        yp = -radius*w;
        for(int i = -radius;i <= radius;i++) {
            yi = MAX(0, yp) + x;
            
            sir = &stack[(i + radius)*3];
            
            sir[0] = r[yi];
            sir[1] = g[yi];
            sir[2] = b[yi];
            
            rbs = r1 - abs(i);
            
            rsum += r[yi]*rbs;
            gsum += g[yi]*rbs;
            bsum += b[yi]*rbs;
            
            if (i > 0) {
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
            
            if (i < hm) {
                yp += w;
            }
        }
        yi = x;
        stackpointer = radius;
        for (y = 0;y < h;y++) {
            int offset = yi*4;
            targetBuffer[offset]     = dv[rsum];
            targetBuffer[offset + 1] = dv[gsum];
            targetBuffer[offset + 2] = dv[bsum];
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (x == 0){
                vmin[y] = MIN(y + r1, hm)*w;
            }
            p = x + vmin[y];
            
            sir[0] = r[p];
            sir[1] = g[p];
            sir[2] = b[p];
            
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[stackpointer*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi += w;
        }
    }
    
    free(r);
    free(g);
    free(b);
    free(dv);
}


+ (UIImage *)image:(NSString *)resourceName
{
    UIImage *img = nil;
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)])
    {
        img = [[UIImage imageNamed:resourceName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        img = [UIImage imageNamed:resourceName];
    }
    
    return img;
}

@end

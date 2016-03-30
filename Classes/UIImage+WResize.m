//
//  UIImage+WResize.m
//  Warp
//
//  Created by Lukáš Foldýna on 28.12.12.
//  Copyright (c) 2012 TwoManShow. All rights reserved.
//

#import "UIImage+WResize.h"
#import <ImageIO/ImageIO.h>


@implementation UIImage (WResize)

- (UIImage *) croppedImage:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *) croppedImageWithOrientation:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *) resizedImage:(CGSize)newSize
{
    if (MIN(newSize.width, newSize.height) > MIN(self.size.width, self.size.height)) {
        return self;
    }
    CGSize imageSize = [self size];
    CGFloat width = imageSize.width, height = imageSize.height;
    
    if (height > width) {
        width  = ceilf(newSize.width * (width / height));
        height = newSize.height;
    } else {
        height = ceilf(newSize.height * (height / width));
        width  = newSize.width;
    }
    newSize = CGSizeMake(width, height);
    BOOL drawTransposed = NO;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self _resizedImage:newSize transform:[self _transformForOrientation:newSize] drawTransposed:drawTransposed interpolationQuality:kCGInterpolationDefault];
}

+ (UIImage *) resizedImageWithPath:(NSString *)path size:(CGSize)newSize
{
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], NULL);
    if (source == NULL)
        return nil;
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{
        //(id)kCGImageSourceShouldCache : (id)kCFBooleanTrue,
        (id)kCGImageSourceCreateThumbnailWithTransform : (id)kCFBooleanTrue,
        (id)kCGImageSourceCreateThumbnailFromImageIfAbsent : (id)kCFBooleanTrue,
        (id)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:newSize.width > newSize.height ? newSize.width : newSize.height]};
    
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, options);
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    CGImageRelease(thumbnail);
    CFRelease(source);
    return image;
}

+ (UIImage *) imageImmediateLoadWithContentsOfFile:(NSString *)path
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    
    if (image == nil)
        return nil;
    CGFloat scale = [image scale];
    CGImageRef imageRef = [image CGImage];
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect rect = CGRectMake(0.0, 0.0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, imageRef);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:newImage.CGImage scale:scale orientation:image.imageOrientation];
}

+ (UIImage *) imageNamedWithoutScaling:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:image.imageOrientation];
}

#pragma mark -
#pragma mark Private

- (UIImage *) _resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL, newRect.size.width, newRect.size.height, 8, 0,
                                                colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
	
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    return newImage;
}

- (CGAffineTransform) _transformForOrientation:(CGSize)newSize
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
		default:
			break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
		default:
			break;
    }
    
    return transform;
}

@end


@interface WPhoto ()

@property (nonatomic, assign) CGImageSourceRef source;
@property (nonatomic, assign, readwrite) CGSize size;

@end

@implementation WPhoto

+ (id) photoWithFilePath:(NSString *)filePath
{
    return [[WPhoto alloc] initWithFilePath:filePath];
}

- (id) initWithFilePath:(NSString *)filePath
{
    self = [super init];
    
    if (self) {
        _source = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], NULL);
        _filePath = filePath;
        _size = CGSizeZero;
    }
    return self;
}

- (void) dealloc
{
    if (_source)
        CFRelease(_source);
    _source = NULL;
}

#pragma mark - 

- (CGSize) size
{
    if (CGSizeEqualToSize(_size, CGSizeZero) && _source) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(_source, 0, NULL);
        CFNumberRef pixelWidthRef  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        CFNumberRef pixelHeightRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        CGFloat pixelWidth = [(__bridge NSNumber *)pixelWidthRef floatValue];
        CGFloat pixelHeight = [(__bridge NSNumber *)pixelHeightRef floatValue];
        _size = CGSizeMake(pixelWidth, pixelHeight);
        CFRelease(imageProperties);
    }
    return _size;
}

- (UIImage *) resizedImageWithMaxSize:(CGFloat)size
{
    if (_source == NULL)
        return nil;
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{
        //(id)kCGImageSourceShouldCache : (id)kCFBooleanTrue,
        (id)kCGImageSourceCreateThumbnailWithTransform : (id)kCFBooleanTrue,
        (id)kCGImageSourceCreateThumbnailFromImageIfAbsent : (id)kCFBooleanTrue,
        (id)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size]};
    
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(_source, 0, options);
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    CGImageRelease(thumbnail);
    return image;
}

@end

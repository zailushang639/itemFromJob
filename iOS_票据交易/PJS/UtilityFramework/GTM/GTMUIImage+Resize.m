//
//  GTMUIImage+Resize.m
//
//  Copyright 2009 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "GTMUIImage+Resize.h"
#import "GTMDefines.h"

GTM_INLINE CGSize swapWidthAndHeight(CGSize size) {
  CGFloat  tempWidth = size.width;

  size.width  = size.height;
  size.height = tempWidth;

  return size;
}

@implementation UIImage (GTMUIImageResizeAdditions)

- (UIImage *)gtm_imageByResizingLikeSize:(CGSize)size{
    CGSize imageSize = [self size];
    if (imageSize.height < 1 || imageSize.width < 1) {
        return nil;
    }
    if (size.height < 1 || size.width < 1) {
        return nil;
    }
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGFloat targetRatio = size.width / size.height;
    CGRect projectTo = CGRectZero;
    CGSize targetSize = CGSizeZero;
    
    if (aspectRatio > targetRatio) {
        targetSize.width = imageSize.height * targetRatio;
        targetSize.height = imageSize.height;
        
        
        projectTo.origin.x = (targetSize.width -imageSize.width) / 2;
        projectTo.origin.y = 0;
        projectTo.size = imageSize;
    }else{
        targetSize.width = imageSize.width;
        targetSize.height = imageSize.width / targetRatio;
        
        projectTo.origin.x = 0;
        projectTo.origin.y = (targetSize.height -imageSize.height) / 2;;
        projectTo.size = imageSize;
    }
    
    projectTo = CGRectIntegral(projectTo);
    // There's no CGSizeIntegral, so we fake our own.
    CGRect integralRect = CGRectZero;
    integralRect.size = targetSize;
    targetSize = CGRectIntegral(integralRect).size;
    
    // Resize photo. Use UIImage drawing methods because they respect
    // UIImageOrientation as opposed to CGContextDrawImage().
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:projectTo];
    UIImage* resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedPhoto;
}


- (UIImage *)gtm_imageByResizingToSize:(CGSize)targetSize
                   preserveAspectRatio:(BOOL)preserveAspectRatio
                             trimToFit:(BOOL)trimToFit {
  CGSize imageSize = [self size];
  if (imageSize.height < 1 || imageSize.width < 1) {
    return nil;
  }
  if (targetSize.height < 1 || targetSize.width < 1) {
    return nil;
  }
  CGFloat aspectRatio = imageSize.width / imageSize.height;
  CGFloat targetAspectRatio = targetSize.width / targetSize.height;
  CGRect projectTo = CGRectZero;
  if (preserveAspectRatio) {
    if (trimToFit) {
      // Scale and clip image so that the aspect ratio is preserved and the
      // target size is filled.
      if (targetAspectRatio < aspectRatio) {
        // clip the x-axis.
        projectTo.size.width = targetSize.height * aspectRatio;
        projectTo.size.height = targetSize.height;
        projectTo.origin.x = (targetSize.width - projectTo.size.width) / 2;
        projectTo.origin.y = 0;
      } else {
        // clip the y-axis.
        projectTo.size.width = targetSize.width;
        projectTo.size.height = targetSize.width / aspectRatio;
        projectTo.origin.x = 0;
        projectTo.origin.y = (targetSize.height - projectTo.size.height) / 2;
      }
    } else {
      // Scale image to ensure it fits inside the specified targetSize.
      if (targetAspectRatio < aspectRatio) {
        // target is less wide than the original.
        projectTo.size.width = targetSize.width;
        projectTo.size.height = projectTo.size.width / aspectRatio;
        targetSize = projectTo.size;
      } else {
        // target is wider than the original.
        projectTo.size.height = targetSize.height;
        projectTo.size.width = projectTo.size.height * aspectRatio;
        targetSize = projectTo.size;
      }
    } // if (clip)
  } else {
    // Don't preserve the aspect ratio.
    projectTo.size = targetSize;
  }

  projectTo = CGRectIntegral(projectTo);
  // There's no CGSizeIntegral, so we fake our own.
  CGRect integralRect = CGRectZero;
  integralRect.size = targetSize;
  targetSize = CGRectIntegral(integralRect).size;

  // Resize photo. Use UIImage drawing methods because they respect
  // UIImageOrientation as opposed to CGContextDrawImage().
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, [[UIScreen mainScreen] scale]);
//  UIGraphicsBeginImageContext(targetSize);
  [self drawInRect:projectTo];
  UIImage* resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resizedPhoto;
}

// Based on code by Trevor Harmon:
// http://vocaro.com/trevor/blog/wp-content/uploads/2009/10/UIImage+Resize.h
// http://vocaro.com/trevor/blog/wp-content/uploads/2009/10/UIImage+Resize.m
- (UIImage *)gtm_imageByRotating:(UIImageOrientation)orientation {
  CGRect bounds = CGRectZero;
  CGRect rect = CGRectZero;
  CGAffineTransform transform = CGAffineTransformIdentity;

  bounds.size = [self size];
  rect.size = [self size];

  switch (orientation) {
    case UIImageOrientationUp:
      return [UIImage imageWithCGImage:[self CGImage]];

    case UIImageOrientationUpMirrored:
      transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;

    case UIImageOrientationDown:
      transform = CGAffineTransformMakeTranslation(rect.size.width,
                                                   rect.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;

    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformMakeTranslation(0.0, rect.size.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;

    case UIImageOrientationLeft:
      bounds.size = swapWidthAndHeight(bounds.size);
      transform = CGAffineTransformMakeTranslation(0.0, rect.size.width);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;

    case UIImageOrientationLeftMirrored:
      bounds.size = swapWidthAndHeight(bounds.size);
      transform = CGAffineTransformMakeTranslation(rect.size.height,
                                                   rect.size.width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;

    case UIImageOrientationRight:
      bounds.size = swapWidthAndHeight(bounds.size);
      transform = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;

    case UIImageOrientationRightMirrored:
      bounds.size = swapWidthAndHeight(bounds.size);
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;

    default:
      _GTMDevAssert(false, @"Invalid orientation %ld", (long)orientation);
      return nil;
  }

  UIGraphicsBeginImageContext(bounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  switch (orientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      CGContextScaleCTM(context, -1.0, 1.0);
      CGContextTranslateCTM(context, -rect.size.height, 0.0);
      break;

    default:
      CGContextScaleCTM(context, 1.0, -1.0);
      CGContextTranslateCTM(context, 0.0, -rect.size.height);
      break;
  }

  CGContextConcatCTM(context, transform);
  CGContextDrawImage(context, rect, [self CGImage]);

  UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return rotatedImage;
}

//返回渐变色背景的图片
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur {
    UIImage *image = self;
    CGColorRef cgColor = [bgColor CGColor];
    CGColorRef cgShadowColor = [shadowColor CGColor];
    CGFloat components[16] = {1,1,1,alpha1,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3};
    CGFloat locations[4] = {0,0.5,0.6,1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    //contextRect.size = CGSizeMake([image size].width+5,[image size].height+5);
    // Retrieve source image and begin image context
    UIImage *itemImage = image;
    CGSize itemImageSize = [itemImage size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);
    UIGraphicsBeginImageContext(contextRect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);
    // Fill and end the transparency layer
    CGContextSetFillColorWithColor(c, cgColor);
    contextRect.size.height = -contextRect.size.height;
    CGContextFillRect(c, contextRect);
    CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width*1.0/4.0,contextRect.size.height),0);
    CGContextEndTransparencyLayer(c);
    //CGPointMake(contextRect.size.width*3.0/4.0, 0)
    // Set selected image and end context
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(colorGradient);
    return resultImage;
}
+ (UIImage*) drawGradientInRect:(CGSize)size withColors:(NSArray*)colors {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) [ar addObject:(id)c.CGColor];
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    //     CGContextClipToRect(context, rect);
    
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(0.0, size.height);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    // Clean up
//    CGColorSpaceRelease(colorSpace); // Necessary?
    UIGraphicsEndImageContext(); // Clean up
    return image;
}

+ (UIImage *)radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius {
    // Initialise
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    
    // Create the gradient's colours
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { start,start,start, 1.0,  // Start color
        end,end,end, 1.0 }; // End color
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Normalise the 0-1 ranged inputs to the width of the image
    CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
    float myRadius = MIN(size.width, size.height) * radius;
    
    // Draw it!
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                 0, myCentrePoint, myRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up
    CGColorSpaceRelease(myColorspace); // Necessary?
    CGGradientRelease(myGradient); // Necessary?
    UIGraphicsEndImageContext(); // Clean up
    return image;
}
@end

#import "IrregularShapedButton.h"
#import "UIImage-Alpha.h"

@implementation IrregularShapedButton

@synthesize lastPoint;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint([self bounds], point))
		return nil;
	else 
    {

        UIImage *displayedImage = [self imageForState:[self state]];
        if (displayedImage == nil) // No image found, try for background image
            displayedImage = [self backgroundImageForState:[self state]];
        if (displayedImage == nil) // No image could be found, fall back to 
            return self;
      
      //处理iphone4的@2x图,在非Retina屏幕上显示,出现点击点和实际像素点无法对应的情况.
      int pointScale = 1;
      //NSLog(@"%@",NSStringFromCGSize(self.frame.size));
      //NSLog(@"%@",NSStringFromCGSize(displayedImage.size));
      //NSLog(@"%f",displayedImage.scale);
      if ([[UIScreen mainScreen] scale] == 1 ) {
              if (displayedImage.scale == 2) {
                  pointScale = 2;
              }

      }
        BOOL isTransparent = [displayedImage isPointTransparent:point pointScale:pointScale];
        ////NSLog(@"@@@@@@@@@@@@ POINT %@",NSStringFromCGPoint(point));
        if (isTransparent)
            return nil;

	}

    return self;
}
@end

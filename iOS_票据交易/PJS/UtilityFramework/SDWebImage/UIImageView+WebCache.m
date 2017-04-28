/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url){
//        //wanglun
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]init];
//        [activityView setFrame:CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10,20,20)];
//        [activityView startAnimating];
//        activityView.tag = 999;
//        [self addSubview:activityView];
//        [activityView release];
//        
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    //wanglun
    self.image = image;  
//    UIActivityIndicatorView *_activityView = (UIActivityIndicatorView *)[self viewWithTag:999];
//    if (_activityView) {
//        [_activityView stopAnimating];
//        [_activityView removeFromSuperview];
//    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    //wanglun
//    UIActivityIndicatorView *_activityView = (UIActivityIndicatorView *)[self viewWithTag:999];
//    if (_activityView) {
//        [_activityView stopAnimating];
//        [_activityView removeFromSuperview];
//    }
}

@end

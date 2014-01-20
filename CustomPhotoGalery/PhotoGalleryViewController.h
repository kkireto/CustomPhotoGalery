//
//  PhotoGalleryViewController.h
//  CustomPhotoGalery
//
//  Created by Kireto on 1/20/14.
//  Copyright (c) 2014 No Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGalleryViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,strong) IBOutlet UILabel *photoTitleLabel;
@property(nonatomic,strong) IBOutlet UILabel *pageNumberLabel;
@property(nonatomic,strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic,strong) IBOutlet UIScrollView *currScrollView;
@property(nonatomic,strong) IBOutlet UIImageView *currImageView;
@property(nonatomic,strong) IBOutlet UIImageView *prevImageView;
@property(nonatomic,strong) IBOutlet UIImageView *nextImageView;

@end

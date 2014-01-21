//
//  PhotoGalleryViewController.m
//  CustomPhotoGalery
//
//  Created by Kireto on 1/20/14.
//  Copyright (c) 2014 No Name. All rights reserved.
//

#import "PhotoGalleryViewController.h"

@interface PhotoGalleryViewController ()

@property(nonatomic,strong)NSMutableArray *photosArray;
@property(nonatomic,assign)NSInteger currentPageIndex;
@property(nonatomic,assign)NSInteger previousPageIndex;
@property(nonatomic,assign)NSInteger nextPageIndex;
@property(nonatomic,assign)BOOL isNotFirstAppear;

@end

@implementation PhotoGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _isNotFirstAppear = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (_isNotFirstAppear) {
        
    }
    else {
        [self setupView];
        _isNotFirstAppear = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setScrollViewFrames];
}

#pragma mark - setup view
- (void)setupView {
    
    [self setScrollViewFrames];
    
#warning set photosArray here
#warning add images in resources or what ever source is going to be used
    _photosArray = [[NSMutableArray alloc] initWithObjects:@"image1", @"image2", @"image3", @"image3", nil];
    
    [self findCurrentIndex];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.delegate = self;
    [_mainScrollView addGestureRecognizer:recognizer];
}

- (void)setScrollViewFrames {
    
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width*3, 1.0);
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width, 0.0) animated:NO];
    
    _prevImageView.frame = CGRectMake(0.0, 0.0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height);
    _prevImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _currScrollView.frame = CGRectMake(_mainScrollView.frame.size.width, 0.0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height);
    _currScrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _nextImageView.frame = CGRectMake(2*_mainScrollView.frame.size.width, 0.0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height);
    _nextImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - set current index
- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentPageIndex = currentIndex;
    
    NSString *imageName = [_photosArray objectAtIndex:_currentPageIndex];
    _pageNumberLabel.text = [NSString stringWithFormat:@"%u of %d", _currentPageIndex + 1, [_photosArray count]];
    _photoTitleLabel.text = imageName;
    
    if([_photosArray count]) {
        self.view.userInteractionEnabled = NO;
        
#warning prefferably only thumbnail for prevImageView
        NSString *prevImageName = [_photosArray objectAtIndex:[self relativeIndex:-1]];
        [_prevImageView setImage:[UIImage imageNamed:prevImageName]];
        
        NSString *currImageName = [_photosArray objectAtIndex:_currentPageIndex];
        [_currImageView setImage:[UIImage imageNamed:currImageName]];
        
#warning prefferably only thumbnail for nextImageView
        NSString *nextImageName = [_photosArray objectAtIndex:[self relativeIndex:1]];
        [_nextImageView setImage:[UIImage imageNamed:nextImageName]];
        
        self.view.userInteractionEnabled = YES;
    }
}

- (NSUInteger)relativeIndex:(NSUInteger)inIndex {
    
    NSUInteger retInt = _currentPageIndex + inIndex;
    if (retInt == -1) {
        retInt = [_photosArray count] - 1;
    }
    else if (retInt == [_photosArray count]) {
        retInt = 0;
    }
    return retInt;
}

- (void)findCurrentIndex {
    
#warning in this case the first object of the list is selected - but can be initialized with random index from photosArray
    NSUInteger currentIndex = 0;
    [self setCurrentIndex:currentIndex];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;  {
    //incase we are zooming the center image view parent
    if (_currScrollView == scrollView){
        return _currImageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    _previousPageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //in case we are still in same page, ignore the swipe action
    if(_previousPageIndex == page) return;
    
    if(sender.contentOffset.x >= sender.frame.size.width) {
        //swipe left, go to next image
        [self setCurrentIndex:[self relativeIndex:1]];
        
        // center the scrollview to the center UIImageView
        [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width, 0.0)  animated:NO];
	}
	else if(sender.contentOffset.x < sender.frame.size.width) {
        //swipe right, go to previous image
        [self setCurrentIndex:[self relativeIndex:-1]];
        
        // center the scrollview to the center UIImageView
        [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width, 0.0)  animated:NO];
	}
    
    _currScrollView.zoomScale = 1.0;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    float scale = _currScrollView.zoomScale;
    scale += 1.0;
    if (scale > 2.0) scale = 1.0;
    [_currScrollView setZoomScale:scale animated:YES];
}

@end

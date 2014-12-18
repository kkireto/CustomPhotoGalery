/*
 * Copyright 2014 Kreto. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation and/or
 *    other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY Kireto “AS IS” WITHOUT ANY WARRANTIES WHATSOEVER.
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF NON INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE HEREBY DISCLAIMED. IN NO EVENT SHALL Kireto OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those of
 * the authors and should not be interpreted as representing official policies,
 * either expressed or implied, of Kireto.
 */

#import "GalleryViewController.h"

@interface GalleryViewController ()

@property (nonatomic,weak) IBOutlet UILabel *photoTitleLabel;
@property (nonatomic,weak) IBOutlet UILabel *pageNumberLabel;
@property (nonatomic,strong) UIPageViewController *pageController;

@property (nonatomic,strong) NSMutableArray *photosArray;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,assign) NSInteger provisionalPageIndex;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.pageNumberLabel];
    [self.view bringSubviewToFront:self.photoTitleLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - setup view
- (void)setupView {
    
#warning set photosArray here
#warning add images in resources or what ever source is going to be used
    self.photosArray = [[NSMutableArray alloc] initWithObjects:@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", nil];
    [self findCurrentIndex];
    [self setupPageController];
}

- (void)setupPageController {
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    PhotoViewController *initialViewController = [self viewControllerAtIndex:self.currentPageIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.pageController.view setFrame:CGRectMake(-5.0, 0.0, self.view.frame.size.width + 10.0, self.view.frame.size.height)];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

#pragma mark - set current index
- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    self.currentPageIndex = currentIndex;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%i of %i", (int)self.currentPageIndex + 1, (int)[self.photosArray count]];
    self.photoTitleLabel.text = [self.photosArray objectAtIndex:self.currentPageIndex];
    [self.view bringSubviewToFront:self.pageNumberLabel];
    [self.view bringSubviewToFront:self.photoTitleLabel];
}

- (void)findCurrentIndex {
    
#warning in this case the first object of the list is selected - but can be initialized with random index from photosArray
    NSUInteger currentIndex = 0;
    [self setCurrentIndex:currentIndex];
}

- (PhotoViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    PhotoViewController *childViewController = [[PhotoViewController alloc] init];
    childViewController.delegate = self;
    childViewController.photoIndex = index;
    childViewController.photoCount = [self.photosArray count];
    childViewController.thumbName = [self.photosArray objectAtIndex:index];
    childViewController.photoName = [self.photosArray objectAtIndex:index];
    
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PhotoViewController *)viewController photoIndex];
    
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PhotoViewController *)viewController photoIndex];
    
    index++;
    if (index == [self.photosArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - handleSingleTap (GaleryItemProtocol)
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    CGFloat alplha = 1.0;
    if (self.photoTitleLabel.alpha == 1.0) {
        alplha = 0.0;
    }
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [self.photoTitleLabel setAlpha:alplha];
                         [self.pageNumberLabel setAlpha:alplha];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                         self.view.userInteractionEnabled = YES;
                     }];
}

- (void)photoIndexChanged:(NSInteger)pageIndex {
    [self setCurrentIndex:pageIndex];
}

@end

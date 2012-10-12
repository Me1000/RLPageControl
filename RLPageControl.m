//
//  RLPageControl.m
//  Siklus
//
//  Created by Randy Luecke on 4/27/12.
//  Copyright (c) 2012 Randy Luecke. All rights reserved.
//

#import "RLPageControl.h"

// FIX ME: make this a property I guess...
#define SIZE_OF_INDICATOR 10.0

@interface RLPageControl ()
{
@private

    NSUInteger _currentPage;
    NSUInteger _numberOfPages;

    BOOL _hidesForSinglePage;

    RLDrawIndicatorBlock _indicatorDrawBlock;
}

- (void)_sharedInit;
- (void)_userDidTap:(id)sender;
- (void)_userDidSwipeRight:(id)sender;
- (void)_userDidSwipeLeft:(id)sender;

@end

@implementation RLPageControl

- (void)_sharedInit
{
    // Initialization code
    self.currentPage = 0;
    self.numberOfPages = 0;
    self.hidesForSinglePage = NO;
    self.opaque = NO;

    [self setIndicatorDrawBlock:^(CGContextRef context, NSUInteger indicatorIndex, BOOL isHighlighted){
        if (isHighlighted) {
            UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 8, 8)];
            [[UIColor whiteColor] setFill];
            [ovalPath fill];
        } else {
            UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 8, 8)];
            [[UIColor colorWithWhite:1 alpha:0.6] setFill];
            [ovalPath fill];
        }
    }];


    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userDidTap:)];
    UISwipeGestureRecognizer *leftSwipeGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_userDidSwipeLeft:)];
    UISwipeGestureRecognizer *rightSwipeGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_userDidSwipeRight:)];

    [leftSwipeGuesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [rightSwipeGuesture setDirection:UISwipeGestureRecognizerDirectionRight];

    [self addGestureRecognizer:tapGuesture];
    [self addGestureRecognizer:leftSwipeGuesture];
    [self addGestureRecognizer:rightSwipeGuesture];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
        [self _sharedInit];

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
        [self _sharedInit];

    return self;
}

@synthesize currentPage = _currentPage;
@synthesize numberOfPages = _numberOfPages;
@synthesize hidesForSinglePage = _hidesForSinglePage;

- (void)setCurrentPage:(NSUInteger)currentPage
{
    if (currentPage == _currentPage)
        return;

    _currentPage = currentPage;
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages
{
    if (numberOfPages == _numberOfPages)
        return;

    _numberOfPages = numberOfPages;
    [self setNeedsDisplay];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    if (hidesForSinglePage == _hidesForSinglePage)
        return;

    _hidesForSinglePage = hidesForSinglePage;
    [self setNeedsDisplay];
}

- (CGSize)sizeForNumberOfPages:(NSUInteger)pageCount
{
    return CGSizeMake(SIZE_OF_INDICATOR * pageCount, SIZE_OF_INDICATOR);
}


- (void)setIndicatorDrawBlock:(RLDrawIndicatorBlock)aBlock
{
    _indicatorDrawBlock = [aBlock copy];
    [self setNeedsDisplay];
}

- (void)_userDidTap:(id)sender
{
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGPoint touchLocation = [sender locationInView:self];

    if (touchLocation.x < midX)
        [self setCurrentPage:MAX(self.currentPage - 1, 0)];
    else
        [self setCurrentPage:MIN(self.currentPage + 1, self.numberOfPages - 1)];

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)_userDidSwipeLeft:(id)sender
{
    [self setCurrentPage:MAX(self.currentPage - 1, 0)];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)_userDidSwipeRight:(id)sender
{
    [self setCurrentPage:MIN(self.currentPage + 1, self.numberOfPages - 1)];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect
{
    if (self.hidesForSinglePage && self.numberOfPages == 1)
        return;

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat startDrawX = CGRectGetMidX(self.bounds) - size.width / 2;

    CGContextTranslateCTM(context, startDrawX, 0);

    for (int i = 0; i < self.numberOfPages; i++)
    {
        if (i > 0)
            CGContextTranslateCTM(context, SIZE_OF_INDICATOR, 0);

        CGContextSaveGState(context);
        _indicatorDrawBlock(context, i, self.currentPage == i);
        CGContextRestoreGState(context);
    }
}


@end

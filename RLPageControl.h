//
//  RLPageControl.h
//  Siklus
//
//  Created by Randy Luecke on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RLDrawIndicatorBlock)(CGContextRef);

@interface RLPageControl : UIControl 

// default is 0
@property(nonatomic) NSUInteger numberOfPages;

// default is 0. value pinned to 0..numberOfPages-1
@property(nonatomic) NSUInteger currentPage;

// hide the the indicator if there is only one page. default is NO
@property(nonatomic) BOOL hidesForSinglePage;

// returns minimum size required to display dots for given page count. can be used to size control if page count could change
- (CGSize)sizeForNumberOfPages:(NSUInteger)pageCount;


// Set the block of code that draws the indicator
// Block takes in one argument CGContextRef: the current context.
- (void)setDrawingBlockForHighlightedIndicator:(RLDrawIndicatorBlock)aBlock;
- (void)setDrawingBlockForNormalIndicator:(RLDrawIndicatorBlock)aBlock;

@end
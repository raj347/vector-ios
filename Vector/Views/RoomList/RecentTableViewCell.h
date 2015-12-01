/*
 Copyright 2015 OpenMarket Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <MatrixKit/MatrixKit.h>

#import "RecentCellScrollView.h"

@class RecentTableViewCell;

/**
 `RecentTableViewCell` delegate.
 */
@protocol RecentTableViewCellDelegate <NSObject>

/**
 Tells the delegate that the cell enter / leaves in the edition mode
 
 @param recentTableViewCell the `RecentTableViewCell` instance.
 @param isInEditionMode YES if the cell enters in edition mode. NO if it leaves the edition mode
 */
- (void)recentTableViewCell:(RecentTableViewCell*)recentTableViewCell isInEditionMode:(BOOL)isInEditionMode;

/**
 Tells the delegate that the user taps on a cell extra button.
 
 @param recentTableViewCell the `RecentTableViewCell` instance.
 @param index the index in the imagesList list provided with initSlideActions
 */
- (void)recentTableViewCell:(RecentTableViewCell*)recentTableViewCell didSelect:(NSUInteger)index;

@end

/**
 `RecentTableViewCell` instances display a room in the context of the recents list.
 */
@interface RecentTableViewCell : MXKRecentTableViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bingIndicator;
@property (weak, nonatomic) IBOutlet MXKImageView *roomAvatar;

@property (weak, nonatomic) IBOutlet RecentCellScrollView *recentScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *recentContentView;

@property (nonatomic) id<RecentTableViewCellDelegate> recentTableViewCellDelegate;
@property (nonatomic) BOOL editMode;

// init with image list
- (void)initSlideActions:(NSArray*)imagesList;

@end

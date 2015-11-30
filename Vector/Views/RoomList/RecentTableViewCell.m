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

#import "RecentTableViewCell.h"

@interface RecentTableViewCell()
{
    int nbrExtras;
    
    NSMutableArray* imageViewsList;
}
@end

@implementation RecentTableViewCell

#define RECENT_CELL_HEIGHT 74

#pragma mark - Class methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Round image view
    [_roomAvatar.layer setCornerRadius:_roomAvatar.frame.size.width / 2];
    _roomAvatar.clipsToBounds = YES;
    
    nbrExtras = 3;


    // hide the scroll indicator
    self.recentScrollView.showsHorizontalScrollIndicator = NO;
    self.recentScrollView.showsVerticalScrollIndicator = NO;
}

- (void)render:(MXKCellData *)cellData
{
    id<MXKRecentCellDataStoring> roomCellData = (id<MXKRecentCellDataStoring>)cellData;
    if (roomCellData)
    {
        // Report computed values as is
        self.roomTitle.text = roomCellData.roomDisplayname;
        self.lastEventDate.text = roomCellData.lastEventDate;
        
        // FIXME handle room avatar
        self.roomAvatar.image = nil;
        self.roomAvatar.backgroundColor = [UIColor lightGrayColor];
        
        // Manage lastEventAttributedTextMessage optional property
        if ([roomCellData respondsToSelector:@selector(lastEventAttributedTextMessage)])
        {
            self.lastEventDescription.attributedText = roomCellData.lastEventAttributedTextMessage;
        }
        else
        {
            self.lastEventDescription.text = roomCellData.lastEventTextMessage;
        }
        
        // Notify unreads and bing
        self.bingIndicator.hidden = YES;
        
        if (roomCellData.unreadCount)
        {
            if (0 < roomCellData.unreadBingCount)
            {
                self.bingIndicator.hidden = NO;
                self.bingIndicator.backgroundColor = roomCellData.recentsDataSource.eventFormatter.bingTextColor;
            }
            self.roomTitle.font = [UIFont boldSystemFontOfSize:19];
        }
        else
        {
            self.roomTitle.font = [UIFont systemFontOfSize:19];
        }
    }
    else
    {
        self.lastEventDescription.text = @"";
    }
    
    if (!imageViewsList && (nbrExtras > 0))
    {
        CGFloat startX = self.recentContentView.frame.size.width;
        
        // update the scrollview contentsize
        CGSize contentSize = self.recentScrollView.contentSize;
        contentSize.width = startX + (RECENT_CELL_HEIGHT * nbrExtras);
        self.recentScrollView.contentSize = contentSize;
        
        
        for(int i = 0; i < nbrExtras; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, 0, RECENT_CELL_HEIGHT, RECENT_CELL_HEIGHT)];
            [self.scrollContentView addSubview:imageView];
            
            startX += RECENT_CELL_HEIGHT;
            
            if (i == 0)
            {
                [imageView setBackgroundColor:[UIColor blueColor]];
            }
            else if (i == 1)
            {
                [imageView setBackgroundColor:[UIColor redColor]];
            }
            else if (i == 2)
            {
                [imageView setBackgroundColor:[UIColor yellowColor]];
            }
        }
    }
    
    self.recentScrollView.delegate = self;
}

+ (CGFloat)heightForCellData:(MXKCellData *)cellData withMaximumWidth:(CGFloat)maxWidth
{
    // The height is fixed
    return RECENT_CELL_HEIGHT;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.recentScrollView)
    {
        CGPoint offset, boundedOffset;
        
        offset = boundedOffset = self.recentScrollView.contentOffset;
        
        if (boundedOffset.x < 0)
        {
            boundedOffset.x = 0;
        }
        else if (boundedOffset.x > (nbrExtras * RECENT_CELL_HEIGHT))
        {
            boundedOffset.x = (nbrExtras * RECENT_CELL_HEIGHT);
        }
        
        if (!CGPointEqualToPoint(offset, boundedOffset))
        {
            [self.recentScrollView setContentOffset:boundedOffset animated:NO];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)point
{
    CGFloat ceil = (nbrExtras * RECENT_CELL_HEIGHT) / 2.0;
    CGFloat offsetX = point->x;
    
    if (offsetX > 0)
    {
       if (offsetX < ceil)
       {
           offsetX = 0;
       }
       else if (offsetX >= ceil)
       {
           offsetX = (nbrExtras * RECENT_CELL_HEIGHT);
       }
    }

    if (offsetX != point->x)
    {
        point->x = offsetX;
    }
}


@end

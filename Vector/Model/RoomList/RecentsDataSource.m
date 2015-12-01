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

#import "RecentsDataSource.h"

#import "EventFormatter.h"

@implementation RecentsDataSource

static NSMutableArray* imagesList = nil;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Reset default view classes
        [self registerCellViewClass:RecentTableViewCell.class forCellIdentifier:kMXKRecentCellIdentifier];
        
        // Replace event formatter
        self.eventFormatter = [[EventFormatter alloc] initWithMatrixSession:self.mxSession];
        
        if (!imagesList)
        {
            imagesList = [[NSMutableArray alloc] init];
            
            // mute
            [imagesList addObject:[NSNull null]];
            // favorites
            [imagesList addObject:[NSNull null]];
            // low priority rooms
            [imagesList addObject:[NSNull null]];
            // remove
            [imagesList addObject:[NSNull null]];
        }
    }
    return self;
}

#pragma mark - UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RecentTableViewCell class]])
    {
        RecentTableViewCell* recentTableViewCell = (RecentTableViewCell*)cell;
        
        [recentTableViewCell initSlideActions:imagesList];
        recentTableViewCell.recentTableViewCellDelegate = self;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // the deletion will be managed by swiped icons.
    return NO;
}

#pragma mark - RecentTableViewCellDelegate methods

- (void)recentTableViewCell:(RecentTableViewCell*)recentTableViewCell isInEditionMode:(BOOL)isInEditionMode
{
    NSLog(@"recentTableViewCell isInEditionMode");
}

- (void)recentTableViewCell:(RecentTableViewCell*)recentTableViewCell didSelect:(NSUInteger)index
{
    NSLog(@"recentTableViewCell didSelect %ld", index);
}

#pragma mark - Override MXKDataSource

- (void)destroy
{
    [super destroy];
}

@end

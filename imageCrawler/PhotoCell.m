//
//  PhotoCell.m
//  imageCrawler
//
//  Created by Marius Horga on 2/28/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
    }    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
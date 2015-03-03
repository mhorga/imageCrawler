//
//  PageCrawler.h
//  imageCrawler
//
//  Created by Marius Horga on 3/3/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageCrawler : NSObject

@property NSMutableArray *links;
@property (nonatomic, copy) void (^onCompletion)();

+(instancetype)sharedInstance;
-(void)loadURL:(NSURL *)link;

@end

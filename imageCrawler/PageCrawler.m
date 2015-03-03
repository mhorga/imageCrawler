//
//  PageCrawler.m
//  imageCrawler
//
//  Created by Marius Horga on 3/3/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import "PageCrawler.h"

@interface PageCrawler()

@end

static PageCrawler *_instance;

@implementation PageCrawler

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PageCrawler alloc] init];
    });
    
    return _instance;
}

-(void)loadURL:(NSURL *)URL {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *page = [NSString stringWithContentsOfURL:URL encoding:1 error:nil];
        NSString *startLine = @"<img";
        NSString *endLine = @">";
        NSString *startLink = @"src=\"";
        NSString *endLink = @"\"";
        while ([page containsString:startLine]) {
            NSString *line = [self scanString:page startTag:startLine endTag:endLine];
            if ([line containsString:startLink]) {
                NSString *link = [self scanString:line startTag:startLink endTag:endLink];
                page = [self scanString:page startTag:link endTag:page];
                [self.links addObject:link];
            }
        }
        if (self.onCompletion) {
            self.onCompletion();
        }
    });
}

- (NSString *)scanString:(NSString *)string startTag:(NSString *)startTag endTag:(NSString *)endTag {
    NSString* scanString = @"";
    if (string.length > 0) {
        NSScanner* scanner = [[NSScanner alloc] initWithString:string];
        if (scanner) {
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&scanString];
        }
    }
    return scanString;
}

@end

//
//  ViewController.m
//  imageCrawler
//
//  Created by Marius Horga on 2/28/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

/*
 Requirements:  1. Option to enter a website URL and a button to submit the search.
                2. Option to enter the number of levels to download images from.
                3. Upon submitting a search request, the app will start downloading all images (JPG, PNG) on that page and all sub-pages up to the configured level
                4. Display of all downloaded images in a UITableView or UICollectionView (latter preferred)
                5. Smooth scrolling performance throughout the search
 
 Notes: 1. You are free to use any 3rd party libraries (e.g. AFNetworking or AlamoFire).
        2. You may also want to google the regular expression to find links inside of HTML code (you pretty much download the page contents and then search for links and images in it).
        3. You will need to make use of recursion. (a function calls itself over and over until it is done).
 */

#import "ViewController.h"
#import "PhotoCell.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray *images;

@end


@implementation ViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(124, 124);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"Image crawler";
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor brownColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
    //return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *URL = [NSURL URLWithString:@"https://www.bloc.io/about"];
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
                [self.images addObject:link];
                NSURL *url = [[NSURL alloc] initWithString:link];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                });
            }
        }
    });
    return cell;
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

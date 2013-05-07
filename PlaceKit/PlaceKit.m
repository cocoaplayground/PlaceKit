//
//  PlaceKit.m
//  PlaceKitDemo
//
//  Created by Lars Anderson on 5/5/13.
//  Copyright (c) 2013 theonlylars. All rights reserved.
//

#import "PlaceKit.h"

#import "AFNetworking.h"

NSString * const kPLKPlaceKittenImageURLString = @"http://placekitten.com/%1.0f/%1.0f";
NSString * const kPLKPlaceKittenGreyscaleImageURLString = @"http://placekitten.com/g/%1.0f/%1.0f";
NSString * const kPLKPlaceBaconImageURLString = @"http://baconmockup.com/%1.0f/%1.0f";
NSString * const kPLKPlaceHolderImageURLString = @"http://placehold.it/%1.0fx%1.0f";
NSString * const kPLKPlaceRandomImageURLString = @"http://lorempixel.com/%1.0f/%1.0f";
NSString * const kPLKPlaceRandomGreyscaleImageURLString = @"http://lorempixel.com/%1.0f/%1.0f";

@implementation PlaceKit

+ (AFHTTPClient *)httpClient{
    static AFHTTPClient *__httpClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        NSURL *url = [NSURL URLWithString:@""];
        __httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [__httpClient registerHTTPOperationClass:[AFImageRequestOperation class]];
    });
    return __httpClient;
}

#pragma mark - Images
+ (void)placeKittenImageWithSize:(CGSize)size
                      completion:(void(^)(UIImage *kittenImage))completionBlock{
    [self requestImageWithPath:kPLKPlaceKittenImageURLString
                          size:size
                    completion:completionBlock];
}

+ (void)placeKittenGreyImageWithSize:(CGSize)size
                          completion:(void(^)(UIImage *greyKittenImage))completionBlock{
    [self requestImageWithPath:kPLKPlaceKittenGreyscaleImageURLString
                          size:size
                    completion:completionBlock];
}

+ (void)placeBaconImageWithSize:(CGSize)size
                     completion:(void(^)(UIImage *baconImage))completionBlock{
    [self requestImageWithPath:kPLKPlaceBaconImageURLString
                          size:size
                    completion:completionBlock];
}

+ (void)placeHolderImageWithSize:(CGSize)size
                      completion:(void(^)(UIImage *placeholderImage))completionBlock{
    [self requestImageWithPath:kPLKPlaceHolderImageURLString
                          size:size
                    completion:completionBlock];
}

//http://lorempixel.com/400/200 to get a random picture of 400 x 200 pixels
//http://lorempixel.com/g/400/200 to get a random gray picture of 400 x 200 pixels
//http://lorempixel.com/400/200/sports to get a random picture of the sports category
//http://lorempixel.com/400/200/sports/1 to get picture no. 1/10 from the sports category
//http://lorempixel.com/400/200/sports/Dummy-Text... with a custom text on the random Picture
//http://lorempixel.com/400/200/sports/1/Dummy-Text

+ (void)placeRandomImageWithSize:(CGSize)size
                        category:(NSString *)category
                      completion:(void(^)(UIImage *randomImage))completionBlock{
    [self requestImageWithPath:[kPLKPlaceRandomImageURLString stringByAppendingPathComponent:category]
                          size:size
                    completion:completionBlock];
}

+ (void)placeRandomGreyscaleImageWithSize:(CGSize)size
                                 category:(NSString *)category
                               completion:(void(^)(UIImage *randomImage))completionBlock{
    [self requestImageWithPath:[kPLKPlaceRandomGreyscaleImageURLString stringByAppendingPathComponent:category]
                          size:size
                    completion:completionBlock];
}

+ (void)placeRandomImageWithSize:(CGSize)size
                      completion:(void(^)(UIImage *randomImage))completionBlock{
    [self requestImageWithPath:kPLKPlaceRandomImageURLString
                          size:size
                    completion:completionBlock];
}

+ (void)placeRandomGreyscaleImageWithSize:(CGSize)size
                               completion:(void(^)(UIImage *randomImage))completionBlock{
    [self requestImageWithPath:kPLKPlaceRandomGreyscaleImageURLString
                          size:size
                    completion:completionBlock];
}

+ (void)requestImageWithPath:(NSString *)path size:(CGSize)size completion:(void(^)(UIImage *image))completionBlock{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    [[self httpClient]
     getPath:[NSString stringWithFormat:path, size.width*screenScale, size.height*screenScale]
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         UIImage *image = [UIImage imageWithData:responseObject scale:screenScale];
         completionBlock(image);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionBlock(nil);
     }];
}

@end

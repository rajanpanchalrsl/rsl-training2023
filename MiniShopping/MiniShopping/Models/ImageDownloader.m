#import "ImageDownloader.h"

@implementation ImageDownloader

- (void)downloadImageWithURL:(NSString *)urlString completion:(void (^)(UIImage * _Nonnull, NSError * _Nonnull))completion {
    NSURL *imageURL = [[NSURL alloc] initWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = nil;
        if (data) {
            image = [UIImage imageWithData:data];
        }
        completion(image, error);
    }];
    [task resume];
}

@end

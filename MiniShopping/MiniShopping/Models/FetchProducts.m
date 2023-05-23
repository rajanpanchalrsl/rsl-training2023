#import "FetchProducts.h"
#import "ImageDownloader.h"

@implementation FetchProducts

- (void)fetchData {
    NSString *urlString = @"https://dummyjson.com/products";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"URL Session Error :  %@", error);
            return;
        }
        if (!data) {
            NSLog(@"Data Error :  %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON Error : %@", jsonError);
            return;
        }
        NSArray *productsArray = jsonData[@"products"];
        for (NSDictionary *productDict in productsArray) {
            Product *product = [[Product alloc] initWithDictionary:productDict];
            NSString *thumbnailURLString = productDict[@"thumbnail"];
            ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
            [imageDownloader downloadImageWithURL:thumbnailURLString completion:^(UIImage *image, NSError *error) {
                if (error) {
                    NSLog(@"Image Download Error %@", error);
                    return;
                }
                [product setThumbnailImage:image];
            }];
            [self.delegate addToProductsArray:product];
        }
    }];
    [task resume];
}

@end

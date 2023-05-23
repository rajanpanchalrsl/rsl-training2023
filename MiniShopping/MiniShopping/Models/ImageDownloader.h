#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ImageDownloader : NSObject

- (void)downloadImageWithURL:(NSString *)imageURL completion:(void (^)(UIImage *image, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END

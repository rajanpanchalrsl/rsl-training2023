#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSObject

@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) UIImage *thumbnail;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)setThumbnailImage:(UIImage *)thumbnailImage;

@end

NS_ASSUME_NONNULL_END

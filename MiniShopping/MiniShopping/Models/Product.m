#import "Product.h"

@interface Product()

@end

@implementation Product

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _productId = [dictionary[@"id"] integerValue];
        _title = dictionary[@"title"];
        _shortDescription = dictionary[@"description"];
        _price = [dictionary[@"price"] integerValue];
        _rating = [dictionary[@"rating"] floatValue];
        _category = dictionary[@"category"];
        _thumbnail = [UIImage imageNamed:@"thumb"];
    }
    return self;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnail = thumbnailImage;
}
@end

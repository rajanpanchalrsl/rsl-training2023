#import <Foundation/Foundation.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FetchProductsDelegate <NSObject>

- (void)addToProductsArray:(Product *)product;

@end

@interface FetchProducts : NSObject

@property (nonatomic,weak) id<FetchProductsDelegate> delegate;

- (void)fetchData;

@end

NS_ASSUME_NONNULL_END

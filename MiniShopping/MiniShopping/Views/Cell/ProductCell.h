#import <UIKit/UIKit.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductCell : UICollectionViewCell

- (void)configure:(Product *)product;

@end

NS_ASSUME_NONNULL_END

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProductViewDelegate <NSObject>

- (void)sortByPrice;
- (void)sortByCategory;

@end

@interface ProductsView : UIView

@property (nonatomic,weak) id<ProductViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *productsGridView;

@end

NS_ASSUME_NONNULL_END

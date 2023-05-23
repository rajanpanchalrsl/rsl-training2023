#import "ProductCell.h"

@interface ProductCell() {
    UIImageView *productImage;
    UILabel *productTitle;
    UILabel *productDescription;
    UILabel *productPrice;
    UILabel *productRating;
    UILabel *productCategory;
}

@end

@implementation ProductCell

- (instancetype)initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = UIColor.systemGray5Color;
        productImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        productImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:productImage];
        
        productTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [productTitle setFont:[UIFont systemFontOfSize:24]];
        productTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:productTitle];

        productDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        productDescription.numberOfLines = 0;
        productDescription.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:productDescription];
        
        productPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        
        productRating = [[UILabel alloc] initWithFrame:CGRectZero];
        
        productCategory = [[UILabel alloc] initWithFrame:CGRectZero];
        
        UIStackView *belowStackStrip = [[UIStackView alloc] initWithArrangedSubviews:@[productPrice, productRating, productCategory]];
        [belowStackStrip setDistribution:UIStackViewDistributionEqualSpacing];
        [belowStackStrip setAxis:UILayoutConstraintAxisHorizontal];
        [belowStackStrip setAlignment:UIStackViewAlignmentCenter];
        belowStackStrip.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:belowStackStrip];

        
        [NSLayoutConstraint activateConstraints:@[
            [productImage.topAnchor constraintEqualToAnchor:self.topAnchor constant:16],
            [productImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [productImage.widthAnchor constraintEqualToConstant:100],
            [productImage.heightAnchor constraintEqualToConstant:100],
            
            [productTitle.topAnchor constraintEqualToAnchor:self.topAnchor constant:16],
            [productTitle.leadingAnchor constraintEqualToAnchor:productImage.trailingAnchor constant:16],
            [productTitle.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [productTitle.heightAnchor constraintEqualToConstant:30],
            
            [productDescription.topAnchor constraintEqualToAnchor:productTitle.bottomAnchor constant:0],
            [productDescription.leadingAnchor constraintEqualToAnchor:productImage.trailingAnchor constant:16],
            [productDescription.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [productDescription.bottomAnchor constraintEqualToAnchor:productImage.bottomAnchor],
            
            [belowStackStrip.topAnchor constraintEqualToAnchor:productImage.bottomAnchor],
            [belowStackStrip.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25],
            [belowStackStrip.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-25],
            [belowStackStrip.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        
    }
    return self;
}

- (void)configure:(Product *)product {
    productImage.image = product.thumbnail;
    productTitle.text = product.title;
    productDescription.text = product.shortDescription;
    productPrice.text = [NSString stringWithFormat:@"$ %ld", (long)product.price];
    productRating.text = [NSString stringWithFormat:@"%.2f", product.rating];
    productCategory.text = product.category;
}


@end

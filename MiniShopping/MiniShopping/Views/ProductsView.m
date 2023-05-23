#import "ProductsView.h"
#import "ProductCell.h"

@interface ProductsView() {
    UIButton *sortByPriceButton;
    UIButton *sortByCategoryButton;
}
    
@end

@implementation ProductsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        sortByPriceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [sortByPriceButton setTitle:@"Sort By Price" forState:UIControlStateNormal];
        [sortByPriceButton setBackgroundColor:UIColor.systemBlueColor];
        sortByPriceButton.layer.cornerRadius = 15;
        [sortByPriceButton addTarget:self action:@selector(sortByPriceButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        sortByPriceButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:sortByPriceButton];
        
        sortByCategoryButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [sortByCategoryButton setTitle:@"Sort By Category" forState:UIControlStateNormal];
        [sortByCategoryButton setBackgroundColor:UIColor.systemGreenColor];
        sortByCategoryButton.layer.cornerRadius = 15;
        [sortByCategoryButton addTarget:self action:@selector(sortByCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        sortByCategoryButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:sortByCategoryButton];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _productsGridView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _productsGridView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_productsGridView];
        
        [NSLayoutConstraint activateConstraints:@[
            [sortByPriceButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
            [sortByPriceButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [sortByPriceButton.heightAnchor constraintEqualToConstant:50],
            [sortByPriceButton.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.45],

            [sortByCategoryButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
            [sortByCategoryButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [sortByCategoryButton.heightAnchor constraintEqualToConstant:50],
            [sortByCategoryButton.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.45],
            
            [_productsGridView.topAnchor constraintEqualToAnchor:sortByPriceButton.bottomAnchor constant:16],
            [_productsGridView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_productsGridView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [_productsGridView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
    }
    return self;
    
}

- (void)sortByPriceButtonTapped {
    [self.delegate sortByPrice];
}

- (void)sortByCategoryButtonTapped {
    [self.delegate sortByCategory];
}

@end

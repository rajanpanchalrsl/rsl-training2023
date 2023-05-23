#import "ProductsViewController.h"
#import "ProductsView.h"
#import "ProductCell.h"
#import "Product.h"
#import "FetchProducts.h"
#import "NSMutableArray+Sorting.h"


@interface ProductsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FetchProductsDelegate, ProductViewDelegate> {
    NSMutableArray<Product *> *products;
    ProductsView *productsView;
    FetchProducts *fetchProducts;
}

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mini Shopping";
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self setupModel];
    [self setupView];
}

- (void)setupModel {
    products = [[NSMutableArray alloc] init];
    fetchProducts = [[FetchProducts alloc] init];
    [fetchProducts fetchData];
    fetchProducts.delegate = self;
}

- (void)setupView {
    productsView = [[ProductsView alloc] initWithFrame:CGRectZero];
    productsView.delegate = self;
    [productsView.productsGridView registerClass:[ProductCell class] forCellWithReuseIdentifier:@"productsGridViewIdentifier"];
    productsView.productsGridView.translatesAutoresizingMaskIntoConstraints = NO;
    productsView.productsGridView.delegate = self;
    productsView.productsGridView.dataSource = self;
    [self.view addSubview:productsView];
    
    productsView.translatesAutoresizingMaskIntoConstraints = NO;
    [productsView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [productsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [productsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [productsView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return products.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProductCell *cell = [productsView.productsGridView dequeueReusableCellWithReuseIdentifier:@"productsGridViewIdentifier" forIndexPath:indexPath];
    [cell configure:products[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/4);
}


- (void)addToProductsArray:(Product *)product {
    [products addObject:product];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->productsView.productsGridView reloadData];
    });
}

- (void)sortByPrice {
    [products sortByPrice];
    [productsView.productsGridView reloadData];
}

- (void)sortByCategory {
    [products sortByCategory];
    [productsView.productsGridView reloadData];
}

@end

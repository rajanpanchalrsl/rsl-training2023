#import "NSMutableArray+Sorting.h"
#import "Product.h"

@implementation NSMutableArray (Sorting)

- (void)sortByPrice {
    [self sortUsingComparator:^NSComparisonResult(Product *product1, Product *product2) {
        if (product1.price < product2.price) {
            return NSOrderedAscending;
        } else if (product1.price > product2.price) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

- (void)sortByCategory {
    [self sortUsingComparator:^NSComparisonResult(Product *product1, Product *product2) {
        return [product1.category compare:product2.category options:NSCaseInsensitiveSearch];
    }];
}

@end

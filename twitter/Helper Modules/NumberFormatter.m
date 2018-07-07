//
//  NumberFormatter.m
//  twitter
//
//  Created by Martin Winton on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "NumberFormatter.h"

@implementation NumberFormatter

// Converts number to format similar to twitter. For example 100,000 -> 100.K
// taken from https://stackoverflow.com/questions/18267211/ios-convert-large-numbers-to-smaller-format


+(NSString*) suffixNumber:(NSNumber*)number

{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    if (num < 1000)
        return [NSString stringWithFormat:@"%lld",num];
    
    int exp = (int) (log(num) / log(1000));
    NSArray * units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    int onlyShowDecimalPlaceForNumbersUnder = 10; // Either 10, 100, or 1000 (i.e. 10 means 12.2K would change to 12K, 100 means 120.3K would change to 120K, 1000 means 120.3K stays as is)
    NSString *roundedNumStr = [NSString stringWithFormat:@"%.1f", (num / pow(1000, exp))];
    int roundedNum = [roundedNumStr integerValue];
    if (roundedNum >= onlyShowDecimalPlaceForNumbersUnder) {
        roundedNumStr = [NSString stringWithFormat:@"%.0f", (num / pow(1000, exp))];
        roundedNum = [roundedNumStr integerValue];
    }
    
    if (roundedNum >= 1000) { // This fixes a number like 999,999 from displaying as 1000K by changing it to 1.0M
        exp++;
        roundedNumStr = [NSString stringWithFormat:@"%.1f", (num / pow(1000, exp))];
    }
    
    NSString *result = [NSString stringWithFormat:@"%@%@", roundedNumStr, [units objectAtIndex:(exp-1)]];
    
    return result;
}
@end

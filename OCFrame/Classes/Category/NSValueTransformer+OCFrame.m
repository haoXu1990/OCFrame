//
//  NSValueTransformer+OCFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "NSValueTransformer+OCFrame.h"
#import <Mantle/Mantle.h>
#import "NSString+OCFrame.h"
#import "UIColor+OCFrame.h"

NSString * const OCFStringValueTransformerName = @"OCFStringValueTransformerName";
NSString * const OCFColorValueTransformerName = @"OCFColorValueTransformerName";

@implementation NSValueTransformer (OCFrame)
+ (void)load {
    @autoreleasepool {
        MTLValueTransformer *stringValueTransformer = [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
            return [NSString ocf_stringWithObject:obj];
        }];
        [NSValueTransformer setValueTransformer:stringValueTransformer forName:OCFStringValueTransformerName];
        
        MTLValueTransformer *colorValueTransformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *str, BOOL *success, NSError *__autoreleasing *error) {
            if (str == nil) return nil;
            if (![str isKindOfClass:NSString.class]) {
                if (error != NULL) {
                    NSDictionary *userInfo = @{
                        NSLocalizedDescriptionKey: NSLocalizedString(@"Could not convert string to color", @""),
                        NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected an NSString, got: %@.", @""), str],
                        MTLTransformerErrorHandlingInputValueErrorKey : str
                    };

                    *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo:userInfo];
                }
                *success = NO;
                return nil;
            }
            return OCFColorStr(str);
        } reverseBlock:^id(UIColor *color, BOOL *success, NSError *__autoreleasing *error) {
            if (color == nil) return nil;
            if (![color isKindOfClass:UIColor.class]) {
                if (error != NULL) {
                    NSDictionary *userInfo = @{
                        NSLocalizedDescriptionKey: NSLocalizedString(@"Could not convert color to string", @""),
                        NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected an UIColor, got: %@.", @""), color],
                        MTLTransformerErrorHandlingInputValueErrorKey : color
                    };

                    *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo:userInfo];
                }
                *success = NO;
                return nil;
            }
            return color.qmui_hexString;
        }];
        [NSValueTransformer setValueTransformer:colorValueTransformer forName:OCFColorValueTransformerName];
    }
}

@end

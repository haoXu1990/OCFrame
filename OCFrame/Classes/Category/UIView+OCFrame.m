//
//  UIView+OCFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "UIView+OCFrame.h"
#import <QMUIKit/QMUIKit.h>
#import <Toast/UIView+Toast.h>
#import "OCFFunction.h"
#import "OCFParameter.h"
#import "NSDictionary+OCFrame.h"

@interface UIView ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UIView (OCFrame)

- (DKColorPicker)dk_borderColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_borderColorPicker));
}

- (void)dk_setBorderColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_borderColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.qmui_borderColor = picker(self.dk_manager.themeVersion);
    [self.pickers setValue:[picker copy] forKey:@"setBorderColor"];
}

- (CGFloat)ocf_borderWidth {
    return self.layer.borderWidth;
}

- (void)setBzm_borderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = flat(borderWidth);
}

- (CGFloat)ocf_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBzm_cornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = flat(cornerRadius);
}

- (OCFBorderLayer *)ocf_borderLayer {
    if ([self.layer isKindOfClass:OCFBorderLayer.class]) {
        return (OCFBorderLayer *)self.layer;
    }
    return nil;
}

- (BOOL)ocf_toastWithParameters:(NSDictionary *)parameters completion:(void(^)(BOOL didTap))completion {
    NSString *title = OCFStrMember(parameters, OCFParameter.title, nil);
    NSString *message = OCFStrMember(parameters, OCFParameter.message, nil);
    if (title.length == 0 && message.length == 0) {
        return NO;
    }
    CGFloat duration = OCFFltMember(parameters, OCFParameter.duration, 1.5f);
    id position = OCFStrMember(parameters, OCFParameter.position, @"center");
    if ([position isEqualToString:@"top"]) {
        position = CSToastPositionTop;
    } else if ([position isEqualToString:@"bottom"]) {
        position = CSToastPositionBottom;
    } else {
        position = CSToastPositionCenter;
    }
    [self makeToast:message duration:duration position:position title:title image:nil style:nil completion:completion];
    return YES;
}

@end

//
//  NSSwiftLoader.m
//  HJSwift
//
//  Created by PAN on 2019/8/28.
//  Copyright © 2019 PAN. All rights reserved.
//

#import "NSSwiftLoader.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import <mach-o/dyld.h>

@interface NSSwiftLoader : NSObject
@end

@implementation NSSwiftLoader

+ (void)load {
#if TARGET_IPHONE_SIMULATOR
    uint32_t c = _dyld_image_count();
    for(uint32_t i = 0; i < c; ++i) {
        const char *image_name = _dyld_get_image_name(i);
        NSString *imageName = [NSString stringWithFormat:@"%s", image_name];
        if (![imageName containsString:@"/Platforms/"]) {
            unsigned int classCount;
            const char **classes;
            classes = objc_copyClassNamesForImage(image_name, &classCount);
            for (int i = 0; i < classCount; i++) {
                Class class = objc_getClass(classes[i]);
                if (class_conformsToProtocol(class, @protocol(NSSwiftLoadProtocol))) {
                    [(id<NSSwiftLoadProtocol>)class swiftLoad];
                }
            }
            free(classes);
        }
    }
#else
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    uint32_t c = _dyld_image_count();
    for(uint32_t i = 0; i < c; ++i) {
        const char *image_name = _dyld_get_image_name(i);
        NSString *imageName = [NSString stringWithFormat:@"%s", image_name];
        if ([imageName hasPrefix:mainBundlePath]) {
            unsigned int classCount;
            const char **classes;
            classes = objc_copyClassNamesForImage(image_name, &classCount);
            for (int i = 0; i < classCount; i++) {
                Class class = objc_getClass(classes[i]);
                if (class_conformsToProtocol(class, @protocol(NSSwiftLoadProtocol))) {
                    [(id<NSSwiftLoadProtocol>)class swiftLoad];
                }
            }
            free(classes);
        }
    }
#endif
}

@end

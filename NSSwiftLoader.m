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

/// 测试遍历检测耗时0.016s
///
void loadNSSwiftLoadProtocolImplementClasses()
{
    unsigned int count;
    const char **classes;
    Dl_info info;
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &count);
    
    for (int i = 0; i < count; i++) {
        NSString *className = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        if (class_conformsToProtocol(class, @protocol(NSSwiftLoadProtocol))) {
            [(id<NSSwiftLoadProtocol>)class swiftLoad];
        }
    }
}

@interface NSSwiftLoader : NSObject
@end

@implementation NSSwiftLoader
+ (void)load {
    loadNSSwiftLoadProtocolImplementClasses();
}
@end

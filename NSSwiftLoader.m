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

@interface NSSwiftLoader : NSObject
@end

@implementation NSSwiftLoader

+ (void)load {
    int numClasses = 0, newNumClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    while (numClasses < newNumClasses) { // 3
        numClasses = newNumClasses;
        classes = (Class *)realloc(classes, sizeof(Class) * numClasses);
        newNumClasses = objc_getClassList(classes, numClasses);
        
        for (int i = 0; i < numClasses; i++) {
            Class class = classes[i];
            if (class_conformsToProtocol(class, @protocol(NSSwiftLoadProtocol))) {
                [(id<NSSwiftLoadProtocol>)class swiftLoad];
            }
        }
    }
    free(classes);
}

@end

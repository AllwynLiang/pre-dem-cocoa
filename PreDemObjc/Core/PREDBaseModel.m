//
//  PREDBaseModel.m
//  Pods
//
//  Created by 王思宇 on 15/09/2017.
//
//

#import "PREDBaseModel.h"
#import "PREDHelper.h"
#import "NSObject+Serialization.h"
#import <objc/runtime.h>

@implementation PREDBaseModel

+ (instancetype)eventWithName:(NSString *)name type:(NSString *)type {
    return [[self alloc] initWithName:name type:type];
}

- (instancetype)initWithName:(NSString *)name type:(NSString *)type {
    if (self = [self init]) {
        _name = name;
        _type = type;
    }
    return self;
}

- (NSString *)description {
    return [self toDic].description;
}

- (instancetype)init {
    if (self = [super init]) {
        _name = @"";
        _type = @"";
        _time = (int64_t)(NSDate.date.timeIntervalSince1970 * 1000);
        _app_bundle_id = PREDHelper.appBundleId;
        _app_name = PREDHelper.appName;
        _app_version = PREDHelper.appVersion;
        _device_model = PREDHelper.deviceModel;
        _os_platform = PREDHelper.osPlatform;
        _os_version = PREDHelper.osVersion;
        _os_build = PREDHelper.osBuild;
        _sdk_version = PREDHelper.sdkVersion;
        _sdk_id = PREDHelper.UUID;
        _tag = PREDHelper.tag;
        _manufacturer = @"Apple";
    }
    return self;
}

- (NSData *)serializeForSending:(NSError **)error {
    Class class = self.class;
    Class superClass = class_getSuperclass(class);
    NSAssert([superClass isEqual:PREDBaseModel.class], @"%@ should be subclass of PREDBaseModel", class);
    NSMutableDictionary *dic = [self toDicForClass:superClass];
    NSMutableDictionary *thisClassDic = [self toDicForClass:class];
    if (thisClassDic.count > 0) {
        [dic setObject:[self toDicForClass:class] forKey:@"content"];
    }
    return [NSJSONSerialization dataWithJSONObject:dic options:0 error:error];
}

@end

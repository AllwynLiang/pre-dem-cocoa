//
//  PREDVersion.m
//  PreDemCocoa
//
//  Created by WangSiyu on 22/05/2017.
//  Copyright © 2017 pre-engineering. All rights reserved.
//

#import "PREDVersion.h"
#import "PREDLogger.h"

static NSString *version;
static NSString *build;

@implementation PREDVersion

+ (void)load {
  NSURL *bundleUrl =
      [[NSBundle bundleForClass:self] URLForResource:@"PREDResources"
                                       withExtension:@"bundle"];
  if (!bundleUrl) {
    PREDLogWarning(@"version bundle is not detected");
    return;
  }
  NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
  NSString *plistPath = [bundle pathForResource:@"Version" ofType:@"plist"];
  NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
  version = data[@"Version"];
  build = data[@"Build"];
}

+ (NSString *)getSDKVersion {
  return version.copy;
}

+ (NSString *)getSDKBuild {
  return build.copy;
}

@end

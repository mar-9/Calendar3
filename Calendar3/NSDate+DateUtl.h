//
//  NSDate+DateUtl.h
//  Calendar3
//
//  Created by SONE MASANORI on 2014/03/25.
//  Copyright (c) 2014年 SONE MASANORI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateUtl)

- (NSDate *) toLocalTime;
- (NSDate *) toGlobalTime;
- (NSString *) toNSString;
- (NSString *) toNSStringYM;
@end

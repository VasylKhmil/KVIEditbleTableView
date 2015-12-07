//
//  KVICustomView.h
//  Booya Fitness
//
//  Created by Vasyl Khmil on 9/3/15.
//  Copyright (c) 2015 MEV. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface KVICustomView : UIView {
    @protected
    NSString *nibFileName;          //by default class name is used. need to be initialized before [super initWithCoder:]
}

@end

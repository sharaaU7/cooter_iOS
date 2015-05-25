//
//  ViewController.h
//  TableViewLessons
//
//  Created by Mate User on 5/25/15.
//  Copyright (c) 2015 Sharad Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDataSource, UITabBarDelegate>
{
    NSArray * items;
}

@property( nonatomic, retain) NSArray * items;
@end


//
//  ViewController.h
//  Calendar3
//
//  Created by SONE MASANORI on 2014/03/25.
//  Copyright (c) 2014年 SONE MASANORI. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CONST_INT_MAXDAY 42;

@interface ViewController : UIViewController {
    
    
    
    @private    
    NSCalendar *calendar;
    NSDate *currentDate;
    int offsetMonth;
    
    NSMutableArray *arDate;
    NSMutableArray *arImage;
}
//extern const int spacing;

@property (strong, nonatomic) IBOutlet UIView *labelview;
@property (strong, nonatomic) IBOutlet UILabel *dispDate;
- (IBAction)prevMonth:(id)sender;
- (IBAction)currMonth:(id)sender;
- (IBAction)nextMonth:(id)sender;

@end

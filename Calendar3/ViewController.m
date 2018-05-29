//
//  ViewController.m
//  Calendar3
//
//  Created by SONE MASANORI on 2014/03/25.
//  Copyright (c) 2014年 SONE MASANORI. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+DateUtl.h"

@interface ViewController ()

@end

const int maxDay = 42;
const int rectW = 43;
const int rectH = 43;
const int spacingX = 2;
const int spacingY = 2;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _labelview = [[UIView alloc] init];
    [self.view addSubview:_labelview];
    
    NSDate *date = [NSDate date];
    
    double g = [self calcFullmoon:date];
    
    LOG_PRINTF(@"%f", g);
    double jul = [self getJulian:[NSDate date]];
    double getu = [self getNewMoon:jul];
    LOG_PRINTF(@"jul:%f  getu:%f", jul, getu);
    
    calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:date];
    [comps setDay:1];
    currentDate = [calendar dateFromComponents:comps];
    
    offsetMonth = 0;
    
    int x = 4;
    int y = 120;
    
    // 曜日の見出し
    NSArray *week = [NSArray arrayWithObjects:@"月",@"火",@"水",@"木",@"金",@"土",@"日", nil];
    for (int i = 0; i < [week count];i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, rectW, rectH / 2)];
        label.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        label.text = [week objectAtIndex:i];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [[label layer] setCornerRadius:3.0];
        [label setClipsToBounds:YES];
        
        [_labelview addSubview:label];
        [arDate addObject:label];
        
        x += rectW + spacingX;
        
    }
    
    y -= rectH / 2;
    arDate = [NSMutableArray array];
    arImage = [NSMutableArray array];
    //UIFont *f = [UIFont fontWithName:@"HelveticaNeue-UltraLight"size:18];
    UIFont *f = [UIFont fontWithName:@"HelveticaNeue-Light"size:18];
    for (int i = 0; i < maxDay;i++) {
        if(i % 7 == 0){
            x = 4;
            y+= rectH + spacingY;
        }
        
        UIImage *img = [UIImage imageNamed:@"moon01.png"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        CGRect rect = CGRectMake(x, y, rectW, rectH);
        imgView.frame = rect;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.view addSubview:imgView];
        [arImage addObject:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, rectW, rectH)];
//        label.backgroundColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        label.text = nil;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:f];
        
        [[label layer] setCornerRadius:3.0];
        [label setClipsToBounds:YES];
        
        [_labelview addSubview:label];
        [arDate addObject:label];
        
        x += rectW + spacingX;
        
    }
    UIFont *f2 = [UIFont fontWithName:@"HelveticaNeue-Light"size:30];
    _dispDate.font = f2;
    [self currMonth:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)prevMonth:(id)sender
{
    offsetMonth--;
    [self showDate];
}

- (IBAction)currMonth:(id)sender
{
    offsetMonth = 0;
    [self showDate];
}

- (IBAction)nextMonth:(id)sender
{
    offsetMonth++;
    [self showDate];
}

- (void)showDate
{
    NSDateComponents *comps = [NSDateComponents alloc];
    [comps setMonth:offsetMonth];
    NSDate *d =  [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:d];
    int week_day = [comps weekday];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:d];
    int last =  range.length;
    
    //LOG_PRINTF(@"%@, %d, week_day:%d", [d toLocalTime], last, week_day);
    //NSLog(@"d:%@, last:%d", [d toLocalTime], last);
    _dispDate.text = d.toNSStringYM;
    for(int i = 0; i < [arDate count];i++){
        UILabel *l = [arDate objectAtIndex:i];
        l.text = @"";
    }
    
    for(int i = 1; i <= last;i++){
        
        NSDate *dispdate = [[d dateByAddingTimeInterval: (60*60*24) * (i - 1)] toLocalTime];
        //NSLog(@"%@", dispdate);
        // double g = [self getNewMoon:[self getJulian:d]];
        double julian = [self getJulian:dispdate];
        double nmoon = [self getNewMoon:julian];
        if(nmoon > julian){
            nmoon = [self getNewMoon:julian - 1.0];
        }
        //NSLog(@"nmoon:%f, julian:%f", nmoon, julian);
        double age = julian - nmoon;
        
        UILabel *l = [arDate objectAtIndex:i + week_day - 2];
        l.numberOfLines = 2;
        l.text = [NSString stringWithFormat:@"%d\n%.1f", i, age];
        //l.text = [NSString stringWithFormat:@"%.1f", g];
        //l.backgroundColor = [UIColor clearColor];
    }
}

- (double)calcFullmoon:(NSDate *)date
{
    
    //NSDate *date = [NSDate date];                    // 現在の GMT時間
    calendar = [NSCalendar currentCalendar];
    NSDateComponents *dc = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    NSInteger y = [dc year];
    NSInteger m = [dc month];
    NSInteger d = [dc day];
    
    //ユリウス暦通日
    long julius = 365 * y + (y / 4) - 430 + (306 * (m + 1) / 10) + d;
    double geturei = fmod(julius, 29.530589) - 11.73;
    
    return geturei;
}

- (double)getJulian:(NSDate *)date
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
	[inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	NSDate *dateA = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
//	NSDate *dateB = [NSDate date];
	NSDate *dateB = date;
	NSTimeInterval since;
    
	// dateAとdateBの時間の間隔を取得(dateA - dateBなイメージ)
	//since = [[dateB toLocalTime] timeIntervalSinceDate:dateA];
	since = [dateB timeIntervalSinceDate:dateA] - 9 * 3600;
    
    // ミリ秒に変換して計算
    double julian = since * 1000 / 86400000.0 + 2440587.5;
    
	//NSLog(@"since:%f, julian:%f", since, julian);
    return julian;
}

- (double)getNewMoon:(double)julian
{
    double k     = floor((julian - 2451550.09765) / 29.530589);
    double t     = k / 1236.85;
    double nmoon = 2451550.09765
    + 29.530589  * k
    +  0.0001337 * t * t
    -  0.40720   * sin((201.5643 + 385.8169 * k) * 0.017453292519943)
    +  0.17241   * sin((2.5534 +  29.1054 * k) * 0.017453292519943);
    
	//NSLog(@"nmoon:%f", nmoon);
	//NSLog(@"nmoon:%f", julian - nmoon);

    return nmoon;
}

- (double)getNewMoonR:(double)age
{
    double k     = floor((age - 2451550.09765) / 29.530589);
    double t     = k / 1236.85;
    double nmoon = 2451550.09765
    + 29.530589  * k
    +  0.0001337 * t * t
    -  0.40720   * sin((201.5643 + 385.8169 * k) * 0.017453292519943)
    +  0.17241   * sin((2.5534 +  29.1054 * k) * 0.017453292519943);
    
	//NSLog(@"nmoon:%f", nmoon);
	//NSLog(@"nmoon:%f", julian - nmoon);
    
    return nmoon;
}
@end

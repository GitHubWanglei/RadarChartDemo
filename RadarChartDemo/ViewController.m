//
//  ViewController.m
//  RadarChartDemo
//
//  Created by lihongfeng on 16/6/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "RadarChartDemo-Bridging-Header.h"
#import "RadarChartDemo-Swift.h"
#import "Masonry.h"

#define BgColor [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1]

@interface ViewController ()<ChartViewDelegate>

@property (nonatomic, strong) RadarChartView *radarChartView;
@property (nonatomic, strong) RadarChartData *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = BgColor;
    
    //title
    UILabel *title_label = [[UILabel alloc] init];
    title_label.text = @"Radar Chart";
    title_label.font = [UIFont systemFontOfSize:45];
    title_label.textColor = [UIColor brownColor];
    title_label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(260, 50));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-200);
    }];
    
    //updateData btn
    UIButton *display_btn = [[UIButton alloc] init];
    [display_btn setTitle:@"updateData" forState:UIControlStateNormal];
    [display_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    display_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:display_btn];
    [display_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(240);
    }];
    [display_btn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
    
    //创建雷达图对象
    self.radarChartView = [[RadarChartView alloc] init];
    self.radarChartView.backgroundColor = BgColor;
    [self.view addSubview:self.radarChartView];
    [self.radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.center.mas_equalTo(self.view);
    }];
    self.radarChartView.delegate = self;
    self.radarChartView.descriptionText = @"";//描述
    self.radarChartView.rotationEnabled = YES;//是否允许转动
    self.radarChartView.highlightPerTapEnabled = YES;//是否能被选中
    
    //雷达图线条样式
    self.radarChartView.webLineWidth = 0.5;//主干线线宽
    self.radarChartView.webColor = [self colorWithHexString:@"#c2ccd0"];//主干线线宽
    self.radarChartView.innerWebLineWidth = 0.375;//边线宽度
    self.radarChartView.innerWebColor = [self colorWithHexString:@"#c2ccd0"];//边线颜色
    self.radarChartView.webAlpha = 1;//透明度
    
    //设置 xAxi
    ChartXAxis *xAxis = self.radarChartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:15];//字体
    xAxis.labelTextColor = [self colorWithHexString:@"#057748"];//颜色
    
    //设置 yAxis
    ChartYAxis *yAxis = self.radarChartView.yAxis;
    yAxis.axisMinValue = 0.0;//最小值
    yAxis.axisMaxValue = 150.0;//最大值
    yAxis.drawLabelsEnabled = NO;//是否显示 label
    yAxis.labelCount = 6;// label 个数
    yAxis.labelFont = [UIFont systemFontOfSize:9];// label 字体
    yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
    
    //为雷达图提供数据
    self.data = [self setData];
    self.radarChartView.data = self.data;
    [self.radarChartView renderer];
    
    //设置动画
    [self.radarChartView animateWithYAxisDuration:0.1f];
}

//刷新数据
- (void)updateData{
    self.data = [self setData];
    self.radarChartView.data = self.data;
    [self.radarChartView animateWithYAxisDuration:0.1f];
}

//创建数据
- (RadarChartData *)setData{
    
    double mult = 100;
    int count = 12;//维度的个数
    
    //每个维度的名称或描述
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"%d 月", i+1]];
    }
    
    //每个维度的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
        [yVals1 addObject:entry];
    }
    
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithYVals:yVals1 label:@"set 1"];
    set1.lineWidth = 0.5;//数据折线线宽
    [set1 setColor:[self colorWithHexString:@"#ff8936"]];//数据折线颜色
    set1.drawFilledEnabled = YES;//是否填充颜色
    set1.fillColor = [self colorWithHexString:@"#ff8936"];//填充颜色
    set1.fillAlpha = 0.25;//填充透明度
    set1.drawValuesEnabled = NO;//是否绘制显示数据
    set1.valueFont = [UIFont systemFontOfSize:9];//字体
    set1.valueTextColor = [UIColor grayColor];//颜色
    
//    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
//    for (int i = 0; i < count; i++) {
//        double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
//        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
//        [yVals2 addObject:entry];
//    }
//    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithYVals:yVals2 label:@"set 2"];
//    set2.lineWidth = 0.5;//数据折线线宽
//    set2.drawFilledEnabled = YES;//是否填充颜色
//    [set2 setColor:[self colorWithHexString:@"#ff2d51"]];
//    set2.fillColor = [self colorWithHexString:@"#ff2d51"];
//    set2.fillAlpha = 0.25;//填充透明度
//    set2.drawValuesEnabled = NO;//是否绘制显示数据
//    set2.valueFont = [UIFont systemFontOfSize:9];//字体
//    set2.valueTextColor = [UIColor grayColor];//颜色
    
    RadarChartData *data = [[RadarChartData alloc] initWithXVals:xVals dataSets:@[set1]];
    
    return data;
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
    NSLog(@"chartValueSelected");
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    NSLog(@"chartValueNothingSelected");
}
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    NSLog(@"chartScaled");
}
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    NSLog(@"chartTranslated");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//将十六进制颜色转换为 UIColor 对象
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end


















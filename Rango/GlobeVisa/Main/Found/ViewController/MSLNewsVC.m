//
//  MSLNewsVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/30.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNewsVC.h"
#import "MSLNounAnalyCell.h"
@interface MSLNewsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *_reamrkText; // 新闻内容
}

@end

@implementation MSLNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    [self createTab];
    
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 44 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_245;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
  
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, WIDTH - 30, 0)];
    title.numberOfLines = 0;
    [bgView addSubview:title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:_model.title attributes:@{NSFontAttributeName:FONT_SIZE_19}];
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attText.length)];
    CGSize attSize = [attText boundingRectWithSize:CGSizeMake(WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    title.attributedText = attText;
    title.size = attSize;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(15, title.bottomCX - 8 , WIDTH - 30, 30)];
    [bgView addSubview:time];
    time.font = FONT_SIZE_13;
    time.textColor = COLOR_153;
    NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.create_time]];
    
    NSString *timeStr = [str substringToIndex:10];
    NSTimeInterval timeInter = [timeStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInter];
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"yyyy-MM-dd";
    time.text = [NSString stringWithFormat:@"%@  %@",[matter stringFromDate:date],APP_NAME];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [bgView addSubview: imageV];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_model.img_url] placeholderImage:nil];

    CGSize size = imageV.image.size;
    if (size.width == 0) {
        size.width = 1;
    }
    if (size.height == 0) {
        size.height = 1;
    }
    imageV.frame = CGRectMake(15, time.bottomCX + 10, WIDTH - 30, (size.width/size.height)*(WIDTH - 30));
    
    bgView.frame = CGRectMake(0, 0, WIDTH, imageV.bottomCX + 10);
    _tableView.tableHeaderView = bgView;
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *remarkText = [_model.remark stringByReplacingOccurrencesOfString:@"#" withString:@"\n\n"];
    return [CXUtils labelHei:remarkText withWidth:WIDTH - 30 withFont:FONT_SIZE_13];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLNounAnalyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nounAnCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLNounAnalyCell" owner:nil options:nil] lastObject];
    }
    NSString *remarkText = [_model.remark stringByReplacingOccurrencesOfString:@"#" withString:@"\n\n"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:remarkText attributes:@{NSFontAttributeName:FONT_SIZE_13}];
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attText.length)];
    cell.name.attributedText = attText;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end

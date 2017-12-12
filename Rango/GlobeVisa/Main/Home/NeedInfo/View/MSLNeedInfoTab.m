//
//  MSLNeedInfoTab.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNeedInfoTab.h"
#import "MSLNeedInfoHeadView.h"
#import "MSLNeedInfoScrollView.h"
@interface MSLNeedInfoTab ()
{
    UITextView *_needInfoTextView;  //  所需资料
    UITextView *_baseInfoTextView;  //  基本信息
    UIView *_stepView;              //  办理流程
    MSLNeedInfoHeadView *_head;     // toushitu
    NSInteger _selectIndex;     // 选中的位置

}

@end
@implementation MSLNeedInfoTab

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _selectIndex = 0;
        [self createHead];
    }
    return self;
}

- (void)createHead{
    _head = [[[NSBundle mainBundle] loadNibNamed:@"MSLNeedInfoHeadView" owner:nil options:nil] lastObject];
    _head.frame = CGRectMake(0, 0, WIDTH, Line(320));
    self.tableHeaderView = _head;
}
- (void)setMerModel:(MSLProductModel *)merModel {
    
    _merModel = merModel;
    _head.model = _merModel;
}

- (void)setTitleArr:(NSMutableArray *)titleArr {
    
    _titleArr = titleArr;
    [self reloadData];
}

#pragma mark - - - - - - - - - - UITableVIewDelegate - - - - - - - - - - -
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    //  轮播 独占一个section
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 0 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  section == 0 ? 89 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: return 0;
       
        case 1:
            return _baseInfoHeiArr.count != 0 ? [_baseInfoHeiArr[_selectIndex][@"height"] floatValue] :0;
        case 2:
            return _needInfoHeiArr.count != 0 ? [_needInfoHeiArr[_selectIndex][@"height"] floatValue] :0;

        case 3: return 250;

        default: break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personTypeTableViewCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personTypeTableViewCell"];
    }
    if (indexPath.section == 1) {

        [self cellOfBaseInfoTextView:cell];

        if (!(_baseInfoTextView.superview == cell.contentView)) {
            [cell.contentView addSubview:_baseInfoTextView];
        }
    }
    if (indexPath.section == 2) {

        [self cellOfNeddInfoTextView:cell];

        if (!(_needInfoTextView.superview == cell.contentView)) {

            [cell.contentView addSubview:_needInfoTextView];
        }
    }

    if (indexPath.section == 3) {

        if (!_stepView) {

            [self loadStepView];
            [cell.contentView addSubview:_stepView];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    MSLNeedInfoScrollView *scrollView = [[MSLNeedInfoScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 89)];
    
    if (_titleArr.count != 0 && _imageArr.count != 0) {
        
        scrollView.titleArr = _titleArr;
        scrollView.imageArr = _imageArr;
    }
    scrollView.delegate = self;
    
    return scrollView;
}

#pragma mark - - - - - - - - - - 创建cell - - - - - - - - - - -
// 所需资料
- (void)cellOfNeddInfoTextView:(UITableViewCell *)cell {
    
    if (!_needInfoTextView) {
        _needInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, WIDTH - 30, 1)];
    }
    _needInfoTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置页边距
    _needInfoTextView.showsVerticalScrollIndicator = NO;
    _needInfoTextView.showsHorizontalScrollIndicator = NO;
    
    if (_needInfoHeiArr) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        
        NSDictionary *needInfoDic = _needInfoHeiArr[_selectIndex];
        _needInfoTextView.attributedText = needInfoDic[@"text"];
        _needInfoTextView.editable = NO;
        _needInfoTextView.scrollEnabled = NO;
    }
}

// 基本信息
- (void)cellOfBaseInfoTextView:(UITableViewCell *)cell {
    
    if (!_baseInfoTextView) {
        _baseInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, WIDTH - 30, 1)];
    }
    
    _baseInfoTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置页边距
    _baseInfoTextView.showsVerticalScrollIndicator = NO;
    _baseInfoTextView.showsHorizontalScrollIndicator = NO;
    
    if (_baseInfoHeiArr) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        
        NSDictionary *baseInfoDic = _baseInfoHeiArr[_selectIndex];
        NSMutableAttributedString *text = baseInfoDic[@"text"];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        _baseInfoTextView.attributedText = text;
        _baseInfoTextView.editable = NO;
        _baseInfoTextView.scrollEnabled = NO;
    }
}


//办理流程 a
- (void)loadStepView {
    
    NSArray *titlerArr = @[@"准备并上传资料",@"下单支付",@"寄送资料",@"资料审核并送签",@"出签并配送"];
    _stepView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 30, 250)];
    
    for (int i = 0; i < titlerArr.count; i ++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 50, _stepView.widthCX,50)];
        
        UILabel *stepla = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        stepla.text = [NSString stringWithFormat:@"0%d",i + 1];
        stepla.textColor = COLOR_BUTTON_BLUE;
        stepla.textAlignment = NSTextAlignmentLeft;
        stepla.font = FONT_13;
        [bgView addSubview:stepla];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(stepla.rightCX, 0, 25, 25)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"step"];
        [bgView addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightCX + 10, 0, bgView.widthCX - imageView.widthCX - 10 - stepla.widthCX, stepla.heightCX)];
        title.text = titlerArr[i];
        title.textColor = COLOR_BUTTON_BLUE;
        [bgView addSubview:title];
        title.font = FONT_13;
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.leftCX + (imageView.rightCX - imageView.leftCX - 1)/2, imageView.bottomCX, 1, bgView.heightCX - imageView.heightCX)];
        lineImg.image = [UIImage imageNamed:@"line"];
        if (i != titlerArr.count - 1) {
            
            [bgView addSubview:lineImg];
        }
        
        [_stepView addSubview:bgView];
    }
}


@end

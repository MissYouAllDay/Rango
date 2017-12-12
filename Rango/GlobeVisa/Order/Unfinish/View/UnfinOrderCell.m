//
//  UnfinOrderCell.m
//  GlobeVisa
//
//  Created by MSLiOS on 2017/2/10.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "UnfinOrderCell.h"

@implementation UnfinOrderCell

- (void)setOrderStatus:(int)orderStatus {
    
    _orderStatus = orderStatus;
    
    [self setNeedsLayout];

}


- (void)layoutSubviews {
    
    _markView.hidden = _orderID ? NO : YES;
        
    _cancleBtn.hidden = [_isPay isEqualToString:@"1"]?YES:NO;
    
    _orderID? [self evusVisawithTahg:2300]:[self nomalVisawithTag:2000];
}

//evus 签证
- (void)evusVisawithTahg:(int)tag{
    
    if (_orderStatus == 0)  {
        
        [self ingIndex:0 withTag:tag];
        [self unfinIndex:1 withTag:tag];
        [self unfinIndex:2 withTag:tag];
 
    }
    
    if (_orderStatus == 1) {
        
        [self okIndex:0 withTag:tag];
        [self ingIndex:1 withTag:tag];
        [self unfinIndex:2 withTag:tag];

    }
    
    if (_orderStatus > 1) {
        
        [self okIndex:0 withTag:tag];
        [self okIndex:1 withTag:tag];
        [self ingIndex:2 withTag:tag];
    }
    
}
//普通签证
- (void)nomalVisawithTag:(int)tag {
    
    if (_orderStatus == 0)  {
        
        [self ingIndex:0 withTag:tag];
        [self unfinIndex:1 withTag:tag];
        [self unfinIndex:2 withTag:tag];
        [self unfinIndex:3 withTag:tag];
        [self unfinIndex:4 withTag:tag];
    }
    
    if (_orderStatus == 1) {
        
        [self okIndex:0 withTag:tag];
        [self ingIndex:1 withTag:tag];
        [self unfinIndex:2 withTag:tag];
        [self unfinIndex:3 withTag:tag];
        [self unfinIndex:4 withTag:tag];
    }
    
    if (_orderStatus == 2) {
        
        [self okIndex:0 withTag:tag];
        [self okIndex:1 withTag:tag];
        [self ingIndex:2 withTag:tag];
        [self unfinIndex:3 withTag:tag];
        [self unfinIndex:4 withTag:tag];
    }
    if (_orderStatus == 3) {
        
        [self okIndex:0 withTag:tag];
        [self okIndex:1 withTag:tag];
        [self okIndex:2 withTag:tag];
        [self ingIndex:3 withTag:tag];
        [self unfinIndex:4 withTag:tag];
    }
    
    if (_orderStatus > 3) {
        
        [self okIndex:0 withTag:tag];
        [self okIndex:1 withTag:tag];
        [self okIndex:2 withTag:tag];
        [self okIndex:3 withTag:tag];
        [self ingIndex:4 withTag:tag];
    }
}
//完成  绿圈 绿字
- (void)okIndex:(int)index withTag:(int)tag{
    
    UILabel *schNumLab = [self viewWithTag:tag + index];
    UIImageView *cirImage = [self viewWithTag:tag + 100 + index];
    cirImage.layer.borderColor = [UIColor clearColor].CGColor;
    cirImage.image = [UIImage imageNamed:@"finish"];
    cirImage.backgroundColor = [UIColor clearColor];
    schNumLab.textColor = NAVGATIONCOLOR;
}
//进行中  绿底  白字
- (void)ingIndex:(int)index withTag:(int)tag{
    
    UILabel *schNumLab = [self viewWithTag:tag + index];
    UIImageView *cirImage = [self viewWithTag:tag + 100 + index];
    cirImage.layer.borderColor = [UIColor clearColor].CGColor;
    cirImage.image = nil;
    cirImage.backgroundColor = NAVGATIONCOLOR;
    schNumLab.textColor = COLOR_WHITE;
}
//进行中  绿底  白字
- (void)unfinIndex:(int)index withTag:(int)tag{
    
    UILabel *schNumLab = [self viewWithTag:tag + index];
    UIImageView *cirImage = [self viewWithTag:tag + 100 + index];
    cirImage.layer.borderColor = GRAYCOLOR.CGColor;
    cirImage.image = nil;
    cirImage.backgroundColor = [UIColor clearColor];
    schNumLab.textColor = [UIColor blackColor];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _arrWord = [NSArray array];
        _arrWord = @[@"基本信息",@"付款",@"上传资料",@"预约面试",@"领取签证"];
        
        /*
         nameLabel;//名字
         finishStylelabel;//签证类型
         scheduleNumLabel;//进度数字
         scheduleCircleLabel;//进度圆
         scheduleNameLabel;//进度名称
         priceLabel;//价格
         * cancleBtn;//取消订单
         * detailRightBtn;//详情按钮
         * continueBtn;//继续按钮
         */
        // 状态4、5、6、7合并为4，8、9、10合并为5
        //_finishStylelabel = [[UILabel alloc]initWithFrame:CGRectMake(15,10,WIDTH/2, 13)];
        _finishStylelabel = [[UILabel alloc]init];
        _finishStylelabel.font = FONT_13;
        _finishStylelabel.backgroundColor = [UIColor whiteColor];
        _finishStylelabel.textAlignment = NSTextAlignmentLeft;
        _finishStylelabel.textColor = [UIColor colorWithRed:61/255.0 green:64/255.0 blue:56/255.0 alpha:1];
        
        [self.contentView addSubview:_finishStylelabel];
        [_finishStylelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@13);
        }];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = FONT_11;
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textColor = [UIColor colorWithRed:61/255.0 green:64/255.0 blue:56/255.0 alpha:1];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_finishStylelabel.mas_right).offset(15);
            make.top.equalTo(self.mas_top).offset(11);
            make.height.equalTo(@11);
        }];
        
        for (int i =0 ; i<5; i++) {
            _circleImageView = [[UIImageView alloc]init];
            _circleImageView.frame = CGRectMake(15+i*(28+7/2+15+6), 38, 15, 15);
            _circleImageView.layer.cornerRadius = 15/2;
            _circleImageView.layer.borderColor = GRAYCOLOR.CGColor;
            _circleImageView.layer.borderWidth = 0.5;
            
            _scheduleNameLabel = [[UILabel alloc]init];
            _scheduleNameLabel.backgroundColor = [UIColor whiteColor];
            _scheduleNameLabel.frame = CGRectMake((30+7/2) + i*(19/2+15) +i*28, 38+7/2, 28, 7);
            //设置 订单步骤 显示
            _scheduleNameLabel.text = _arrWord[i];
            
            
            if (i == 1) {
                _circleImageView.frame = CGRectMake(64+7/2, 38, 15, 15);
                _scheduleNameLabel.frame = CGRectMake(86, 38+7/2, 14+2, 7);
                
            }
            if (i>=2) {
                _circleImageView.frame = CGRectMake(15+i*(28+7/2+15+6)-14, 38, 15, 15);
                _scheduleNameLabel.frame = CGRectMake((30+7/2) + i*(19/2+15)+ i*28-14, 38+7/2, 28, 7);
                
            }
            
            _scheduleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 2, 11, 11)];
            
            _scheduleNumLabel.font = FONT_10;
            _scheduleNumLabel.contentMode = UIViewContentModeCenter;
            _scheduleNumLabel.text = [NSString stringWithFormat:@"%d",i+1];
            _scheduleNumLabel.textColor = [UIColor blackColor];
            
            _scheduleNumLabel.tag = 2000 + i;
            _circleImageView.tag = 2100 +i;
            _scheduleNameLabel.tag = 2200 + i;
            
            [_circleImageView addSubview:_scheduleNumLabel];
            
            [self.contentView addSubview:_circleImageView];
            
            //进度名称
            _scheduleNameLabel.font = FONT_6;
            [self.contentView addSubview:_scheduleNameLabel];
        }
        
        
        _markView = [[UIView alloc] initWithFrame:CGRectMake(15, 38, 275, 15)];
        _markView.backgroundColor = COLOR_WHITE;
        _markView.hidden = YES;
        [self.contentView addSubview:_markView];
        
        NSArray *evusArr = @[@"基本信息",@"付款",@"审核中"];
        //-----start----
        for (int i = 0; i < 3 ; i++) {
            _circleImageView = [[UIImageView alloc]init];
            _circleImageView.frame = CGRectMake(i*(28+7/2+15+6), 0, 15, 15);
            _circleImageView.layer.cornerRadius = 15/2;
            _circleImageView.layer.borderColor = GRAYCOLOR.CGColor;
            _circleImageView.layer.borderWidth = 0.5;
            //_circleImageView.backgroundColor = GRAYCOLOR;
            
            _scheduleNameLabel = [[UILabel alloc]init];
            _scheduleNameLabel.backgroundColor = [UIColor whiteColor];
            _scheduleNameLabel.frame = CGRectMake((15+7/2) + i*(19/2+15) +i*28, 7/2, 28, 7);
            //设置 订单步骤 显示
            _scheduleNameLabel.text = evusArr[i];
            
            if (i == 1) {
                _circleImageView.frame = CGRectMake(49+7/2, 0, 15, 15);
                _scheduleNameLabel.frame = CGRectMake(71, 7/2, 14+2, 7);
                
            }
            if (i>=2) {
                _circleImageView.frame = CGRectMake(i*(28+7/2+15+6)-14, 0, 15, 15);
                _scheduleNameLabel.frame = CGRectMake((15+7/2) + i*(19/2+15)+ i*28-14, 7/2, 28, 7);
                
            }
            
            _scheduleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 2, 11, 11)];
            
            _scheduleNumLabel.font = FONT_11;
            _scheduleNumLabel.contentMode = UIViewContentModeCenter;
            _scheduleNumLabel.text = [NSString stringWithFormat:@"%d",i+1];
            _scheduleNumLabel.textColor = [UIColor blackColor];
            
            _scheduleNumLabel.tag = 2300 + i;
            _circleImageView.tag = 2400 +i;
            _scheduleNameLabel.tag = 2500 + i;
            
            [_circleImageView addSubview:_scheduleNumLabel];
            
            [_markView addSubview:_circleImageView];
            //字体改成9
            //进度名称
            _scheduleNameLabel.font = FONT_6;
            [_markView addSubview:_scheduleNameLabel];
        }
        //-----end------
        // cancleBtn;//取消订单
            _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _cancleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            _cancleBtn.titleLabel.font = FONT_10;
            [_cancleBtn setTitleColor:QIANSEBTNCOLOR forState:UIControlStateNormal];
            [_cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.contentView addSubview:_cancleBtn];
        _cancleBtn.titleEdgeInsets = UIEdgeInsetsMake(20, 10, 20, 0);

        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(WIDTH-75);
            make.top.equalTo(self.mas_top).offset(0);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 0.3)];
        lineLabel.backgroundColor = GRAYCOLOR;
        [self.contentView addSubview:lineLabel];
        
        
        //priceLabel
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = [UIColor colorWithRed:134/255.0 green:140/255.0 blue:122/255.0 alpha:1];
        _priceLabel.font = FONT_10;
        [self.contentView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(64+23/2);
            make.height.equalTo(@10);
        }];
        //详情
        _detailRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _detailRightBtn.titleLabel.font = FONT_11;
        _detailRightBtn.layer.cornerRadius = 25/2;
        _detailRightBtn.backgroundColor = QIANSEBTNCOLOR;
        [_detailRightBtn setTitle:@"详情" forState:UIControlStateNormal];
        [_detailRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _detailRightBtn.hidden = YES;
        [self.contentView addSubview:_detailRightBtn];
        [_detailRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(WIDTH-122);
            make.top.equalTo(self.mas_top).offset(70);
            make.height.equalTo(@25);
            make.width.equalTo(@50);
        }];
        //detail
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _continueBtn.titleLabel.font = FONT_11;
        _continueBtn.layer.cornerRadius = 25/2;
        _continueBtn.backgroundColor = NAVGATIONCOLOR;
        [_continueBtn setTitle:@"继续" forState:UIControlStateNormal];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_continueBtn];
        [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(WIDTH-65);
            make.top.equalTo(self.mas_top).offset(70);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@25);
        }];
        
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

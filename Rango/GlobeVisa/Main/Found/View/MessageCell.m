//
//  MessageCell.m
//  GlobeVisa
//
//  Created by MSLiOS on 2017/2/4.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell()
{
    UILabel *_label;
    UIImageView *_BgView;
}

@end

@implementation MessageCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}


-(void)createUI {
    _BgView = [[UIImageView alloc] init];
    _label = [[UILabel alloc] init];
    _label.frame = CGRectZero;
    _label.backgroundColor = [UIColor clearColor];
    
    _label.numberOfLines = 0;
    _label.font = FONT_SIZE_13;
    
    _BgView.layer.masksToBounds = YES;
    _BgView.layer.cornerRadius = 5;
   
    [_BgView addSubview:_label];
    [self.contentView addSubview:_BgView];
}

-(void)setMessage:(NSDictionary *)message  {
    _message = message;
    
    if ([message[@"type"] isEqualToString:@"aboutQues"]) { return; }
   
    if ([message[@"type"] isEqualToString:@"user"]) {
      
        _BgView.backgroundColor = HWColor(251, 251, 251);

        NSString *text = _message[@"problem"];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithAttributedString:[self changeTextAtt:text]];
        _label.attributedText = attText;
        CGSize attSize = [attText boundingRectWithSize:CGSizeMake(WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        _BgView.frame = CGRectMake(WIDTH - attSize.width - 20 - 15, 8, attSize.width + 20 ,  attSize.height + 17);
        _label.frame = CGRectMake(10, 10, attSize.width, attSize.height);
        
    }else {
        
        NSString *text = _message[@"answer"];
        _BgView.backgroundColor = HWColor(235, 245, 250);

        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithAttributedString:[self changeTextAtt:text]];
        _label.attributedText = attText;
        CGSize attSize = [attText boundingRectWithSize:CGSizeMake(WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        _BgView.frame = CGRectMake(15, 8, attSize.width + 20 ,  attSize.height + 17);
        _label.frame = CGRectMake(10, 10, attSize.width, attSize.height);
        
        if ([message[@"type"] isEqualToString:@"problem"]) {
            
            _BgView.backgroundColor = HWColor(251, 251, 251);

        }
    }
   
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableAttributedString *)changeTextAtt:(NSString *)text {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:FONT_SIZE_13}];
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attText.length)];
    return  attText;

}

@end

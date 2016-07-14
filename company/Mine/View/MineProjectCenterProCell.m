//
//  MineProjectCenterProCell.m
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineProjectCenterProCell.h"

#import "ZMProgressView.h"
@implementation MineProjectCenterProCell

{
    UIView *_topView;
    UIImageView *_iconImage;
    UIImageView *_statusImage;
    UILabel *_projectLabel;
    UILabel *_addressLabel;
    UILabel *_companyLabel;
    UIImageView *_pointImage;
    UILabel *_firstLabel;
    UILabel *_secondLabel;
    UILabel *_thirdLabel;
    UIImageView *_firstPartImage;
    UIImageView *_secondPartImage;
    UIButton *_personBtn;
    UIButton *_timeBtn;
    UIButton *_moneyBtn;
    UIView *_firstShuView;
    UIView *_secondShuView;
    UIButton *_commitBtn;
    UIButton *_detailBtn;
    ZMProgressView *_progress;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if (!_labelArray) {
            _labelArray = [NSMutableArray array];
        }
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setup
{
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_topView];
    
    //头像
    _iconImage = [UIImageView new];
    _iconImage.layer.cornerRadius = 30*WIDTHCONFIG;
    _iconImage.layer.masksToBounds = YES;
//    _iconImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_iconImage];
    //状态
    _statusImage = [UIImageView new];
//    _statusImage.backgroundColor = orangeColor;
    [self.contentView addSubview:_statusImage];
    //项目名字
    _projectLabel = [UILabel new];
    _projectLabel.font = BGFont(18);
//    _projectLabel.text = @"逸景营地";
    [self.contentView addSubview:_projectLabel];
    //地址
    _addressLabel = [UILabel new];
//    _addressLabel.text = @"陕西 | 西安";
    _addressLabel.font = BGFont(12);
    [self.contentView addSubview:_addressLabel];
    //公司
    _companyLabel = [UILabel new];
//    _companyLabel.text = @"逸景营地投资有限公司";
    _companyLabel.font = BGFont(15);
    _companyLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_companyLabel];
    //点分隔线
    _pointImage = [UIImageView new];
    _pointImage.image = [UIImage imageNamed:@"image-point"];
    [self.contentView addSubview:_pointImage];
    
    _firstLabel = [UILabel new];
    _firstLabel.font = BGFont(15);
    _firstLabel.textColor = color(0, 160, 230, 1);
    _firstLabel.layer.cornerRadius = 3;
    _firstLabel.layer.masksToBounds = YES;
    _firstLabel.layer.borderColor = color(0, 160, 230, 1).CGColor;
    _firstLabel.layer.borderWidth = 0.5;
//    _firstLabel.text = @"体育";
    [_labelArray addObject:_firstLabel];
    [self.contentView addSubview:_firstLabel];
    
    _secondLabel = [UILabel new];
    _secondLabel.font = BGFont(15);
    _secondLabel.textColor = color(0, 160, 230, 1);
    _secondLabel.layer.cornerRadius = 3;
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.layer.borderColor = color(0, 160, 230, 1).CGColor;
    _secondLabel.layer.borderWidth = 0.5;
//    _secondLabel.text = @"旅游";
    [_labelArray addObject:_secondLabel];
    [self.contentView addSubview:_secondLabel];
    
    _thirdLabel = [UILabel new];
    _thirdLabel.font = BGFont(15);
    _thirdLabel.textColor = color(0, 160, 230, 1);
    _thirdLabel.layer.cornerRadius = 3;
    _thirdLabel.layer.masksToBounds = YES;
    _thirdLabel.layer.borderColor = color(0, 160, 230, 1).CGColor;
    _thirdLabel.layer.borderWidth = 0.5;
//    _thirdLabel.text = @"电影";
    [_labelArray addObject:_thirdLabel];
    [self.contentView addSubview:_thirdLabel];
    //分隔线
    _firstPartImage = [UIImageView new];
    _firstPartImage.image = [UIImage imageNamed:@"part_image"];
    [self.contentView addSubview:_firstPartImage];
    //人气指数
    _personBtn = [UIButton new];
//    [_personBtn setTitle:@"1204\n人气指数" forState:UIControlStateNormal];
    [_personBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_personBtn.titleLabel setFont:BGFont(13)];
    _personBtn.titleLabel.numberOfLines = 2;
    _personBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_personBtn];
    //剩余时间
    _timeBtn = [UIButton new];
//    [_timeBtn setTitle:@"16\n剩余时间" forState:UIControlStateNormal];
    [_timeBtn.titleLabel setFont:BGFont(13)];
    [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _timeBtn.titleLabel.numberOfLines = 2;
    _timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeBtn];
    //融资金额
    _moneyBtn = [UIButton new];
//    [_moneyBtn setTitle:@"1000万\n融资总额" forState:UIControlStateNormal];
    [_moneyBtn.titleLabel setFont:BGFont(13)];
    [_moneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _moneyBtn.titleLabel.numberOfLines = 2;
    _moneyBtn.titleLabel.textAlignment  = NSTextAlignmentCenter;
    [self.contentView addSubview:_moneyBtn];
    //进度条
    _progress = [[ZMProgressView alloc]initWithLineColor:orangeColor loopColor:btnCray];
    _progress.title = @"已融资";
    _progress.percentUnit = @"%";
    _progress.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_progress];
    
    //竖分隔线
    _firstShuView = [UIView new];
    _firstShuView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_firstShuView];
    //竖分隔线
    _secondShuView = [UIView new];
    _secondShuView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_secondShuView];
    //分隔线
    _secondPartImage = [UIImageView new];
    _secondPartImage.image = [UIImage imageNamed:@"part_image"];
    [self.contentView addSubview:_secondPartImage];
    //提交记录
    _commitBtn = [UIButton new];
    [_commitBtn setTitle:@"提交记录" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(recordBtn) forControlEvents:UIControlEventTouchUpInside];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBtn.titleLabel setFont:BGFont(16)];
    _commitBtn.backgroundColor = orangeColor;
    _commitBtn.layer.cornerRadius = 3;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.borderWidth = 1;
    _commitBtn.layer.borderColor = orangeColor.CGColor;
    [self.contentView addSubview:_commitBtn];
    //查看btn
    _detailBtn = [UIButton new];
    [_detailBtn setTitle:@"项目详情" forState:UIControlStateNormal];
    [_detailBtn addTarget:self action:@selector(detailBtn) forControlEvents:UIControlEventTouchUpInside];
    [_detailBtn setTitleColor:orangeColor forState:UIControlStateNormal];
    [_detailBtn.titleLabel setFont:BGFont(16)];
    _detailBtn.backgroundColor = [UIColor whiteColor];
    _detailBtn.layer.cornerRadius = 3;
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.layer.borderColor = orangeColor.CGColor;
    [self.contentView addSubview:_detailBtn];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(8*HEIGHTCONFIG);
    }];
    //头像
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(12*WIDTHCONFIG);
        make.top.mas_equalTo(_topView.mas_bottom).offset(15*HEIGHTCONFIG);
        make.width.height.mas_equalTo(60*WIDTHCONFIG);
    }];
    //状态
    [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15*WIDTHCONFIG);
        make.top.mas_equalTo(_topView.mas_bottom);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(55);
    }];
    //项目名字
    [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom).offset(13*HEIGHTCONFIG);
        make.left.mas_equalTo(_iconImage.mas_right).offset(12*WIDTHCONFIG);
        make.height.mas_equalTo(18*HEIGHTCONFIG);
    }];
    //地址
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_projectLabel.mas_bottom);
        make.left.mas_equalTo(_projectLabel.mas_right).offset(12*WIDTHCONFIG);
        make.height.mas_equalTo(12*HEIGHTCONFIG);
    }];
    //公司
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_projectLabel.mas_left);
        make.top.mas_equalTo(_projectLabel.mas_bottom).offset(10*HEIGHTCONFIG);
        make.height.mas_equalTo(15*HEIGHTCONFIG);
        make.right.mas_equalTo(-10*WIDTHCONFIG);
    }];
    //点分隔线
    [_pointImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_projectLabel.mas_left);
        make.top.mas_equalTo(_companyLabel.mas_bottom).offset(5*HEIGHTCONFIG);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20*WIDTHCONFIG);
    }];
    //label
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_projectLabel.mas_left);
        make.top.mas_equalTo(_pointImage.mas_bottom).offset(5*HEIGHTCONFIG);
        make.height.mas_equalTo(20*HEIGHTCONFIG);
    }];
    
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstLabel.mas_right).offset(5*WIDTHCONFIG);
        make.centerY.mas_equalTo(_firstLabel.mas_centerY);
        make.height.mas_equalTo(20*HEIGHTCONFIG);
    }];
    
    [_thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_secondLabel.mas_right).offset(5*WIDTHCONFIG);
        make.centerY.mas_equalTo(_firstLabel.mas_centerY);
        make.height.mas_equalTo(20*HEIGHTCONFIG);
    }];
    
    //分隔线
    [_firstPartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(_firstLabel.mas_bottom).offset(12*HEIGHTCONFIG);
    }];
    
    CGFloat width = 77.5;
    //人气指数btn
    [_personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_firstShuView.mas_left);
//        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.top.mas_equalTo(_firstPartImage.mas_bottom).offset(1*HEIGHTCONFIG);
        make.height.mas_equalTo(73*HEIGHTCONFIG);
        make.width.mas_equalTo(width);
    }];
    //第一条竖线
    [_firstShuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20*HEIGHTCONFIG);
//        make.left.mas_equalTo(_personBtn.mas_right);
        make.centerY.mas_equalTo(_personBtn.mas_centerY);
        make.right.mas_equalTo(_timeBtn.mas_left);
    }];
    //时间btn
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_firstShuView.mas_right);
        make.right.mas_equalTo(_secondShuView.mas_left);
        make.top.mas_equalTo(_personBtn.mas_top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(_personBtn);
    }];
    //第二条竖线
    [_secondShuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_timeBtn.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(_firstShuView);
        make.centerY.mas_equalTo(_personBtn.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    //融资btn
    [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_secondShuView.mas_right);
        make.top.mas_equalTo(_personBtn.mas_top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(_personBtn);
    }];
    //进度条
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_moneyBtn.mas_right).offset(20*WIDTHCONFIG);
        make.top.mas_equalTo(_firstPartImage.mas_bottom).offset(3*HEIGHTCONFIG);
        make.width.height.mas_equalTo(53*WIDTHCONFIG);
    }];
    
    //第二条分隔线
    [_secondPartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstPartImage.mas_left);
        make.right.mas_equalTo(_firstPartImage.mas_right);
        make.top.mas_equalTo(_personBtn.mas_bottom).offset(1);
    }];
    //提交记录
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secondPartImage.mas_bottom).offset(14*HEIGHTCONFIG);
        make.right.mas_equalTo(self.contentView.mas_centerX).offset(-14*WIDTHCONFIG);
        make.width.mas_equalTo(135*WIDTHCONFIG);
        make.height.mas_equalTo(39*HEIGHTCONFIG);
    }];
    //查看btn
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).offset(14*WIDTHCONFIG);
        make.top.mas_equalTo(_commitBtn.mas_top);
        make.width.mas_equalTo(_commitBtn);
        make.height.mas_equalTo(_commitBtn);
    }];
}

-(void)setModel:(ProjectListProModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.startPageImage]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    if ([model.status isEqualToString:@"待路演"]) {
        _statusImage.image = [UIImage imageNamed:@"icon_noroad"];
    }
    
    if ([model.status isEqualToString:@"路演中"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_roading"];
    }
    
    //    if ([model.status isEqualToString:@"预选"]) {
    //        _statusImage.image = [UIImage imageNamed:@"invest_yuxuan"];
    //    }
    
    if ([model.status isEqualToString:@"融资中"]) {
        //
        UIImage * image = [UIImage imageNamed:@"icon_raising"];
        _statusImage.image =  image;
    }
    
    if ([model.status isEqualToString:@"融资成功"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_raisefund"];
    }
    if ([model.status isEqualToString:@"融资失败"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_failed@3x"];
    }
    
    //隐藏多余的 label
    for (NSInteger i =model.areas.count; i < _labelArray.count; i ++) {
        UILabel *label = (UILabel *)_labelArray[i];
        label.hidden = YES;
    }
    //赋值
    for (NSInteger i =0; i < model.areas.count; i ++) {
        UILabel *label = (UILabel *)_labelArray[i];
        label.text = [NSString stringWithFormat:@" %@ ",model.areas[i]];
    }
    
    _projectLabel.text = model.abbrevName;
    _addressLabel.text = model.address;
    _companyLabel.text = model.fullName;
    [_personBtn setTitle:[NSString stringWithFormat:@"%ld\n人气指数",(long)model.collectionCount] forState:UIControlStateNormal];
    [_timeBtn setTitle:[NSString stringWithFormat:@"%ld天\n剩余时间",(long)model.timeLeft] forState:UIControlStateNormal];
    [_moneyBtn setTitle:[NSString stringWithFormat:@"%ld万\n融资总额",(long)model.financeTotal] forState:UIControlStateNormal];
    
    CGFloat finalCount = model.financedMount;
    CGFloat percent = finalCount / model.financeTotal * 100;
    _progress.percent = percent;
}

#pragma mark ----计算时间差
-(NSString*)getDateCha:(NSString*)endDate
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.0";
    //当前时间字符串格式
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    //截止时间date格式
    NSDate *expireDate = [dateFormatter dateFromString:endDate];
    //当前时间date格式
    nowDate = [dateFormatter dateFromString:nowDateStr];
    //当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    //年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
    
    return [NSString stringWithFormat:@"%ld",(long)dateCom.day];
}


-(void)recordBtn
{
    if ([self.delagate respondsToSelector:@selector(didClickRecordBtnInCenterCell:andIndexPath:)]) {
        [self.delagate didClickRecordBtnInCenterCell:self andIndexPath:_indexPath];
    }
}

-(void)detailBtn
{
    if ([self.delagate respondsToSelector:@selector(didClickDetailBtnInCenterCell:andIndexPath:)]) {
        [self.delagate didClickDetailBtnInCenterCell:self andIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

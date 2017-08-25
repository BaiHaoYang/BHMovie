//
//  ZFDownloadingCell.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFDownloadingCell.h"

@interface ZFDownloadingCell ()

@end

@implementation ZFDownloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (void)clickDownload:(UIButton *)sender {
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.downloadBtn.selected = YES;
        [filedownmanage stopRequest:self.request];
    } else {
         self.downloadBtn.selected = NO;
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.progressLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.speedLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == ZFWillDownload) {
            self.downloadBtn.selected = YES;
            self.speedLabel.text = @"等待下载";
        }
        self.progress.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    self.progress.progress = progress;
    
    // NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    if (fileInfo.speed) {
        NSString *speed = [NSString stringWithFormat:@"%@ 剩余%@",fileInfo.speed,fileInfo.remainingTime];
        self.speedLabel.text = speed;
    } else {
        self.speedLabel.text = @"正在获取";
    }

    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.downloadBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"错误";
    }
    [self.fileNameLabel sizeToFit];
    [self.speedLabel sizeToFit];
    [self.progressLabel sizeToFit];
    self.progress.center=CGPointMake(self.progress.width/2.0f+PXChange(50), PXChange(50));
    self.fileNameLabel.center=CGPointMake(self.fileNameLabel.width/2.0f+PXChange(30),self.progress.centerY-self.fileNameLabel.height/2.0f-PXChange(10));
    self.downloadBtn.center=CGPointMake(ScreenWidth-self.downloadBtn.width/2.0f-PXChange(30), self.progress.centerY);
    self.progressLabel.center=CGPointMake(self.progressLabel.width/2.0f+PXChange(30), self.progress.bottom+PXChange(10)+self.progressLabel.height/2.0f);
    self.speedLabel.centerY= self.progressLabel.centerY;
    self.speedLabel.right=self.progress.right;
}
-(UIProgressView *)progress{
    if(!_progress){
        _progress=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-PXChange(160), PXChange(3))];
        [self addSubview:_progress];
    }
    return _progress;
}
-(UILabel *)fileNameLabel{
    if(!_fileNameLabel){
        _fileNameLabel=[[UILabel alloc]init];
        _fileNameLabel.textColor=[UIColor redColor];
        _fileNameLabel.font=[UIFont systemFontOfSize:PXChange(24)];
        [self addSubview:_fileNameLabel];
    }
    return _fileNameLabel;
}
-(UILabel *)progressLabel{
    if(!_progressLabel){
        _progressLabel=[[UILabel alloc]init];
        _progressLabel.textColor=[UIColor blueColor];
        _progressLabel.font=[UIFont systemFontOfSize:PXChange(24)];
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}
-(UILabel *)speedLabel{
    if(!_speedLabel){
        _speedLabel=[[UILabel alloc]init];
        _speedLabel.textColor=[UIColor blueColor];
        _speedLabel.font=[UIFont systemFontOfSize:PXChange(24)];
        [self addSubview:_speedLabel];
    }
    return _speedLabel;
}
-(UIButton *)downloadBtn{
    if(!_downloadBtn){
        _downloadBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(44), PXChange(44))];
        [_downloadBtn addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
        [_downloadBtn setImage:[UIImage imageNamed:@"start_downLoad"] forState:UIControlStateSelected];
        [_downloadBtn setImage:[UIImage imageNamed:@"pause-1"] forState:UIControlStateNormal];
        [self addSubview:_downloadBtn];
    }
    return _downloadBtn;
}

@end

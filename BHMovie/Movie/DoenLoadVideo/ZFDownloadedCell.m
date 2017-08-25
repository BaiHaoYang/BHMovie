//
//  ZFDownloadedCell.m
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

#import "ZFDownloadedCell.h"
@implementation ZFDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.fileName;
    self.sizeLabel.text = totalSize;
    [self.fileNameLabel sizeToFit];
    [self.sizeLabel sizeToFit];
    self.fileNameLabel.center=CGPointMake(self.fileNameLabel.width/2.0f+PXChange(30), self.frame.size.height/2.0f);
    self.sizeLabel.center=CGPointMake(ScreenWidth-self.sizeLabel.width/2.0f-PXChange(30), self.frame.size.height/2.0f);
}
-(UILabel *)fileNameLabel{
    if(!_fileNameLabel){
        _fileNameLabel=[[UILabel alloc]init];
        _fileNameLabel.textColor=[UIColor redColor];
        [self addSubview:_fileNameLabel];
    }
    return _fileNameLabel;
}
-(UILabel *)sizeLabel{
    if(!_sizeLabel){
        _sizeLabel=[[UILabel alloc]init];
        _sizeLabel.textColor=[UIColor yellowColor];
        [self addSubview:_sizeLabel];
    }
    return _sizeLabel;
}
@end

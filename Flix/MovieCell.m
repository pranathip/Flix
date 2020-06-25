//
//  MovieCell.m
//  Flix
//
//  Created by Pranathi Peri on 6/24/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.darkGrayColor;
    self.selectedBackgroundView = backgroundView;
    
}

@end

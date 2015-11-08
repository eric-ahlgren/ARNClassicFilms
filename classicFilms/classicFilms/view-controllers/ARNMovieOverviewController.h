//
//  FirstViewController.h
//  classicFilms
//
//  Created by Stefan Arn on 11/10/15.
//  Copyright © 2015 Stefan Arn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARNMovieOverviewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSString *collectionType;
@property(nonatomic, strong) NSString *collectionTypeExlusion;

@end


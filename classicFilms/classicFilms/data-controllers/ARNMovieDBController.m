//
//  ARNMovieDBController.m
//  classicFilms
//
//  Created by Stefan Arn on 12/10/15.
//  Copyright © 2015 Stefan Arn. All rights reserved.
//

#import "ARNMovieDBController.h"
#import "ARNMovieController.h"


@implementation ARNMovieDBController

+ (ARNMovieDBController *)sharedInstance {
    static ARNMovieDBController *instance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        instance = [[ARNMovieDBController alloc] init];
    });
    
    return instance;
}

- (void)fetchMovieDetailsForMovie:(ARNMovie *)arnMovie withManager:(AFHTTPSessionManager *)manager {
    if (manager != nil && arnMovie != nil && [arnMovie.title length] > 0 && [arnMovie.year integerValue] > 0) {
        //ARNMovie *arnMovie = (ARNMovie *)collection[0];
        
        // TODO: for the last iteration post the notification (on both the success and the failure block)
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMovieDataSuccessful" object:self userInfo:nil];
        
        NSDictionary *parameters = @{@"api_key": @"cde3935be83a0ceff90f530f19931df3",
                                     @"query": arnMovie.title,
                                     @"year": arnMovie.year};
        
        
        [manager GET:@"http://api.themoviedb.org/3/search/movie" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            
            //NSLog(@"JSON: %@", jsonDict);
            
            NSArray *resultsArray = (NSArray *)[jsonDict objectForKey:@"results"];
            if(resultsArray != nil && [resultsArray count] > 0){
                NSDictionary *resultDict = resultsArray[0];
                
                
                NSLog(@"JSON: %@", resultDict);
                NSLog(@"*****************************");
                
                NSLog(@"title: %@", arnMovie.title);
                NSLog(@"year: %ld", (long)arnMovie.year);
                
                NSLog(@"backdrop_path: %@", [resultDict objectForKey:@"backdrop_path"]);
                NSLog(@"poster_path: %@", [resultDict objectForKey:@"poster_path"]);
                NSLog(@"overview: %@", [resultDict objectForKey:@"overview"]);
                //NSLog(@"date: %@", [resultDict objectForKey:@"date"]);
                //NSLog(@"title: %@", [resultDict objectForKey:@"title"]);
                
                // fill in the data
                arnMovie.tmdb_id = [[resultDict objectForKey:@"id"] stringValue];
                arnMovie.movie_description = [resultDict objectForKey:@"overview"];
                arnMovie.posterURL = [resultDict objectForKey:@"poster_path"];
                arnMovie.backdropURL = [resultDict objectForKey:@"backdrop_path"];
                
                // save it
                [[ARNMovieController sharedInstance] addMovie:arnMovie];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            
            // TODO: this api has a rate limit - uuugh
            // -> stop the current for loop
            // wait for Retry-after as seconds
            // restart this method with all movie objects with have a refresh date older than 10 minutes
            //
            // more info here: https://www.themoviedb.org/talk/5317af69c3a3685c4a0003b1 && https://www.themoviedb.org/faq/api?language=en
            /*
             Error: Error Domain=com.alamofire.error.serialization.response Code=-1011 "Request failed: client error (429)" UserInfo={com.alamofire.serialization.response.error.response=<NSHTTPURLResponse: 0x7fc31ae59d60> { URL: http://api.themoviedb.org/3/search/movie?api_key=cde3935be83a0ceff90f530f19931df3&query=Charlie%20Chaplin%27s%20%22The%20Cure%22&year=0 } { status code: 429, headers {
             "Access-Control-Allow-Origin" = "*";
             Connection = "keep-alive";
             "Content-Length" = 95;
             "Content-Type" = "application/json; charset=utf-8";
             Date = "Fri, 16 Oct 2015 09:53:58 GMT";
             "Retry-After" = 8;
             Server = openresty;
             } }, NSErrorFailingURLKey=http://api.themoviedb.org/3/search/movie?api_key=cde3935be83a0ceff90f530f19931df3&query=Charlie%20Chaplin%27s%20%22The%20Cure%22&year=0, com.alamofire.serialization.response.error.data=<7b227374 61747573 5f636f64 65223a32 352c2273 74617475 735f6d65 73736167 65223a22 596f7572 20726571 75657374 20636f75 6e742028 34312920 6973206f 76657220 74686520 616c6c6f 77656420 6c696d69 74206f66 2034302e 227d0a>, NSLocalizedDescription=Request failed: client error (429)}
             
             */
            
        }];
    }
}

@end

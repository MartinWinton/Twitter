//
//  ComposeViewController.m
//  twitter
//
//  Created by Martin Winton on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetView;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *replayTitle;
@property bool placeholder;

@end

@implementation ComposeViewController
- (IBAction)clickTweet:(id)sender {
    
    
    if(self.tweetView.text.length <= 140){
        
        // if not too many charactewrs
        
        if(self.isReply){
            
            NSString *replyText = [NSString stringWithFormat:@"%@%@%@%@", @"@", self.replyTweet.user.name, @" ", self.tweetView.text];
            
            // add @username to reply to work wit twitter api
            
            [[APIManager shared] postReplyWithText:replyText ID:self.replyTweet.idStr completion:^(Tweet *tweet, NSError *error) {
                
                if(error){
                    NSLog(@"Error replying to tweet: %@", error.localizedDescription);
                }
                else{
                    
                    
                    NSLog(@"Successfully created  the following reply: %@", tweet.text);
                    [self dismissViewControllerAnimated:true completion:nil];
                    [self.delegate didTweet:tweet];
                    // let delegate know that we posted tweet
                    
                }
            }];
            
            
        }
        else{
            [[APIManager shared] postStatusWithText:self.tweetView.text completion:^(Tweet *tweet, NSError *error) {
                
                if(error){
                    NSLog(@"Error tweeting tweet: %@", error.localizedDescription);
                }
                else{
                    
                    
                    NSLog(@"Successfully tweeted the following Tweet: %@", tweet.text);
                    [self dismissViewControllerAnimated:true completion:nil];
                    [self.delegate didTweet:tweet];
                    
                }
            }];
            
            
        }
    }
    
    
}
- (IBAction)clickBack:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetView.delegate = self;
    [_tweetView becomeFirstResponder];
    
    self.placeholder = YES;
    
    if (self.isReply){
    self.replayTitle.text = [NSString stringWithFormat:@"%@%@", @"Reply to @", self.replyTweet.user.name];
        self.tweetButton.title = @"Reply";

    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editLimitColorLogic{
    
    
    
    
    self.characterCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)140-self.tweetView.text.length];
    
    // get remaining characters in text box;
    
    
    self.tweetButton.tintColor = [UIColor colorWithRed:0.11 green:0.58 blue:0.88 alpha:1.0];
    // reset tweet button to blue each time
    
    if(self.tweetView.text.length >= 120){
        
        if(self.tweetView.text.length < 140){
            
            self.characterCount.textColor = [UIColor yellowColor];
            // if in threshold, display warning with yellow
        }
        
        else{
            self.characterCount.textColor = [UIColor redColor];
            // if out of threshold, show red
            
            if(self.tweetView.text.length != 140){
                
                // if out of threshold and not at exact capacity, show a negative number, and gray out button
                
                self.characterCount.text= [NSString stringWithFormat:@"%@%@", @"-", [NSString stringWithFormat:@"%lu", self.tweetView.text.length-140]];
                
                
                
                self.tweetButton.tintColor = [UIColor lightGrayColor];
                
                
                
                
            }
            
            
            
            
        }
        
        
        
    }
    
    else{
        
        self.characterCount.textColor = [UIColor whiteColor];
        
        
        
    }
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [self editLimitColorLogic];

}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self editLimitColorLogic];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

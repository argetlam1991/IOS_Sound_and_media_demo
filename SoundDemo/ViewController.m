//
//  ViewController.m
//  SoundDemo
//
//  Created by Gu Han on 6/22/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import "ViewController.h"
@import AudioToolbox;
@import AVFoundation.AVFAudio.AVAudioPlayer;



@interface ViewController ()

@property (assign, nonatomic) SystemSoundID beepA;
@property (assign, nonatomic) SystemSoundID beepB;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (assign, nonatomic) BOOL beepAGood;
@property (assign, nonatomic) BOOL beepBGood;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Load the sound / create the sound ID
  NSString *soundAPath = [[NSBundle mainBundle] pathForResource:@"sampleA" ofType:@"wav"];
  NSURL *urlA = [NSURL fileURLWithPath:soundAPath];
  
  NSString *soundBPath = [[NSBundle mainBundle] pathForResource:@"sampleB" ofType:@"wav"];
  NSURL *urlB = [NSURL fileURLWithPath:soundBPath];
  
  NSString *songPath = [[NSBundle mainBundle] pathForResource:@"sampleC" ofType:@"wav"];
  NSURL *urlSong = [NSURL fileURLWithPath:songPath];
  
  NSError *err;
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSong error:&err];
  
  if (!self.player) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn't load mpe" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
  }
  
  //Archaic C code
  // __bridge = C-level cast
  // Tells ARC to stop taking notice of casted object;
  // Casting -> Don't generate ARC meta data
  
  OSStatus statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlA, &_beepA);
  
  if (statusReport == kAudioServicesNoError) {
    self.beepAGood = YES;
  } else {
    self.beepAGood = NO;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn't load beepA" message:@"BeepA problem" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
  }
  
  statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlB, &_beepB);
  
  if (statusReport == kAudioServicesNoError) {
    self.beepBGood = YES;
  } else {
    self.beepBGood = NO;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn't load beepB" message:@"BeepB problem" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
  }
  
}

- (IBAction)playSoundA:(UIButton *)sender {
  if (!self.beepAGood) {
    return;
  }
  AudioServicesPlaySystemSound(self.beepA);
}

- (IBAction)playSoundB:(UIButton *)sender {
  if(!self.beepBGood) {
    return;
  }
  AudioServicesPlaySystemSound(self.beepB);
}
- (IBAction)playSong:(UIButton *)sender {
  [self.player play];
}

- (IBAction)stopSong:(UIButton *)sender {
  [self.player stop];
}

- (void) dealloc {
  if (self.beepAGood) {
    AudioServicesDisposeSystemSoundID(self.beepA);
  }
  if (self.beepBGood) {
    AudioServicesDisposeSystemSoundID(self.beepB);
  }
}

@end

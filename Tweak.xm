/*

Nathan Ingraham
Tweak: Snapchat Low Power Mode Enabler
Description: Snapchat version 9.37.0.0 Added this feature that reduces Snapchat's power usage when the device is in LPM.
This simple tweak bypasses the Low Power Mode requirement, this allowing Snapchat to run at lower power even when not in LMP.
THIS TWEAK WILL ONLY WORK IF YOU ARE ON VERSION 9.37.0.0 OF SNAPCHAT (or higher if settings aren't mixed around ;) )
*/
BOOL firstInstall = YES;
BOOL receivedPopup;
BOOL userHasSeenTwitter;

%hook SCLowPowerModeExperiment

-(bool) shouldAlwaysBeOn{
	return TRUE;

}


%end

%hook SBHomeScreenViewController
-(void)viewDidAppear:(bool)arg1 {
%orig();
   
   NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.nathaningraham.snapLPMenabler.plist"];
   NSMutableDictionary *mutableDict = dict ? [[dict mutableCopy] autorelease] : [NSMutableDictionary dictionary];
   firstInstall = ([mutableDict objectForKey:@"firstInstall"] ? [[mutableDict objectForKey:@"firstInstall"] boolValue] : firstInstall); 
 
 
 
 
if (firstInstall == YES){
 
  UIAlertController * alert=   [UIAlertController
                                 alertControllerWithTitle:@"Snapchat Low Power Mode Enabler"
                                 message:@"Thanks for installing! Snapchat should now use less battery without the need for Low Power Mode. \n Would you like to follow me on twitter for updates?"
                                 preferredStyle:UIAlertControllerStyleAlert]; //creates popup
 
   UIAlertAction* ok = [UIAlertAction 
                        actionWithTitle:@"Follow 😊"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action) //Creates ok button
                        {  
 
                  receivedPopup = TRUE;
                  //[preferences setBool:YES forKey:@"userHasSeenTwitter"];
 
                  NSString *user = @"NathanIngraham";
                  if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
 
                  else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
 
                  else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
 
                  else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
 
                  else
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
 
                            [alert dismissViewControllerAnimated:YES completion:nil];
 
 
 
 
                        }];
 
   UIAlertAction* cancel = [UIAlertAction
                            actionWithTitle:@"No Thanks! ❌"
                           style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * action)
                           {
                            receivedPopup = TRUE; //Creates "No Thanks! " button.
                           // [preferences setBool:YES forKey:@"userHasSeenTwitter"];
 
                               [alert dismissViewControllerAnimated:YES completion:nil];
 
 
                           }];
 
   [alert addAction:ok]; //Adds the Sure! Button.
   [alert addAction:cancel]; //Adds the No Thanks Button.
 
   [self presentViewController:alert animated:YES completion:nil];
   [alert release];
   [mutableDict setValue:@NO forKey:@"firstInstall"];
   [mutableDict writeToFile:@"/var/mobile/Library/Preferences/com.nathaningraham.snapLPMenabler.plist" atomically:YES];
 
            }
            
      }
%end
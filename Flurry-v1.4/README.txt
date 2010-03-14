Welcome to Flurry Analytics!

This README contains:

1. Introduction
2. Integration
3. Optional Features
4. Recommendations
5. FAQ

=====================================
1. Introduction

The Flurry iPhone Analytics Agent allows you to track the usage and behavior of your iPhone application
on users' phones for viewing in the Flurry Analytics system. It is designed to be as easy as possible
with a basic setup complete in under 5 minutes.

This archive should contain these files:
 - ProjectApiKey.txt : This file contains the name of your project and your project's API key.
 - README.txt : This text file containing instructions. 
 - FlurryLibWithLocation/FlurryAPI.h
 - FlurryLibWithLocation/libFlurryWithLocation.a : The library containing Flurry's collection and reporting code. This version includes GPS location capabilities.
 - FlurryLib/FlurryAPI.h
 - FlurryLib/libFlurry.a : The library containing Flurry's collection and reporting code. This version does not include GPS location capabilities.

Note that there are two versions of the Flurry analytics library: With and without location. We recommend using FlurryLibWithLocation so that you can receive detailed analytics about where your users are using your app.
However, if you do not currently use location in your application, you can use FlurryLib and receive all of the same analytics without detailed location information.
We also recommend calling FlurryAPI from the main thread. FlurryAPI is not supported when called from other threads.

=====================================
2. Integration
 
To integrate Flurry Analytics into your iPhone application, first decide if you want to use location services or not.  
If you do wish to use location, see the steps in 2a.  If you do not wish to use location, skip to 2b.

Note that you should only use Flurry location services if your application already uses the CLLocationManager. You should not enable location services for analytics if you do not already use the CLLocationManager as your application will be rejected by Apple. 
Apple requires that your application use location in a way useful to the end user in order to access the CLLocationManager.

2a. Integration without Location
-------------------------------------------------------------

1. In the finder, drag FlurryLib into project's file folder.
   NOTE: If you are upgrading the Flurry iPhone SDK, be sure to remove any existing Flurry library folders from your project's file folder before proceeding.

2. Now add it to your project =>  Project > Add to project > FlurryLib
    - Choose 'Recursively create groups for any added folders'

3. In your Application Delegate:
      a. Import FlurryAPI =>  #import "FlurryAPI.h"
      b. Inside "applicationDidFinishLaunching:" add => [FlurryAPI startSession:@"YOUR_API_KEY"];
     
      - (void)applicationDidFinishLaunching:(UIApplication *)application {
          [FlurryAPI startSession:@"YOUR_API_KEY"];
          //your code
        }
      
You're done! That's all you need to do to begin receiving basic metric data.

2b. Integration with location
-------------------------------------------------------------
1. In the finder, drag FlurryLibWithLocation into project's file folder.  
   NOTE: If you are upgrading the Flurry iPhone SDK, be sure to remove any existing Flurry library folders from your project's file folder before proceeding.

2. Now add it to your project =>  Project > Add to project > FlurryLibWithLocation
    - Choose 'Recursively create groups for any added folders'

3. At this point, there are two options.  First, if your application already has initialized a CLLocationManager, you can simply pass location information to the Flurry API for each session.  For this option see the steps in 3a.  
   Second, if your application has not already defined a CLLocationManager and you want Flurry to handle this for you, see the steps in 3b.

3a. You pass location information to the FlurryAPI.  In your Application Delegate:
      a. Import FlurryAPI =>  #import "FlurryAPI.h"
      b. Inside "applicationDidFinishLaunching:" add => [FlurryAPI startSession:@"YOUR_API_KEY"];
     
      - (void)applicationDidFinishLaunching:(UIApplication *)application {
          [FlurryAPI startSession:@"YOUR_API_KEY"];
          //your code
        }
      c. Each time you want to update the location that Flurry Analytics will record, use the function below.  Only the last location reported will be used for each session.
         [FlurryAPI setLocation:YOUR_UPDATED_CLLOCATION];

3b. Flurry manages all location capabilities.  In your Application Delegate:
      a. Import FlurryAPI =>  #import "FlurryAPI.h"
      b. Inside "applicationDidFinishLaunching:" add => [FlurryAPI startSessionWithLocationServices:@"YOUR_API_KEY"];
     
      - (void)applicationDidFinishLaunching:(UIApplication *)application {
          [FlurryAPI startSessionWithLocationServices:@"YOUR_API_KEY"];
          //your code
        }
      
      NOTE: You must also include the CoreLocation.framework if you do this. To add this framework, go to
      Project > Edit Active Target "YOUR_APP" > Add Libraries ('+' sign at the bottom) and select CoreLocation.framework

You're done! That's all you need to do to begin receiving basic metric data.  For optional advanced features, skip to Section 3.

=====================================
3. Optional / Advanced Features

You can use the following methods to report additional data.  These methods work exactly the same with or without location services enabled.

[FlurryAPI logEvent:@"EVENT_NAME"];
Use logEvent to count the number of times certain events happen during a session of your application.  This can be useful for measuring how often users perform various actions, for example.  Your application is currently limited to counting occurrences for 100 different event ids (maximum length 255 characters).

[FlurryAPI logEvent:@"EVENT_NAME" withParameters:YOUR_NSDictionary];
Use this version of logEvent to count the number of times certain events happen during a session of your application and to pass dynamic parameters to be recorded with that event.  For example, you could record that a user used your search box tool and also dynamically record which search terms the user entered.  Your application is currently limited to counting occurrences for 100 different event ids (maximum length 255 characters). 

  An example NSDictionary to use with this method could be:
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"your dynamic parameter value", @"your dynamic parameter name", nil];

[FlurryAPI logError:@"ERROR_NAME" message:@"ERROR_MESSAGE" exception:e];
Use this to log exceptions and/or errors that occur in your app. Flurry will report the first 10 errors that occur in each session.

[FlurryAPI setSessionReportsOnCloseEnabled:(BOOL)sendSessionReportsOnClose];
This option is off by default. If enabled, Flurry will attempt to send session data when the app is exited as well as it normally does when the app is started. This will improve the speed at which your application analytics are updated but can prolong the app termination process due to network latency. 

=====================================
4. Recommendations

We recommend adding an uncaught exception listener to your application (if you don't already have one) and use logError to record any application crashes.
Adding an uncaught exception listener is easy; you just need to create a function that looks like the following:

    void uncaughtExceptionHandler(NSException *exception) {
        [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
    }                                       

You then need to register this function as an uncaught exception listener as follows:

    - (void)applicationDidFinishLaunching:(UIApplication *)application {
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        [FlurryAPI startSession:@"YOUR_API_KEY"];
            ....
    }           

Note that you can name the function whatever you'd like and record whatever error information you'd like in the error name and event fields.

=====================================
5. FAQ

When does the Flurry Agent send data?

The Flurry agent will only send metrics data once per user session. During a given session, the Flurry Agent records all of the relevant metrics and stores them on the phone.
At the start of the next session the Agent takes all of that stored data and sends it to the Flurry servers.
If network access is not available during that session it will send it at the next opportunity.

How much data does the Agent send each session?

All data sent by the Flurry Agent is sent in a compact binary format.

What data does the Agent send?

The data sent by the Flurry Agent includes time stamps, logged events, logged errors, and various device specific information. This is the same information that can be seen in the custom event logs on in the Event Analytics section.
We are also collecting App Store ID, purchase date, release date, and purchase price in order to provide more metrics in the future.
We do not collect personally identifiable information.  

=====================================

Please let us know if you have any questions. If you need any help, just email iphonesupport@flurry.com!

Cheers,
The Flurry Team
http://www.flurry.com
iphonesupport@flurry.com
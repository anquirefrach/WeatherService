# WeatherService
Application Pool .NET v2.0

I did have to give my application pool in IIS a custom account for the Identity (in IIS) and setProfileEnvironment="true" in applicationHost.config.

Also, the files HelloWorld.cs goes in an App_Code folder, and Database1.mdf (and Database1_log.ldf) go in an App_Data folder.

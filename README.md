# SunriseSunset with Mock URL Protocols

SunriseSunset is a single page app providing sunrise and sunset times for US states via two separate API calls. The API calls are based off of the openweathermap.org's API and sunrise-sunset.org's API using a CustomURLProtocol. 
<br>
<br>
The CustomURLProtocol intercepts the url request and provides the appropriate data based on its query items. The app is able to use URLSession without having to make any actual network calls, but with the benefit of still receiving data and error responses. 
<br>
<br>
A MockURLProtocol is also used for unit tests.
<br>
<br>
# To Use:
After cloning, the app is fully functional and can be tested in the simulator. Since it does not perform any actual network calls, the app will only respond to four different zip codes:
- 13026 for Aurora, NY
- 75217 for Dallas, TX
- 90185 for Los Angeles, CA
- 84121 for Salt Lake City, UT
<br>
<br>
![Simulator Screenshot - iPhone 15 Pro - 2025-03-03 at 23 47 24](https://github.com/user-attachments/assets/4e3fd69f-95cc-416f-9433-1c60b27e4a79)
<br>
<br>
Copyright (C) 2025 Lisa Fellows
<br>
SunriseSunsetMockURLProtocol cannot be copied and/or distributed without express permission.

README for the Looter's WeatherApp single-file executable
source code is located at: https://github.com/skipmcgee/weatherscraper

Minimum App Requirements:
- Windows 10
- Internet Connection
- Appropriate privilege to run an executable in your environment

Ever need to check if the distant end of a satellite connection is masking equipment problems as "weather problems"? Ever need to monitor the current weather in two separate locations?

This application is designed to display the current weather at your location + the current weather at a second location of your choosing (such as hub/spoke satellite sites, etc.). The two locations can be any where across the globe, simply input the name of the nearest major city. The API data is updated approximately every 15 minutes, so a new search will be accurate to within that time period.

In order to access the API utilized in this application: 
- Browse to: https://openweathermap.org/api
- Under the options, subscribe for the "Free Current Weather". Create an API key.
- Add your key to the "api_key" variable below. Run this little application!
- (Note: If you aren't a DJC2 20.2 "Looter", you might want to consider changing the application name, logo and default locations.)

To enable code signing, a powershell script (certificate_creation_and_signing.ps1) is provided to sign the executable in your environment - then add the signing certificate to your Domain Controller to prevent environment-specific user execution policy issues. Powershell script provided by Daniel Gibson (https://github.com/Daniel-R-Gibson).

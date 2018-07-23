# MyTracks_iOS

# Problem
- It was noticed that the New York City has a relatively high rate of carbon emission
- Greenhouse gas emissions per person: 7.1 tons1
- Cars, buses, Subway, buildings, power plants…
- However, people do not really know how much carbon do they emit every day

# Solution
- We have developed an app to record tracks and display statistics e.g. daily carbon emission of the users
- To visualize users’ contribution to the carbon emission of the city
- To encourage New Yorkers to do more exercise and reduce carbon emission
- Users can also see their paths on the map, and statistics such as total distance, calories burnt and equivalent used of bulbs
- Useful for the government’s research/survey on carbon emission of the city
- Available for both Android and iOS platforms

# How it works
- This app is build based on an open source app MyTracks
- 2 major components: the app itself, a web service
- App side: GPS tracks recording, track displaying, statistics displaying
- Web service side: Handling uploading requests, data formatting, cloud messaging
- Users can record their travel tracks and statistics
- 2 Tabs: Map, Statistics
- Map Tab: tracks of travels are displayed
- Statistics Tab: total distance, average speed etc.
- When the "Curr" button is pressed: data will be passed to the web service to do calculations
- Users can then see the calories burnt, carbon emission etc. of that travel

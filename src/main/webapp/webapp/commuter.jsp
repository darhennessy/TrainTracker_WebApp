<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="javax.swing.JOptionPane" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="javax.servlet.ServletContext" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="org.apache.commons.lang3.ArrayUtils" %>
<%@ page import="org.apache.commons.lang3.math.NumberUtils" %>

<%!
	/*############################################################*/
	/*Create class for storing station data*/
	/*############################################################*/

	public class StationData{
		private String Stationfullname;
		private String Traindate;
		private String Origin;
		private String Destination;
		private String Origintime;
		private String Destinationtime;
		private String Status;
		private String Lastlocation;
		private String Duein;
		private String Late;
		private String Exparrival;
		private String Expdepart;
		private String Scharrival;
		private String Schdepart;
		
		public String getStationfullname(){
			return this.Stationfullname;
		}
		public String getTraindate(){
			return this.Traindate;
		}
		public String getOrigin(){
			return this.Origin;
		}
		public String getDestinationtime(){
			return this.Destinationtime;
		}
		public String getStatus(){
			return this.Status;
		}
		public String getLastlocation(){
			return this.Lastlocation;
		}
		public String getExparrival(){
			return this.Exparrival;
		}
		public String getLate(){
			return this.Late;
		}
		public String getDestination(){
			return this.Destination;
		}
		public String getScharrival(){
			return this.Scharrival;
		}
		public String getExpdepart(){
			return this.Expdepart;
		}
		public String getDuein(){
			return this.Duein;
		}
		public String getOrigintime(){
			return this.Origintime;
		}
		public String getSchdepart(){
			return this.Schdepart;
		}
		
		public void setStationfullname(String fullname){
			this.Stationfullname = fullname;
		}
		public void setTraindate(String date){
			this.Traindate = date;
		}
		public void setOrigin(String O){
			this.Origin = O;
		}
		public void setDestinationtime(String Desttime){
			this.Destinationtime=Desttime;
		}
		public void setStatus(String stats){
			this.Status = stats;
		}
		public void setLastlocation(String lastloc){
			this.Lastlocation=lastloc;
		}
		public void setExparrival(String exparr){
			this.Exparrival=exparr;
		}
		public void setLate(String l){
			this.Late=l;
		}
		public void setDestination(String dest){
			this.Destination=dest;
		}
		public void setScharrival(String scharr){
			this.Scharrival=scharr;
		}
		public void setExpdepart(String expdep){
			this.Expdepart=expdep;
		}
		public void setDuein(String Due){
			this.Duein = Due;
		}
		public void setOrigintime(String o){
			this.Origintime = o;
		}
		public void setSchdepart(String sdep){
			this.Schdepart = sdep;
		}
	}
%>

<%
	/*############################################################*/
	/*Scrape and store data from xml files*/
	/*############################################################*/
	
	String code = request.getParameter("code");
	String timeframe = request.getParameter("timeframe");
	//Set default value for handling inappropriate input.
	if(!NumberUtils.isNumber(timeframe)){
		timeframe="20";
	}
	
	String url = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode="+code+"&NumMins="+timeframe;
	Document pag = Jsoup.connect(url).get();
	Elements tags=pag.select("Stationfullname, Traindate, Origin, Destination, Origintime, Destinationtime, Status, Lastlocation, Duein, Late, Exparrival, Expdepart, Scharrival, Schdepart");
	LinkedList<StationData> StationObjects = new LinkedList<StationData>();
	LinkedList<String> DataStrings = new LinkedList<String>();
	
	/*############################################################*/
	/*Copy data from first data list to a list  of StationData objects*/
	/*############################################################*/
	
	int numberofObjects = tags.size()/14;
	int c;
	
	for(c=0;c<numberofObjects;c++){
		StationData DataObject = new StationData();
		
		DataObject.setStationfullname(tags.get(0 + (14*c)).html());
		DataObject.setTraindate(tags.get(1 + (14*c)).html());
		DataObject.setOrigin(tags.get(2 + (14*c)).html());
		DataObject.setDestination(tags.get(3 + (14*c)).html());
		DataObject.setOrigintime(tags.get(4 + (14*c)).html());
		DataObject.setDestinationtime(tags.get(5 + (14*c)).html());
		DataObject.setStatus(tags.get(6 + (14*c)).html());
		DataObject.setLastlocation(tags.get(7 + (14*c)).html());
		DataObject.setDuein(tags.get(8 + (14*c)).html());
		DataObject.setLate(tags.get(9 + (14*c)).html());
		DataObject.setExparrival(tags.get(10 + (14*c)).html());
		DataObject.setExpdepart(tags.get(11 + (14*c)).html());
		DataObject.setScharrival(tags.get(12 + (14*c)).html());
		DataObject.setSchdepart(tags.get(13 + (14*c)).html());
		
		StationObjects.add(DataObject);
	}
	
	/*############################################################*/
	/*Read in lat, long and name for each station from file--*/
	/*############################################################*/
	String[] stationparts = null;
	LinkedList<String[]> stationpartslist = new LinkedList<String[]>();
	
	ServletContext context = session.getServletContext();
	InputStream is = context.getResourceAsStream("webapp/latandlong.html");
	
	BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
	while(true){
		String line= br.readLine();
		if( line == null ){
			break;
		}
		if (line.contains(code)){
			stationparts = line.split(" ");
			stationparts[3]=stationparts[3].replace("-"," ");
			break;
		}
	}
	
	/*############################################################*/
	/*Get Weather code*/
	/*############################################################*/
	
	Double lat1 = Double.parseDouble(stationparts[1]);
	Double lon1 = Double.parseDouble(stationparts[2]);
	
	String url2 = "http://api.openweathermap.org/data/2.5/weather?lat="+lat1+"&lon="+lon1+"&mode=xml&APPID=766c289bf98959c21f2fb7a5295fb69d";
	Document pag2 = Jsoup.connect(url2).get();
	Elements tags2=pag2.select("weather");
	
	String weather = tags2.get(0).toString();
	
	weather=weather.substring(weather.indexOf('"')+1);
	weather=weather.substring(0,weather.indexOf('"'));
	
	/*############################################################*/
	/*Get Weather Info from file based on code*/
	/*############################################################*/
	
	String [] weatherparts = null;
	String weatherinfo = new String();
	
	ServletContext context2 = session.getServletContext();
	InputStream is2 = context2.getResourceAsStream("webapp/weathercodes.html");
	
	BufferedReader br2 = new BufferedReader(new InputStreamReader(is2, "UTF-8"));
	while(true){
		String line= br2.readLine();
		if( line == null ){
			break;
		}
		if (line.contains(weather)){
			weatherparts = line.split(" ");
			
			break;
		}
	}
	
	for(c=1;c<weatherparts.length;c++){
		weatherinfo+=weatherparts[c]+" ";	
	}
	
	/*############################################################*/
	/*Get Weather Message from file based on code, or from jsp for exceptions*/
	/*############################################################*/
	
	String weatherimage = new String();
	String [] messageparts = null;
	String message = new String();
	
	ServletContext context3 = session.getServletContext();
	InputStream is3 = context3.getResourceAsStream("webapp/weatherinfo.html");
	
	BufferedReader br3 = new BufferedReader(new InputStreamReader(is3, "UTF-8"));
	
	if(weather.equals("800")){
		message="It's a nice clear day!";
		weatherimage="sun.png";
	}
	else if(Integer.parseInt(weather)>950 && Integer.parseInt(weather)<956){
		message="Not too windy out today!";
		weatherimage="sun.png";
	}
	else if(Integer.parseInt(weather)==956){
		message="There's a strong breeze out there. Be careful!";
		weatherimage="wind.png";
	}
	else if(Integer.parseInt(weather)>956 && Integer.parseInt(weather)<963){
		message="Extremely dangerous conditions out there! Stay inside!";
		weatherimage="extreme.png";
	}
	else{
		if(weather.charAt(0)=='2'){
			weatherimage="thunderstorm.png";
		}
		if(weather.charAt(0)=='3' || weather.charAt(0)=='5'){
			weatherimage="rain.png";
		}
		if(weather.charAt(0)=='6'){
			weatherimage="snow.png";
		}
		if(weather.charAt(0)=='7'){
			weatherimage="fog.png";
		}
		if(weather.charAt(0)=='8'){
			weatherimage="cloud.png";
		}
		if(weather.charAt(0)=='9'){
			weatherimage="extreme.png";
		}
		
		while(true){
			String line= br3.readLine();
			if( line == null ){
				break;
			}
			if (line.contains(""+weather.charAt(0))){
				messageparts = line.split(" ");
				
				break;
			}
		}
		
		for(c=1;c<messageparts.length;c++){
			message+=messageparts[c]+" ";	
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Commuter Info</title>
		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		
		<!-- Link to CSS file -->
		<link rel="stylesheet" type="text/css" href="style.css">
		
		<!-- Bootstrap includes (jQuery included too!) -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
		
		<!-- These scrips NEED to go below the bootstrap includes, otherwise the grahp defaults are overwritten -->
		<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript"></script>
		<script src="http://code.highcharts.com/highcharts.js" type="text/javascript"></script>
		<script src="http://code.highcharts.com/modules/exporting.js" type="text/javascript"></script>
		<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css" />
	</head>
	
	<body>
	
		<!-- Navigation bar -->
		<nav class="navbar navbar-default">
			<div class="container-fluid">
				
				<!-- Logo -->
				<div class="navbar-header">
					<a href="home.html"><img style="height: 50px" src="Trainlogo.png"></a>
				</div>
				
				<!-- Menu Items -->
				<div>
					<ul class="nav navbar-nav pull-right">
						<li><a href="home.html">Home</a></li>
					</ul>
				</div>
				
			</div>
		</nav>
		
		<!-- The map, needs to be under the navbar in html files for proper alignment -->
		<div style="float: left; width: 48%; margin-right: 70px; margin-top: 15px;">
		
			<div class="map_buttons">
				<button class="btn-sm btn-success" onclick="centerMap()">Center Map</button>
			</div>
			
			<div class="map_section" id="mapid"></div>
		</div>
	
	
		<!-- Train and weather info -->
		<%
			if(StationObjects.size()>0){
				
				out.print("<div id=\"info_panel\" class=\"side_section\" style='margin-top: 25px;'>");
			
				out.print("<h2 style=\"text-align: center; font-size: 28px; margin-bottom: 15px; margin-top: 8px;\">Trains approaching " + stationparts[3] + "</h2>");
			
				out.print("<table class=\"table table-hover table-striped\">");
				
				out.print("<thead><tr><th>Origin</th><th>Due in</th><th>Destination</th><th>Expected Arrival</th></tr></thead>");
				
				out.print("<tbody>");
				
				for(StationData z: StationObjects){
					out.print("<tr><td>" + z.getOrigin()+"</td>" + "<td>" + z.getDuein() +"</td>"+ "<td>" + z.getDestination() + "</td>"+ "<td>" + z.getDestinationtime()+"</td></tr>");
				}
				
				out.print("</tbody>");
				out.print("</table>");
				out.print("</div>");
			}
			
			else {
				out.print("<div id=\"info_panel\" class=\"side_section\" style=\"border: 0px; padding: 0px; margin-top: 25px;\">");
				out.print("<div class=\"alert alert-danger fade in\">");
				out.print("<p style=\"font-size: 16px; font-weight: bold;\" >No realtime train information is currently available for " + stationparts[3] + "!</p>");
				out.print("<br><a href=\"home.html\" style=\"font-size: 16px; color: #a94442;\" >Want to go back and choose another station?</a>");
				out.print("</div>");
				out.print("</div>");
			}
		%>
		
		<%
			out.print("<div id=\"info_panel\" class=\"side_section\">");
			
			out.print("<h2 style=\"text-align: center; font-size: 28px; margin-bottom: 15px; margin-top: 8px;\">Local Weather Conditions" + "</h2><br>");
			out.print("<p style='text-align: center' class=\"weather_info_text\" >Current weather:  " + weatherinfo + "</p><img style='display: block;margin: 0 auto;height: 50px; width: 50px;' src='icons/" + weatherimage + "'><br>");
			
			out.print("<div class=\"alert alert-info fade in\">");
			out.print("<a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><p style=\"text-align:center;font-size: 16px; font-weight: bold;\" >" + message + "</p>");
			out.print("</div>");
	
			out.print("</div>");
		%>
		<!-- End of train and weather info -->
		
		<script src="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js"></script>
		<script>
			var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			maxZoom: 18, attribution: '<a src="https://www.openstreetmap.org/">OpenStreetMap</a>' });

			var mymap = L.map('mapid', { center: new L.LatLng(53.1, -7.78381), zoom: 7, layers: [osm] });

			L.marker([<%out.println(lat1+","+lon1);%>]).addTo(mymap)
				.bindPopup("<%out.print(stationparts[3]);%>").openPopup();

			L.circle([<%out.println(lat1+","+lon1);%>], 10000, {
				color: 'blue',
				fillColor: '#00ccff',
				fillOpacity: 0.5
			}).addTo(mymap).bindPopup("<p style='display:block;margin:auto 0'><% out.print(stationparts[3]);%></p>");

			var popup = L.popup();

			function centerMap(){
				mymap.setView([53.1, -7.78381], 7);
			}
		</script>
		
	</body>
</html>
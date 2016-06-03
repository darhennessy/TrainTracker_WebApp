<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="javax.swing.JOptionPane" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.commons.lang3.ArrayUtils" %>
<%@ page import="org.apache.commons.lang3.math.NumberUtils" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>

<%!
	/*############################################################*/
	/*Create class for storing current train data*/
	/*############################################################*/
	
	public class CurrentTrainData {
		private String PublicMessage;
		private String Direction;
		private String Lat;
		private String Lon;
		
		public String getPublicMessage(){
			return this.PublicMessage;
		}
		public String getDirection(){
			return this.Direction;
		}
		public String getLongitude(){
			return this.Lon;
		}
		public String getLatitude(){
			return this.Lat;
		}
		
		public void setPublicMessage(String PublicMessage){
			this.PublicMessage = PublicMessage;
		}
		public void setDirection(String Direction){
			this.Direction = Direction;
		}
		public void setLongitude(String Lon){
			this.Lon = Lon;
		}
		public void setLatitude(String Lat){
			this.Lat = Lat;
		}
		
	}
%>

<%
	/*############################################################*/
	/*Scrape and store data from xml file*/
	/*############################################################*/
	
	String url = "http://api.irishrail.ie/realtime/realtime.asmx/getCurrentTrainsXML";
	Document pag = Jsoup.connect(url).get();
	Elements tags=pag.select("PublicMessage,Direction,TrainLatitude,TrainLongitude");
	LinkedList<CurrentTrainData> TrainObjects = new LinkedList<CurrentTrainData>();
	LinkedList<String> DataStrings = new LinkedList<String>();
	
	/*############################################################*/
	/*Copy data from data list to a list of CurrentTrainData objects*/
	/*############################################################*/
	
	int numberofObjects = tags.size()/4;
	int c;
	
	for(c=0;c<numberofObjects;c++){
	
		CurrentTrainData DataObject = new CurrentTrainData();

		DataObject.setLatitude(tags.get(0 + (4*c)).html());
		DataObject.setLongitude(tags.get(1 + (4*c)).html());
		DataObject.setPublicMessage(tags.get(2 + (4*c)).html());
		DataObject.setDirection(tags.get(3 + (4*c)).html());
		
		TrainObjects.add(DataObject);
	}
	
	for (Iterator<CurrentTrainData> iter = TrainObjects.listIterator(); iter.hasNext(); ) {
		CurrentTrainData as = iter.next();
		if (as.getLatitude().equals("0")) {
			iter.remove();
			numberofObjects--;
		}
	}
	
	/*
	for(CurrentTrainData l: TrainObjects){
		out.print(l.getLatitude() + " " + l.getLongitude() + "</br>");
	}
	*/
	
	/*############################################################*/
	/*Create a list containing lists, each consisting of the same train direction,*/
	/*in order to identify how many trains are going the same way.*/
	/*############################################################*/
	
	LinkedList<LinkedList<String>> DirectionLists = new LinkedList<LinkedList<String>>();
	LinkedList<Float> SizeList = new LinkedList<Float>();
	
	LinkedList<String> list = new LinkedList<String>();
	
	if(numberofObjects>0){
		/*############################################################*/
		/*add first direction to first list, as the logic requires for there to be at least one list*/
		/*############################################################*/
		
		list.add(TrainObjects.get(0).getDirection());
		DirectionLists.add(list);
		
		Boolean matches=false;
		int c2;
		for(c=0;c<numberofObjects;c++){
			matches=false;
			
			/*############################################################*/
			/*if a list already exists for the direction add it to the end*/
			/*############################################################*/
			
			for(c2=0;c2<DirectionLists.size();c2++){
				if(DirectionLists.get(c2).get(0).equals(TrainObjects.get(c).getDirection())){
					matches=true;
					DirectionLists.get(c2).add(TrainObjects.get(c).getDirection());
				}
			}
			
			/*############################################################*/
			/*if no list exists yet for the direction, make one*/
			/*############################################################*/
			
			if(matches==false){
				LinkedList<String> newlist = new LinkedList<String>();
				newlist.add(TrainObjects.get(c).getDirection());
				DirectionLists.add(newlist);
			}
		}
		
		/*############################################################*/
		/*remove first element of first list, as it will have been added twice*/
		/*############################################################*/
		DirectionLists.get(0).removeFirst();
	}
	
	/*############################################################*/
	/*make list containing the sizes of each of the direction lists, for use in calculating sizes for pie chart segments*/
	/*############################################################*/
	
	for(LinkedList<String> r: DirectionLists){
		SizeList.add((r.size()/(float)numberofObjects)*100);
	}
	
	LinkedList<String> latetimes = new LinkedList<String>();
	LinkedList<Integer> lateints = new LinkedList<Integer>();
	LinkedList<CurrentTrainData> lateobjects = new LinkedList<CurrentTrainData>();
	
	for(CurrentTrainData l: TrainObjects){
		String latetime=l.getPublicMessage();
		latetime=latetime.substring(latetime.indexOf("(")+1);
		latetime = latetime.substring(0,latetime.indexOf(" "));
		
		latetimes.add(latetime);
		
		if(NumberUtils.isNumber(latetime) && Integer.parseInt(latetime)>0){
			lateints.add(Integer.parseInt(latetime));
			lateobjects.add(l);
		}
	}
	
	int c2;
	for(c=0;c<lateints.size();c++){
		for(c2=c+1;c2<lateints.size();c2++){
			if(lateints.get(c2)<lateints.get(c)){
				Collections.swap(lateints, c2, c);
				Collections.swap(lateobjects, c2, c);
			}
		}
	}
	
	/*############################################################*/
	/*Adjust co ordinates slightly to remove duplicates*/
	/*############################################################*/
	
	/*out.print(latetimes.size()+ "</br>");
	out.print(TrainObjects.size()+"</br>");*/
	
	/*double latCorrection = 0.00001;
	double lonCorrection = 0.00001;
	
	for (int i = 0; i < TrainObjects.size(); i++) {

		for (int j = i+1; j < TrainObjects.size(); j++) {
			
			// Refactor the latitude
			if (TrainObjects.get(i).getLatitude() == TrainObjects.get(j).getLatitude()) {
				
				double temp = Double.parseDouble(TrainObjects.get(j).getLatitude());
				temp += latCorrection;
				TrainObjects.get(j).setLatitude(String.valueOf(temp));
				
				latCorrection += 0.00001;
			}
			
			// Refactor the longitude
			if (TrainObjects.get(i).getLongitude() == TrainObjects.get(j).getLongitude()) {
				
				double temp = Double.parseDouble(TrainObjects.get(j).getLongitude());
				temp += lonCorrection;
				TrainObjects.get(j).setLongitude(String.valueOf(temp));
				
				lonCorrection += 0.00001;
			}
		}
	}*/
	
	int y=0;
	
	/*
	for(CurrentTrainData s: TrainObjects){
		out.print(s.getPublicMessage()+"</br>");
		out.print(s.getLatitude() + " " + s.getLongitude() + "</br>");
		out.print("  boop "+latetimes.get(y) + "</br>");
		y++;
	}
	
	y=0;
	for(CurrentTrainData s: TrainObjects){
		out.print(s.getPublicMessage()+"</br>");
		out.print(s.getLatitude() + " " + s.getLongitude() + "</br>");
		out.print("  boop "+latetimes.get(y) + "</br>");
		y++;
	}
	*/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Current Trains</title>
		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		
		<!-- Link to CSS file -->
		<link rel="stylesheet" type="text/css" href="style.css">
		
		<!-- Bootstrap includes (jQuery included too!) -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
		
		<!-- Other includes need to be below the bootstrap includes, or the map and graph stuff is overwritten -->
		<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript"></script>
			
		<script src="http://code.highcharts.com/highcharts.js" type="text/javascript"></script>
		<script src="http://code.highcharts.com/modules/exporting.js" type="text/javascript"></script>
			
		<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css" />
		<script src="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js"></script>
		
		<link rel="stylesheet" type="text/css" href="leaflet-openweathermap.css" />
		<script type="text/javascript" src="leaflet-openweathermap.js"></script>

		<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css" />
	</head>
	
	<body onload="sortMarkers(); addAll()">
		
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
		<div style="float: left; width: 48%; margin-right: 55px; margin-top: 15px;">
		
			<div class="map_buttons">
				<!-- Align top left -->
				<button class="btn-sm btn-success" onclick="centerMap()">Center Map</button>
				
				<!-- Align top right -->
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="clearWeather()">Clear Weather</button>
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="addRain()">Show Rain</button>
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="addSnow()">Show Snow</button>
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="addWind()">Show Wind</button>
			</div>
			
			<div class="map_section" id="mapid"></div>
			
			<div class="map_buttons" style="padding-bottom: 10px; margin-top: 0px;">
				<button style="margin-right: -3px;" class="btn-sm btn-success" onclick="addAll()">All Trains</button>
				<button style="margin-right: -3px;" class="btn-sm btn-success" onclick="showLate()">All Late</button>
				<button style="margin-right: -3px;" class="btn-sm btn-success" onclick="showRunning()">All Running</button>
			</div>
		</div>
		
		<%
			if(numberofObjects>0){
				
				out.print("<div id=\"info_panel\" class=\"side_section\" style=\"width: 42%; padding:10px; margin-top: 15px;\" >");
			
				out.print("<h2 style=\"text-align: center; font-size: 28px; margin-bottom: 15px; margin-top: 8px;\">Latest Trains</h2>");
				
				out.print("<table class=\"table table-hover table-striped table-bordered\">");
				
				out.print("<thead><tr><th>Train Status</th></tr></thead>");
				
				out.print("<tbody>");
				
				int g=0;
				
				if(lateints.size()<6){
					
					for(Integer x: lateints){
						String messagepart1 = lateobjects.get(g).getPublicMessage().substring(0, lateobjects.get(g).getPublicMessage().indexOf('\\'));
						String messagepart2 = " - " + lateobjects.get(g).getPublicMessage().substring(lateobjects.get(g).getPublicMessage().indexOf('\\')+2);
						String message = messagepart1+messagepart2;
						messagepart1=message.substring(0, message.indexOf('\\'));
						messagepart2 = " - " + message.substring(message.indexOf('\\')+2);
						message=messagepart1+messagepart2;
						
						out.print("<tr style='cursor:pointer' onclick='latetrain"+ g + "()'><td>" + message+ "</td></tr>");
						g++;
					}
				}
				
				else {
					int u=0;
					for(g=lateints.size()-5;g<lateints.size();g++){
						String messagepart1 = lateobjects.get(g).getPublicMessage().substring(0, lateobjects.get(g).getPublicMessage().indexOf('\\'));
						String messagepart2 = " - " + lateobjects.get(g).getPublicMessage().substring(lateobjects.get(g).getPublicMessage().indexOf('\\')+2);
						String message = messagepart1+messagepart2;
						messagepart1=message.substring(0, message.indexOf('\\'));
						messagepart2 = " - " + message.substring(message.indexOf('\\')+2);
						message=messagepart1+messagepart2;
						
						out.print("<tr style='cursor:pointer' onclick='latetrain"+ u + "()'><td>" + message+ "</td></tr>");
						u++;
					}
				}
				
				out.print("</tbody>");
				out.print("</table>");
				out.print("</div>");
			}
			
			else {
				out.print("<div id=\"info_panel\" class=\"side_section\" style=\"border: 0px; padding: 0px;\">");
				out.print("<div class=\"alert alert-danger fade in\">");
				out.print("<p style=\"font-size: 16px; font-weight: bold;\" >No realtime train information is currently available!<br></p>");
				out.print("<br><a href=\"home.html\" style=\"font-size: 16px; color: #a94442;\" >Want to go back and choose another option?</a>");
				out.print("</div>");
				out.print("</div>");
			}
		%>
		
		
		
		<!-- The graph-->
		<%
			if(numberofObjects>0){
				out.print("<div class='side_section' id='container'></div>");
			}
			else{
				out.print("<div id=\"info_panel\" class=\"side_section\" style=\"border: 0px; padding: 0px;\">");
				out.print("<div class=\"alert alert-danger fade in\">");
				out.print("<p style=\"font-size: 16px; font-weight: bold;\" >A graph can't be generated right now. There are no running trains!<br></p>");
				out.print("<br><a href=\"home.html\" style=\"font-size: 16px; color: #a94442;\" >Want to go back and choose another option?</a>");
				out.print("</div>");
				out.print("</div>");
			}
		%>
		
		<script>
			function centerMap(){
				mymap.setView([53.1, -7.78381], 7);
			}
			function zoomOut(){
				mymap.setView([53.1, -7.78381], 5);
			}
			
			var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			maxZoom: 18, attribution: '<a src="https://www.openstreetmap.org/">OpenStreetMap</a>' });

			var snow = L.OWM.snow({showLegend: true, opacity: 0.5 ,apiId: '766c289bf98959c21f2fb7a5295fb69d'});
			var wind = L.OWM.wind({showLegend: true, opacity: 0.5 ,apiId: '766c289bf98959c21f2fb7a5295fb69d'})
			var rain = L.OWM.rainClassic({showLegend: true, opacity: 0.5 ,apiId: '766c289bf98959c21f2fb7a5295fb69d'})
			
			var mymap = L.map('mapid', { center: new L.LatLng(53.1, -7.78381), zoom: 7, layers: [osm] });

			var snowon=false;
			var windon=false;
			var rainon=false;
			
			//functions for adding weather layers to map
			function addSnow(){
				if(snowon==false){
					zoomOut();
					mymap.addLayer(snow);
					snowon=true;
				}
				if(windon==true){
					mymap.removeLayer(wind);
					windon=false;
				}
				if(rainon==true){
					mymap.removeLayer(rain);
					rainon=false;
				}
			}
			
			function addRain(){
				if(snowon==true){
					mymap.removeLayer(snow);
					snowon=false;
				}
				if(windon==true){
					mymap.removeLayer(wind);
					windon=false;
				}
				if(rainon==false){
					zoomOut();
					mymap.addLayer(rain);
					rainon=true;
				}
			}
			
			function addWind(){
				if(snowon==true){
					mymap.removeLayer(snow);
					snowon=false;
				}
				if(windon==false){
					zoomOut();
					mymap.addLayer(wind);
					windon=true;
				}
				if(rainon==true){
					mymap.removeLayer(rain);
					rainon=false;
				}
			}
			
			function clearWeather(){
				mymap.removeLayer(rain);
				rainon=false;
				mymap.removeLayer(snow);
				snowon=false;
				mymap.removeLayer(wind);
				windon=false;
			}
			
			//Make Late train pop up functions
			var popup2;
			<%
				int r=0;
				if(lateints.size()<6){
					for(CurrentTrainData l : lateobjects){
						out.print("function latetrain" + r + "(){popup2 = L.popup().setLatLng(new L.LatLng("+lateobjects.get(r).getLatitude()+","+ lateobjects.get(r).getLongitude()+")).setContent('"+ lateobjects.get(r).getPublicMessage()+ "').openOn(mymap);}");
						r++;
					}
				}
				else{
					for(c=lateobjects.size()-5;c<lateobjects.size();c++){
						out.print("function latetrain" + r + "(){popup2 = L.popup().setLatLng(new L.LatLng("+lateobjects.get(c).getLatitude()+","+ lateobjects.get(c).getLongitude()+")).setContent('"+ lateobjects.get(c).getPublicMessage()+ "').openOn(mymap);}");
						r++;
					}
				}
			%>
			
			//Create lists of markers, one for early, late, on time and still to depart trains.
			var marker;
			
			var early = [];
			var late = [];
			var ontime = [];
			var todepart = [];
			
			var onmap=false;
			
			//Populate lists
			function sortMarkers() {
				var latlng;
				<%
					int i=0;
					for(CurrentTrainData s: TrainObjects){
						if(Double.parseDouble(s.getLatitude())!=0){
							out.println("latlng = L.latLng(" + s.getLatitude() + "," + s.getLongitude() +");marker = new L.Marker(latlng");
							if(NumberUtils.isNumber(latetimes.get(i))){
								if(Double.parseDouble(latetimes.get(i))>0){
									out.println(");marker.bindPopup('" + s.getPublicMessage() + "');late.push(marker);");
								}
								else if(Double.parseDouble(latetimes.get(i))<0){
									out.println(");marker.bindPopup('" + s.getPublicMessage() + "');early.push(marker);");
								}
								else{
									out.println(");marker.bindPopup('" + s.getPublicMessage() + "');ontime.push(marker);");
								}
							}
							else{
								out.println(");marker.bindPopup('" + s.getPublicMessage() + "');todepart.push(marker);");
							}
						}
						i++;
					}
				%>
			};
			
			//boolean variables for use in identifying whether or not to remove or add particular markers.
			var earlyon = false;
			var lateon = false;
			var ontimeon = false;
			var todeparton = false;
			
			//add and remove all markers
			function addAll(){
				addEarly();
				addLate();
				addTodepart();
				addOntime();
			}
			function removeAll(){
				removeEarly();
				removeLate();
				removeOntime();
				removeTodepart();
			}
			
			//create a function for each list to add it's contents to the map
			function addEarly(){
				var i;
				if(earlyon == false){
					for(i=0;i<early.length;i++){
						mymap.addLayer(early[i]);
					}
					earlyon=true;
				}
			}
			function addLate(){
				var i;
				if(lateon == false){
					for(i=0;i<late.length;i++){
						mymap.addLayer(late[i]);
					}
					lateon=true;
				}
			}
			function addOntime(){
				var i;
				if(ontimeon == false){
					for(i=0;i<ontime.length;i++){
						mymap.addLayer(ontime[i]);
					}
					ontimeon=true;
				}
			}
			function addTodepart(){
				var i;
				if(todeparton == false){
					for(i=0;i<todepart.length;i++){
						mymap.addLayer(todepart[i]);
					}
					todeparton=true;
				}
			}
			
			//create function for removal of each element in each list
			function removeEarly(){
				earlyon=false;
				var i;
				for(i=0;i<early.length;i++){
					mymap.removeLayer(early[i]);
				}
			}
			function removeLate(){
				lateon=false;
				var i;
				for(i=0;i<late.length;i++){
					mymap.removeLayer(late[i]);
				}
			}
			function removeOntime(){
				ontimeon=false;
				var i;
				for(i=0;i<ontime.length;i++){
					mymap.removeLayer(ontime[i]);
				}
			}
			function removeTodepart(){
				todeparton=false;
				var i;
				for(i=0;i<todepart.length;i++){
					mymap.removeLayer(todepart[i]);
				}
			}
			
			//Function to show just late trains and remove all others.
			
			function showLate(){
				if(earlyon){
					removeEarly();
					earlyon=false;
				}
				if(todeparton){
					removeTodepart();
					todeparton=false;
				}
				if(ontimeon){
					removeOntime();
					ontimeon=false;
				}
			}
			function showRunning(){
				if(!earlyon){
					addEarly();
					ontimeon=true;
				}
				if(todeparton){
					removeTodepart();
					todeparton=false;
				}
				if(!ontimeon){
					addOntime();
					ontimeon=true;
				}
				if(!lateon){
					addLate();
					lateon=true;
				}
			}

		</script>

		<script>
			$(function () {
				$(document).ready(function () {

					// Build the chart
					$('#container').highcharts({
						chart: {
							plotBackgroundColor: null,
							plotBorderWidth: null,
							plotShadow: false,
							type: 'pie'
						},
						title: {
							text: 'Irish trains currently running and their destinations'
						},
						tooltip: {
							pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
						},
						plotOptions: {
							pie: {
								allowPointSelect: true,
								cursor: 'pointer',
								dataLabels: {
									enabled: false
								},
								showInLegend: true
							}
						},
						series: [{
							name: 'trains',
							colorByPoint: true,
							data: 
							
							<%
								out.print("[");
								for(c=0;c<SizeList.size();c++){
									out.println("{\nname: '" + DirectionLists.get(c).get(0) + "',\ny: " + SizeList.get(c) + "}");
									if(c<SizeList.size()-1){
										out.println(",");
									}
								}
								out.println("]");
							%>
						}]
					});
				});
			});
		</script>
		
		
		
		
	</body>
</html>
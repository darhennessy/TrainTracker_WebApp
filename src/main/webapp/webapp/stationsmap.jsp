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
	
	String range=request.getParameter("range");
	
	//Set default value for handling inappropriate input
	if(!NumberUtils.isNumber(range)){
		range="20";
	}
	String code = request.getParameter("code");
	String url = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode="+code+"&NumMins=25";
	Document pag = Jsoup.connect(url).get();
	Elements tags=pag.select("Stationfullname, Traindate, Origin, Destination, Origintime, Destinationtime, Status, Lastlocation, Duein, Late, Exparrival, Expdepart, Scharrival, Schdepart");
	LinkedList<StationData> StationObjects = new LinkedList<StationData>();
	LinkedList<String> DataStrings = new LinkedList<String>();
	
	String code2 = request.getParameter("code2");
	String url2 = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode="+code2+"&NumMins=25";
	Document pag2 = Jsoup.connect(url2).get();
	Elements tags2 =pag2.select("Stationfullname, Traindate, Origin, Destination, Origintime, Destinationtime, Status, Lastlocation, Duein, Late, Exparrival, Expdepart, Scharrival, Schdepart");
	LinkedList<StationData> StationObjects2 = new LinkedList<StationData>();
	LinkedList<String> DataStrings2 = new LinkedList<String>();
	
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
	/*Copy data from second data list to a list  of StationData objects*/
	/*############################################################*/
	
	int numberofObjects2 = tags2.size()/14;
	int c2;
	
	for(c2=0;c2<numberofObjects2;c2++){
		StationData DataObject2 = new StationData();
		
		DataObject2.setStationfullname(tags2.get(0 + (14*c2)).html());
		DataObject2.setTraindate(tags2.get(1 + (14*c2)).html());
		DataObject2.setOrigin(tags2.get(2 + (14*c2)).html());
		DataObject2.setDestination(tags2.get(3 + (14*c2)).html());
		DataObject2.setOrigintime(tags2.get(4 + (14*c2)).html());
		DataObject2.setDestinationtime(tags2.get(5 + (14*c2)).html());
		DataObject2.setStatus(tags2.get(6 + (14*c2)).html());
		DataObject2.setLastlocation(tags2.get(7 + (14*c2)).html());
		DataObject2.setDuein(tags2.get(8 + (14*c2)).html());
		DataObject2.setLate(tags2.get(9 + (14*c2)).html());
		DataObject2.setExparrival(tags2.get(10 + (14*c2)).html());
		DataObject2.setExpdepart(tags2.get(11 + (14*c2)).html());
		DataObject2.setScharrival(tags2.get(12 + (14*c2)).html());
		DataObject2.setSchdepart(tags2.get(13 + (14*c2)).html());
		
		StationObjects2.add(DataObject2);
	}
	
	/*############################################################*/
	/*Read in lat, long and name for each station from file--*/
	/*############################################################*/
	
	String[] stationparts = null;
	String[] stationparts2 = null;
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
		}
		if (line.contains(code2)){
			stationparts2 = line.split(" ");
			stationparts2[3]=stationparts2[3].replace("-"," ");
		}
		else{
			String[] remparts = line.split(" ");
			remparts[3]=remparts[3].replace("-"," ");
			stationpartslist.add(remparts);
		}
	}

	/*############################################################*/
	/*Calculate distance on Earth's surface between stations using Haversine formula*/
	/*############################################################*/
	
	/*out.println("lat: " + stationparts[1] + " long: " + stationparts[2] + "</br>");
	out.println("lat: " + stationparts2[1] + " long: " + stationparts2[2]);*/
	
	final int R = 6371;
	
	Double lat1 = Double.parseDouble(stationparts[1]);
	Double lon1 = Double.parseDouble(stationparts[2]);
	Double lat2 = Double.parseDouble(stationparts2[1]);
	Double lon2 = Double.parseDouble(stationparts2[2]);
	
	Double latDistance = Math.toRadians(lat2-lat1);
	Double lonDistance = Math.toRadians(lon2-lon1);
	
	Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2) * Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2));
	Double x = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	Double distance= R * x;
	
	/*out.println("Distance: " + distance);*/
		
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Stations</title>
		
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
	
	<body style="overflow-x:hidden">
	
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
		
		<div style="float: left; width: 50%; margin-right: 70px; margin-top: 15px;">
		
			<div class="map_buttons">
				<!-- Align top left -->
				<button class="btn-sm btn-success" onclick="centerMap()">Center Map</button>
				
				<!-- Align top right -->
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="clearWeather()">Clear Weather</button>
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="addRain()">Show Rain</button>
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="addSnow()">Show Snow</button>
				<button style="float:right; margin-left: 1px;" class="btn-sm btn-success" onclick="addWind()">Show Wind</button>
			</div>
		
			<!-- The map, needs to be under the navbar in html files for proper alignment -->
			<div class="map_section" id="mapid"></div>
			
			<div class="map_buttons" style="padding-bottom: 10px; margin-top: 0px;">
				<button style="margin-right: -3px;" class="btn-sm btn-success" onclick="addMarkers()">Show All</button>
				<button style="margin-right: -3px;" class="btn-sm btn-success" onclick="removeMarkers()">Hide</button>
				<button style="margin-right: -3px;" class="btn-sm btn-success" onclick="stationsDistance()">Distance</button>
			</div>
		</div>
		
	
		<!-- Station information -->
		<%
				out.print("<div id=\"info_panel\" class=\"side_section\" style=\"margin-top: 15px; margin-bottom: 10px;\" >");
				
				out.print("<h2 style=\"text-align: center; font-size: 28px; margin-bottom: 15px; margin-top: 8px;\">Station Information</h2>");
		
				out.print("<table class=\"table table-hover table-striped\">");
				
				out.print("<thead><tr><th>Station Name</th><th>Trains</th><th>Location</th></tr></thead>");
				
				out.print("<tbody>");
				
				out.print("<tr><td>" + stationparts[3]+ "</td><td>"+numberofObjects+"</td><td>" +lat1+", "+lon1+"</td></tr>");
				out.print("<tr><td>" + stationparts2[3]+ "</td><td>"+numberofObjects2+"</td><td>" +lat2+", "+lon2+"</td></tr>");
				
				out.print("</tbody>");
				out.print("</table>");
				
				if(distance < (Double.parseDouble(range))*2) {
					out.print("<div class=\"alert alert-warning fade in\" style=\"margin-top: 30px; margin-bottom: 10px;\" >");
					out.print("<p style=\"text-align:center;font-size: 16px; font-weight: bold;\" >Stations are within range of one another!</p>");
					out.print("</div>");
				}
				
				out.print("</div>");
		%>
	
		<div class="side_section">
		<div class="well">
		
			<form class="form-horizontal" name="myForm" action="stationsmap.jsp" method="get" >
				<h2 style="text-align: center; margin-bottom: 18px; margin-top: 5px;">Select two other stations for comparison</h2>
				
				<div class="form-group">
					<label class="control-label col-sm-4">First Station</label>
					<select class="stationSelect form-control" name="code" style="width: 50%;">
						<option value='ADMTN'>Adamstown</option>
						<option value='ARHAN'>Ardrahan</option>
						<option value='ARKLW'>Arklow</option>
						<option value='ASHTN'>Ashtown</option>
						<option value='ATHRY'>Athenry</option>
						<option value='ATHY'>Athy</option>
						<option value='ATLNE'>Athlone</option>
						<option value='ATMON'>Attymon</option>
						<option value='BALNA'>Ballina</option>
						<option value='BBRDG'>Broombridge</option>
						<option value='BBRGN'>Balbriggan</option>
						<option value='BBRHY'>Ballybrophy</option>
						<option value='BCLAN'>Ballycullane</option>
						<option value='BFSTC'>Belfast Central</option>
						<option value='BHILL'>Birdhill</option>
						<option value='BMOTE'>Ballymote</option>
						<option value='BOYLE'>Boyle</option>
						<option value='BRAY'>Bray</option>
						<option value='BRGTN'>Bridgetown</option>
						<option value='BROCK'>Blackrock</option>
						<option value='BSLOE'>Ballinasloe</option>
						<option value='BTEER'>Banteer</option>
						<option value='BTSTN'>Booterstown</option>
						<option value='BYHNS'>Ballyhaunis</option>
						<option value='BYSDE'>Bayside</option>
						<option value='CAHIR'>Cahir</option>
						<option value='CCONL'>Castleconnell</option>
						<option value='CGLOE'>Carrigaloe</option>
						<option value='CGTWL'>Carrigtwohill</option>
						<option value='CHORC'>Cherry Orchard</option>
						<option value='CJRDN'>Cloughjordan</option>
						<option value='CKOSH'>Carrick on Shannon</option>
						<option value='CKOSR'>Carrick on Suir</option>
						<option value='CLARA'>Clara</option>
						<option value='CLBAR'>Castlebar</option>
						<option value='CLDKN'>Clondalkin</option>
						<option value='CLMEL'>Clonmel</option>
						<option value='CLMRS'>Claremorris</option>
						<option value='CLONF'>Clondalkin</option>
						<option value='CLSLA'>Clonsilla</option>
						<option value='CMINE'>Coolmine</option>
						<option value='CNLLY'>Dublin Connolly</option>
						<option value='CNOCK'>Castleknock</option>
						<option value='COBH'>Cobh</option>
						<option value='COLNY'>Collooney</option>
						<option value='CORK'>Cork</option>
						<option value='CPILE'>Campile</option>
						<option value='CRGHW'>Craughwell</option>
						<option value='CRLOW'>Carlow</option>
						<option value='CSREA'>Castlerea</option>
						<option value='CTARF'>Clontarf Road</option>
						<option value='CURAH'>Curragh</option>
						<option value='CVILL'>Charleville</option>
						<option value='DBATE'>Donabate</option>
						<option value='DBYNE'>Dunboyne</option>
						<option value='DCDRA'>Drumcondra</option>
						<option value='DCKLS'>Docklands</option>
						<option value='DDALK'>Dundalk</option>
						<option value='DGHDA'>Drogheda</option>
						<option value='DLERY'>Dun Laoghaire</option>
						<option value='DLKEY'>Dalkey</option>
						<option value='DRMOD'>Dromod</option>
						<option value='ECRTY'>Enniscorthy</option>
						<option value='ENFLD'>Enfield</option>
						<option value='ENNIS'>Ennis</option>
						<option value='ETOWN'>Edgeworthstown</option>
						<option value='FFORE'>Farranfore</option>
						<option value='FOTA'>Fota</option>
						<option value='FXFRD'>Foxford</option>
						<option value='GALWY'>Galway</option>
						<option value='GCDK'>Grand Canal Dock</option>
						<option value='GHANE'>Glounthaune</option>
						<option value='GLGRY'>Glenageary</option>
						<option value='GOREY'>Gorey</option>
						<option value='GORT'>Gort</option>
						<option value='GRGRD'>Clongriffin</option>
						<option value='GSTNS'>Greystones</option>
						<option value='GSTON'>Gormanston</option>
						<option value='HAFLD'>Hansfield</option>
						<option value='HAZEF'>Hazelhatch</option>
						<option value='HOWTH'>Howth</option>
						<option value='HSTON'>Dublin Heuston</option>
						<option value='HTOWN'>Harmonstown</option>
						<option value='HWTHJ'>Howth Junction</option>
						<option value='HZLCH'>Hazelhatch</option>
						<option value='KBRCK'>Kilbarrack</option>
						<option value='KCOCK'>Kilcock</option>
						<option value='KCOOL'>Kilcoole</option>
						<option value='KDARE'>Kildare</option>
						<option value='KILNY'>Killiney</option>
						<option value='KKNNY'>Kilkenny</option>
						<option value='KLRNY'>Killarney</option>
						<option value='KLSTR'>Killester</option>
						<option value='LBURN'>Lisburn</option>
						<option value='LDWNE'>Lansdowne Road</option>
						<option value='LFORD'>Longford</option>
						<option value='LMRCK'>Limerick</option>
						<option value='LMRKJ'>Limerick Junction</option>
						<option value='LSLND'>LittleIsland</option>
						<option value='LTOWN'>Laytown</option>
						<option value='LURGN'>Lurgan</option>
						<option value='LXCON'>Leixlip (Confey)</option>
						<option value='LXLSA'>Leixlip (Louisa Bridge)</option>
						<option value='M3WAY'>M3 Parkway</option>
						<option value='MDLTN'>Midleton</option>
						<option value='MHIDE'>Malahide</option>
						<option value='MLGAR'>Mullingar</option>
						<option value='MLLOW'>Mallow</option>
						<option value='MLSRT'>Millstreet</option>
						<option value='MNEBG'>Muine Bheag</option>
						<option value='MNLAJ'>Manulla Junction</option>
						<option value='MONVN'>Monasterevin</option>
						<option value='MYNTH'>Maynooth</option>
						<option value='NBRGE'>Newbridge</option>
						<option value='NEWRY'>Newry</option>
						<option value='NNAGH'>Nenagh</option>
						<option value='ORNMR'>Oranmore</option>
						<option value='PDOWN'>Portadown</option>
						<option value='PERSE'>Dublin Pearse</option>
						<option value='PHNPK'>Navan Road Parkway</option>
						<option value='PMNCK'>Portmarnock</option>
						<option value='PTLSE'>Portlaoise</option>
						<option value='PTRTN'>Portarlington</option>
						<option value='PWESF'>Cherry Orchard</option>
						<option value='RAHNY'>Raheny</option>
						<option value='RBROK'>Rushbrooke</option>
						<option value='RCREA'>Roscrea</option>
						<option value='RDRUM'>Rathdrum</option>
						<option value='RLEPT'>Rosslare Europort</option>
						<option value='RLSTD'>Rosslare Strand</option>
						<option value='RLUSK'>Rush and Lusk</option>
						<option value='RMORE'>Rathmore</option>
						<option value='RSCMN'>Roscommon</option>
						<option value='SALNS'>Sallins</option>
						<option value='SCOVE'>Sandycove</option>
						<option value='SEAPT'>Seapoint</option>
						<option value='SHILL'>Salthill</option>
						<option value='SIDNY'>Sydney Parade</option>
						<option value='SKILL'>Shankill</option>
						<option value='SKRES'>Skerries</option>
						<option value='SLIGO'>Sligo</option>
						<option value='SMONT'>Sandymount</option>
						<option value='SUTTN'>Sutton</option>
						<option value='SXMBR'>Sixmilebridge</option>
						<option value='TARA'>Tara Street</option>
						<option value='THRLS'>Thurles</option>
						<option value='THTWN'>Thomastown</option>
						<option value='TIPRY'>Tipperary</option>
						<option value='TMORE'>Tullamore</option>
						<option value='TPMOR'>Templemore</option>
						<option value='TRLEE'>Tralee</option>
						<option value='WBDGE'>Wellingtonbridge</option>
						<option value='WBROK'>Woodbrook</option>
						<option value='WFORD'>Waterford</option>
						<option value='WLAWN'>Woodlawn</option>
						<option value='WLOW'>Wicklow</option>
						<option value='WPORT'>Westport</option>
						<option value='WXFRD'>Wexford</option>
					</select>
				</div>
				
				<div class="form-group">
					<label class="control-label col-sm-4">Second Station</label>
					<select class="stationSelect form-control" name="code2" style="width: 50%;">
						<option value='ADMTN'>Adamstown</option>
						<option value='ARHAN'>Ardrahan</option>
						<option value='ARKLW'>Arklow</option>
						<option value='ASHTN'>Ashtown</option>
						<option value='ATHRY'>Athenry</option>
						<option value='ATHY'>Athy</option>
						<option value='ATLNE'>Athlone</option>
						<option value='ATMON'>Attymon</option>
						<option value='BALNA'>Ballina</option>
						<option value='BBRDG'>Broombridge</option>
						<option value='BBRGN'>Balbriggan</option>
						<option value='BBRHY'>Ballybrophy</option>
						<option value='BCLAN'>Ballycullane</option>
						<option value='BFSTC'>Belfast Central</option>
						<option value='BHILL'>Birdhill</option>
						<option value='BMOTE'>Ballymote</option>
						<option value='BOYLE'>Boyle</option>
						<option value='BRAY'>Bray</option>
						<option value='BRGTN'>Bridgetown</option>
						<option value='BROCK'>Blackrock</option>
						<option value='BSLOE'>Ballinasloe</option>
						<option value='BTEER'>Banteer</option>
						<option value='BTSTN'>Booterstown</option>
						<option value='BYHNS'>Ballyhaunis</option>
						<option value='BYSDE'>Bayside</option>
						<option value='CAHIR'>Cahir</option>
						<option value='CCONL'>Castleconnell</option>
						<option value='CGLOE'>Carrigaloe</option>
						<option value='CGTWL'>Carrigtwohill</option>
						<option value='CHORC'>Cherry Orchard</option>
						<option value='CJRDN'>Cloughjordan</option>
						<option value='CKOSH'>Carrick on Shannon</option>
						<option value='CKOSR'>Carrick on Suir</option>
						<option value='CLARA'>Clara</option>
						<option value='CLBAR'>Castlebar</option>
						<option value='CLDKN'>Clondalkin</option>
						<option value='CLMEL'>Clonmel</option>
						<option value='CLMRS'>Claremorris</option>
						<option value='CLONF'>Clondalkin</option>
						<option value='CLSLA'>Clonsilla</option>
						<option value='CMINE'>Coolmine</option>
						<option value='CNLLY'>Dublin Connolly</option>
						<option value='CNOCK'>Castleknock</option>
						<option value='COBH'>Cobh</option>
						<option value='COLNY'>Collooney</option>
						<option value='CORK'>Cork</option>
						<option value='CPILE'>Campile</option>
						<option value='CRGHW'>Craughwell</option>
						<option value='CRLOW'>Carlow</option>
						<option value='CSREA'>Castlerea</option>
						<option value='CTARF'>Clontarf Road</option>
						<option value='CURAH'>Curragh</option>
						<option value='CVILL'>Charleville</option>
						<option value='DBATE'>Donabate</option>
						<option value='DBYNE'>Dunboyne</option>
						<option value='DCDRA'>Drumcondra</option>
						<option value='DCKLS'>Docklands</option>
						<option value='DDALK'>Dundalk</option>
						<option value='DGHDA'>Drogheda</option>
						<option value='DLERY'>Dun Laoghaire</option>
						<option value='DLKEY'>Dalkey</option>
						<option value='DRMOD'>Dromod</option>
						<option value='ECRTY'>Enniscorthy</option>
						<option value='ENFLD'>Enfield</option>
						<option value='ENNIS'>Ennis</option>
						<option value='ETOWN'>Edgeworthstown</option>
						<option value='FFORE'>Farranfore</option>
						<option value='FOTA'>Fota</option>
						<option value='FXFRD'>Foxford</option>
						<option value='GALWY'>Galway</option>
						<option value='GCDK'>Grand Canal Dock</option>
						<option value='GHANE'>Glounthaune</option>
						<option value='GLGRY'>Glenageary</option>
						<option value='GOREY'>Gorey</option>
						<option value='GORT'>Gort</option>
						<option value='GRGRD'>Clongriffin</option>
						<option value='GSTNS'>Greystones</option>
						<option value='GSTON'>Gormanston</option>
						<option value='HAFLD'>Hansfield</option>
						<option value='HAZEF'>Hazelhatch</option>
						<option value='HOWTH'>Howth</option>
						<option value='HSTON'>Dublin Heuston</option>
						<option value='HTOWN'>Harmonstown</option>
						<option value='HWTHJ'>Howth Junction</option>
						<option value='HZLCH'>Hazelhatch</option>
						<option value='KBRCK'>Kilbarrack</option>
						<option value='KCOCK'>Kilcock</option>
						<option value='KCOOL'>Kilcoole</option>
						<option value='KDARE'>Kildare</option>
						<option value='KILNY'>Killiney</option>
						<option value='KKNNY'>Kilkenny</option>
						<option value='KLRNY'>Killarney</option>
						<option value='KLSTR'>Killester</option>
						<option value='LBURN'>Lisburn</option>
						<option value='LDWNE'>Lansdowne Road</option>
						<option value='LFORD'>Longford</option>
						<option value='LMRCK'>Limerick</option>
						<option value='LMRKJ'>Limerick Junction</option>
						<option value='LSLND'>LittleIsland</option>
						<option value='LTOWN'>Laytown</option>
						<option value='LURGN'>Lurgan</option>
						<option value='LXCON'>Leixlip (Confey)</option>
						<option value='LXLSA'>Leixlip (Louisa Bridge)</option>
						<option value='M3WAY'>M3 Parkway</option>
						<option value='MDLTN'>Midleton</option>
						<option value='MHIDE'>Malahide</option>
						<option value='MLGAR'>Mullingar</option>
						<option value='MLLOW'>Mallow</option>
						<option value='MLSRT'>Millstreet</option>
						<option value='MNEBG'>Muine Bheag</option>
						<option value='MNLAJ'>Manulla Junction</option>
						<option value='MONVN'>Monasterevin</option>
						<option value='MYNTH'>Maynooth</option>
						<option value='NBRGE'>Newbridge</option>
						<option value='NEWRY'>Newry</option>
						<option value='NNAGH'>Nenagh</option>
						<option value='ORNMR'>Oranmore</option>
						<option value='PDOWN'>Portadown</option>
						<option value='PERSE'>Dublin Pearse</option>
						<option value='PHNPK'>Navan Road Parkway</option>
						<option value='PMNCK'>Portmarnock</option>
						<option value='PTLSE'>Portlaoise</option>
						<option value='PTRTN'>Portarlington</option>
						<option value='PWESF'>Cherry Orchard</option>
						<option value='RAHNY'>Raheny</option>
						<option value='RBROK'>Rushbrooke</option>
						<option value='RCREA'>Roscrea</option>
						<option value='RDRUM'>Rathdrum</option>
						<option value='RLEPT'>Rosslare Europort</option>
						<option value='RLSTD'>Rosslare Strand</option>
						<option value='RLUSK'>Rush and Lusk</option>
						<option value='RMORE'>Rathmore</option>
						<option value='RSCMN'>Roscommon</option>
						<option value='SALNS'>Sallins</option>
						<option value='SCOVE'>Sandycove</option>
						<option value='SEAPT'>Seapoint</option>
						<option value='SHILL'>Salthill</option>
						<option value='SIDNY'>Sydney Parade</option>
						<option value='SKILL'>Shankill</option>
						<option value='SKRES'>Skerries</option>
						<option value='SLIGO'>Sligo</option>
						<option value='SMONT'>Sandymount</option>
						<option value='SUTTN'>Sutton</option>
						<option value='SXMBR'>Sixmilebridge</option>
						<option value='TARA'>Tara Street</option>
						<option value='THRLS'>Thurles</option>
						<option value='THTWN'>Thomastown</option>
						<option value='TIPRY'>Tipperary</option>
						<option value='TMORE'>Tullamore</option>
						<option value='TPMOR'>Templemore</option>
						<option value='TRLEE'>Tralee</option>
						<option value='WBDGE'>Wellingtonbridge</option>
						<option value='WBROK'>Woodbrook</option>
						<option value='WFORD'>Waterford</option>
						<option value='WLAWN'>Woodlawn</option>
						<option value='WLOW'>Wicklow</option>
						<option value='WPORT'>Westport</option>
						<option value='WXFRD'>Wexford</option>
					</select>
				</div>
				
				<div class="form-group">
					<label class="control-label col-sm-4">Range (km)</label>
					<input class="stationSelect form-control" type="text" name="range" placeholder="20km" style="width: 50%;">
				</div>
				
				<div class="form-group" style="margin-bottom: 5px;">
						<div class="col-sm-offset-4 col-sm-10">
							<input type="submit" name="Submit" class="btn btn-primary active">
						</div>
				</div>
				
			</form>
			
		</div>
		</div>
		
		
		
		<%
			if(numberofObjects>0){
				out.print("<div class='line_graph' id='graph1'></div>");
			}
			
			else{
				out.print("<div class='line_graph_error alert alert-danger fade in'>");
				out.print("<p style='text-align:center; font-size: 16px; font-weight: bold;' >No realtime train information is currently available for " + stationparts2[3] + "!</p>");
				out.print("</div>");
			}
			
			if(numberofObjects2>0){
				out.print("<div class='line_graph' id='graph2'></div>");
			}
			
			else{
				out.print("<div class='line_graph_error alert alert-danger fade in'>");
				out.print("<p style='text-align:center; font-size: 16px; font-weight: bold;' >No realtime train information is currently available for " + stationparts[3] + "!</p>");
				out.print("</div>");
			}
		%>
		
		
		<script>
			var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			maxZoom: 18, attribution: '<a href="https://www.openstreetmap.org/">OpenStreetMap</a>' });

			var mymap = L.map('mapid', { center: new L.LatLng(53.1, -7.78381), zoom: 7, layers: [osm] });
			
			var snow = L.OWM.snow({showLegend: true, opacity: 0.5 ,apiId: '766c289bf98959c21f2fb7a5295fb69d'});
			var wind = L.OWM.wind({showLegend: true, opacity: 0.5 ,apiId: '766c289bf98959c21f2fb7a5295fb69d'})
			var rain = L.OWM.rainClassic({showLegend: true, opacity: 0.5 ,apiId: '766c289bf98959c21f2fb7a5295fb69d'})

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
			
			var marker;
			var markers = [];
			
			var onmap=false;
			function addMarkers() {
				if(onmap===false){
					var latlng;
					<%
						for(String[] s: stationpartslist){
							out.println("latlng = L.latLng(" + s[1] + "," + s[2] +");marker = new L.Marker(latlng);mymap.addLayer(marker);marker.bindPopup(\"<p style='display:block;margin:auto 0'>" + s[3] + "</p>\");markers.push(marker);");
						}
					%>
				}
				onmap=true;
			};
			
			function centerMap(){
				mymap.setView([53.1, -7.78381], 7);
			}
			function zoomOut(){
				mymap.setView([53.1, -7.78381], 5);
			}
			
			function removeMarkers(){
				onmap=false;
				var i;
				for(i=0;i<markers.length;i++){
					mymap.removeLayer(markers[i]);
				}
			}
			
			var latlng1=L.latLng(<%out.print(lat1 + "," + lon1);%>);
			var latlng2=L.latLng(<%out.print(lat2 + "," + lon2);%>);
			
			var latlngs = [];
			latlngs.push(latlng1);
			latlngs.push(latlng2);
			
			var joined = false;
			var polyline;
			var popup2;
			
			function stationsDistance(){
				if(joined===false){
					
					polyline = L.polyline(latlngs, {color: 'red'}).addTo(mymap);
					mymap.fitBounds(polyline.getBounds());
					popup2 = L.popup()
					.setLatLng(polyline.getBounds().getCenter())
					.setContent('<%out.print("Distance: " + String.format("%.2f", distance) +" km");%>')
					.openOn(mymap);
					
					joined=true;
				}
				else{
					centerMap();
					mymap.removeLayer(polyline);
					mymap.removeLayer(popup2);
					joined=false;
				}
			}

			L.marker([<%out.println(lat1+","+lon1);%>]).addTo(mymap)
				.bindPopup("<%out.print(stationparts[3]);%>");

			L.circle([<%out.println(lat1+","+lon1);%>], <%out.print(Double.parseDouble(range)*1000);%>, {
				color: 'blue',
				fillColor: '#00ccff',
				fillOpacity: 0.5
			}).addTo(mymap).bindPopup("<p style='display:block;margin:auto 0'><% out.print(stationparts[3]);%></p>");
			
			L.marker([<%out.println(lat2+","+lon2);%>]).addTo(mymap)
				.bindPopup("<%out.print(stationparts2[3]);%>");

			L.circle([<%out.println(lat2+","+lon2);%>], <%out.print(Double.parseDouble(range)*1000);%>, {
				color: 'red',
				fillColor: '#f03',
				fillOpacity: 0.5
			}).addTo(mymap).bindPopup("<p style='display:block;margin:auto 0'><% out.print(stationparts2[3]);%></p>");
		</script>
		
		<script>
			$(function () { 
				$('#graph1').highcharts({
					chart: {
						type: 'bar'
					},
					title: {
						text: 'Trains approaching/leaving <%out.print(stationparts[3]);%>'
					},
					xAxis: {
						title: {
							text:"Routes"
						},
						categories:
						
						
						<%
							out.println("[");
							
							if(numberofObjects>0){
								for(c=0;c<numberofObjects;c++){
									out.println("'"+StationObjects.get(c).getOrigin() + " to " + StationObjects.get(c).getDestination()+"'");
									
									if(c<numberofObjects-1){
										out.println(",");
									}
								}
							}
							
							out.println("]");
						%>
					},
					yAxis: {
						title: {
							text: 'Minutes late'
						}
					},
					series: [{
						name: "Minutes late",
						data:
						
						<%
							out.println("[");
							
							if(numberofObjects>0){
								for(c=0;c<numberofObjects;c++){
									out.println("parseInt("+ StationObjects.get(c).getLate()+")");
									
									if(c<numberofObjects-1){
										out.println(",");
									}
								}
							}
							
							out.println("]");
						%>
					}]
				});
			});
		</script>
		<script>
			$(function () { 
				$('#graph2').highcharts({
					chart: {
						type: 'bar'
					},
					title: {
						text: 'Trains approaching/leaving <%out.print(stationparts2[3]);%>'
					},
					xAxis: {
						title: {
							text:"Routes"
						},
						categories:
						
						
						<%
							out.println("[");
							
							if(numberofObjects2>0){
								for(c=0;c<numberofObjects2;c++){
									out.println("'"+StationObjects2.get(c).getOrigin() + " to " + StationObjects2.get(c).getDestination()+"'");
									
									if(c<numberofObjects2-1){
										out.println(",");
									}
								}
							}
							out.println("]");
						%>
					},
					yAxis: {
						title: {
							text: 'Minutes late'
						}
					},
					series: [{
						name: "Minutes late",
						data:
						
						<%
							out.println("[");
							
							if(numberofObjects2>0){
								for(c=0;c<numberofObjects2;c++){
									out.println("parseInt("+ StationObjects2.get(c).getLate()+")");
									
									if(c<numberofObjects2-1){
										out.println(",");
									}
								}
							}
							
							out.println("]");
						%>
					}]
				});
			});
		</script>
	</body>
</html>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="javax.swing.JOptionPane" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="org.apache.commons.lang3.ArrayUtils" %>

<%!
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
	String code = request.getParameter("code");
	String url = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode="+code+"&NumMins=20";
	Document pag = Jsoup.connect(url).get();
	Elements tags=pag.select("Stationfullname, Traindate, Origin, Destination, Origintime, Destinationtime, Status, Lastlocation, Duein, Late, Exparrival, Expdepart, Scharrival, Schdepart");
	LinkedList<StationData> StationObjects = new LinkedList<StationData>();
	LinkedList<String> DataStrings = new LinkedList<String>();
	
	String code2 = request.getParameter("code2");
	String url2 = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode="+code2+"&NumMins=20";
	Document pag2 = Jsoup.connect(url2).get();
	Elements tags2 =pag2.select("Stationfullname, Traindate, Origin, Destination, Origintime, Destinationtime, Status, Lastlocation, Duein, Late, Exparrival, Expdepart, Scharrival, Schdepart");
	LinkedList<StationData> StationObjects2 = new LinkedList<StationData>();
	LinkedList<String> DataStrings2 = new LinkedList<String>();
	
	int numberofObjects = tags.size()/14;
	int c;
	
	int numberofObjects2 = tags2.size()/14;
	int c2;
	
	for(c=0;c<numberofObjects;c++){
		StationData DataObject = new StationData();
		
		DataObject.setStationfullname(tags.get(0 + (14*c)).toString());
		DataObject.setTraindate(tags.get(1 + (14*c)).toString());
		DataObject.setOrigin(tags.get(2 + (14*c)).toString());
		DataObject.setDestination(tags.get(3 + (14*c)).toString());
		DataObject.setOrigintime(tags.get(4 + (14*c)).toString());
		DataObject.setDestinationtime(tags.get(5 + (14*c)).toString());
		DataObject.setStatus(tags.get(6 + (14*c)).toString());
		DataObject.setLastlocation(tags.get(7 + (14*c)).toString());
		DataObject.setDuein(tags.get(8 + (14*c)).toString());
		DataObject.setLate(tags.get(9 + (14*c)).html());
		DataObject.setExparrival(tags.get(10 + (14*c)).toString());
		DataObject.setExpdepart(tags.get(11 + (14*c)).toString());
		DataObject.setScharrival(tags.get(12 + (14*c)).toString());
		DataObject.setSchdepart(tags.get(13 + (14*c)).toString());
		
		StationObjects.add(DataObject);
	}
	
	for(c2=0;c2<numberofObjects2;c2++){
		StationData DataObject2 = new StationData();
		
		DataObject2.setStationfullname(tags2.get(0 + (14*c2)).toString());
		DataObject2.setTraindate(tags2.get(1 + (14*c2)).toString());
		DataObject2.setOrigin(tags2.get(2 + (14*c2)).toString());
		DataObject2.setDestination(tags2.get(3 + (14*c2)).toString());
		DataObject2.setOrigintime(tags2.get(4 + (14*c2)).toString());
		DataObject2.setDestinationtime(tags2.get(5 + (14*c2)).toString());
		DataObject2.setStatus(tags2.get(6 + (14*c2)).toString());
		DataObject2.setLastlocation(tags2.get(7 + (14*c2)).toString());
		DataObject2.setDuein(tags2.get(8 + (14*c2)).toString());
		DataObject2.setLate(tags2.get(9 + (14*c2)).html());
		DataObject2.setExparrival(tags2.get(10 + (14*c2)).toString());
		DataObject2.setExpdepart(tags2.get(11 + (14*c2)).toString());
		DataObject2.setScharrival(tags2.get(12 + (14*c2)).toString());
		DataObject2.setSchdepart(tags2.get(13 + (14*c2)).toString());
		
		StationObjects2.add(DataObject2);
	}
	
	String[] parts = null;
	String[] parts2 = null;
	
	BufferedReader br = new BufferedReader(new FileReader(application.getRealPath("/")+ "webapp/latandlong.html"));
		while(true){
	  		  String line= br.readLine();
			if( line == null ){
				break;
			}
			if (line.contains(code)){
				parts = line.split(" ");
			}
			
		}
	
	BufferedReader br2 = new BufferedReader(new FileReader(application.getRealPath("/")+ "webapp/latandlong.html"));
		while(true){
	  		  String line= br2.readLine();
			if( line == null ){
				break;
			}
			if (line.contains(code2)){
				parts2 = line.split(" ");
			}
			
		}
		
		out.println("lat: " + parts[1] + " long: " + parts[2] + "</br>");
		out.println("lat: " + parts2[1] + " long: " + parts2[2]);
		
		final int R = 6371;
		
		Double lat1 = Double.parseDouble(parts[1]);
        Double lon1 = Double.parseDouble(parts[2]);
        Double lat2 = Double.parseDouble(parts2[1]);
        Double lon2 = Double.parseDouble(parts2[2]);
		
		Double latDistance = Math.toRadians(lat2-lat1);
        Double lonDistance = Math.toRadians(lon2-lon1);
        
        Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2) * Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2));
        Double x = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Double distance= R * x;
		
		out.println("Distance: " + distance);
		
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>
		  Chart
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript"></script>
		<script src="http://code.highcharts.com/highcharts.js" type="text/javascript"></script>
		<script src="http://code.highcharts.com/modules/exporting.js" type="text/javascript"></script>
	</head>
	<body>
	
	<%
		for(c=0;c<numberofObjects;c++){
			out.println("<p style='display:block' id='stationname" + c + "'>" + StationObjects.get(c).getOrigin() + " to" + StationObjects.get(c).getDestination() + "</p>");
			out.println("<p style='display:block' id='late" + c + "'>" + StationObjects.get(c).getLate() + "</p>");
		}
		
		for(c2=0;c2<numberofObjects2;c2++){
			out.println("<p style='display:block' id='stationname" + (c+c2) + "'>" + StationObjects2.get(c2).getOrigin() + " to" + StationObjects2.get(c2).getDestination() + "</p>");
			out.println("<p style='display:block' id='late" + (c+c2) + "'>" + StationObjects2.get(c2).getLate() + "</p>");
		}
	%>
<%	
	for(c=0;c<numberofObjects;c++){
		
		out.println(StationObjects.get(c).getOrigin() + "</br>");
		out.println(StationObjects.get(c).getDestination() + "</br>");
		
		
		out.println("</br>");
	}
%>

<%	
	for(c2=0;c2<numberofObjects2;c2++){
		
		out.println(StationObjects2.get(c2).getOrigin() + "</br>");
		out.println(StationObjects2.get(c2).getDestination() + "</br>");
		
		
		out.println("</br>");
	}
	
	
						
							out.println("[");
							
							if(numberofObjects>0){
								for(c=0;c<numberofObjects;c++){
									out.println("document.getElementById('stationname" + c + "').innerHTML");
									
									if(c<numberofObjects-1){
										out.println(",");
									}
								}
							}
							
							if(numberofObjects2>0){
								for(c2=c;c2<numberofObjects + numberofObjects2;c2++){
									if(c2>0){
										out.println(",");
									}
									out.println("document.getElementById('stationname" + c2 + "').innerHTML");
								}
							}
							
							out.println("]");
						
%>
	
	<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
	<script>
		$(function () { 
			$('#container').highcharts({
				chart: {
					type: 'bar'
				},
				title: {
					text: 'Train lateness'
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
								out.println("document.getElementById('stationname" + c + "').innerHTML");
								
								if(c<numberofObjects-1){
									out.println(",");
								}
							}
						}
						
						if(numberofObjects2>0){
							for(c2=c;c2<numberofObjects + numberofObjects2;c2++){
								if(c2>00){
									out.println(",");
								}
								out.println("document.getElementById('stationname" + c2 + "').innerHTML");
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
								out.println("parseInt(document.getElementById('late" + c + "').innerHTML)");
								
								if(c<numberofObjects-1){
									out.println(",");
								}
							}
						}
						
						if(numberofObjects2>0){
							for(c2=c;c2<numberofObjects + numberofObjects2;c2++){
								if(c2>0){
									out.println(",");
								}
								out.println("parseInt(document.getElementById('late" + c2 + "').innerHTML)");
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
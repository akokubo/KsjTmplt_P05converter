XML xml;

class Facility {
  String id;
  int classification;
  String name;
  String address;
  float lat;
  float lng;

  String toString() {
    String result;
    result = id + "," + classification + "," + name + "," + address + "," + lat + "," + lng;
    return result;
  }
}

void setup() {
  PrintWriter output = createWriter("P05-10_02-g.csv");

  xml = loadXML("P05-10_02-g.xml");
  XML[] points = xml.getChildren("gml:Point");
  HashMap<String, Facility> facilities = new HashMap<String, Facility>();
  for (int i = 0; i < points.length; i++) {
    Facility facility = new Facility();
    String id = points[i].getString("gml:id");
    XML[] pos = points[i].getChildren("gml:pos");
    String posContent = pos[0].getContent();
    facility.id = id;
    String[] posContents = posContent.split(" ");
    facility.lat = Float.parseFloat(posContents[0]);
    facility.lng = Float.parseFloat(posContents[1]);
    facilities.put(facility.id, facility);
  }

  XML[] localGovernments = xml.getChildren("ksj:LocalGovernmentOfficeAndPublicMeetingFacility");
  for (int i = 0; i < localGovernments.length; i++) {
    XML[] positions = localGovernments[i].getChildren("ksj:position");
    String href = positions[0].getString("xlink:href");
    String id = href.replaceAll("#", "");
    XML[] publicOfficeClassifications = localGovernments[i].getChildren("ksj:publicOfficeClassification");
    int classification = Integer.parseInt(publicOfficeClassifications[0].getContent());
    XML[] publicOfficeNames = localGovernments[i].getChildren("ksj:publicOfficeName");
    String name = publicOfficeNames[0].getContent();
    XML[] addresses = localGovernments[i].getChildren("ksj:address");
    String address = addresses[0].getContent();
    Facility facility = facilities.get(id);
    facility.name = name;
    facility.address = address;
    facility.classification = classification;
    output.println(facility);
  }
  output.close();
}

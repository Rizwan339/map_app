import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {


  // Color changedColor = Colors.black26;

  

  // MArker Items
  Set<Marker> markers = {};
  // final Set<Marker> _markers = {};
  List<LatLng> markerPoints = [];
  Set<Marker> commanderIcons = {};


  // Polylines Items
  List<LatLng> polylinePoints = [];
  Set<Polyline> polylines = {};
  Set<Polyline> tempPolylines = {}; // Temporary set for displaying hte circle before selecting the color
  int polylineCounter = 0; // Unique ID for each polyline
  
  // add polyline
  void addPolyline() {
    tempPolylines.add(
      Polyline(
        polylineId: PolylineId('polyline_$polylineCounter'),
        points: polylinePoints,
        color: Colors.black26,
        visible: true,
        width: 3,
      ),
    );
  }

  // POlygons Items

  List<LatLng> polygonPoints = [];
  Set<Polygon> polygons = {};
  Set<Polygon> tempPolygons = {}; // Temporary set for displaying hte circle before selecting the color
  int polygonCounter = 0;

  void addPolygon() {
    tempPolygons.add(
      Polygon(
          polygonId: PolygonId('polygon_$polygonCounter'),
          points: polygonPoints,
          strokeColor: Colors.black26,
          fillColor: Colors.black26.withOpacity(0.2),
          strokeWidth: 3),
    );
  }

  
  // Square Items
  void addSquare() {
    if (polygonPoints.length < 2) return;
    final LatLng p1 = polygonPoints[0];
    final LatLng p2 = polygonPoints[1];
    final LatLng p3 = LatLng(p1.latitude, p2.longitude);
    final LatLng p4 = LatLng(p2.latitude, p1.longitude);
    final polygon = Polygon(
      polygonId: PolygonId('square_$polygonCounter'),
      points: [p1, p3, p2, p4],
      strokeWidth: 2,
      strokeColor: Colors.black26,
      fillColor: Colors.black26.withOpacity(0.15),
    );

    tempPolygons.add(polygon);
  }



  // Circle Items

  List<LatLng> circlePoints = [];
  Set<Circle> circles = {};
  final Set<Circle> tempCircles = {};
  int circleCounter = 0;


   void addCircle() {
    if (circlePoints.isNotEmpty && circlePoints.length == 2) {
      final LatLng center =
          calculateMidpoint(circlePoints[0], circlePoints[1]);
      final double radius =
          calculateSimpleDistance(circlePoints[0], circlePoints[1]) / 2;

      final circle = Circle(
        circleId: CircleId('circle_$circleCounter'),
        center: center,
        radius: radius,
        strokeWidth: 2,
        strokeColor: Colors.black26, // Default color
        fillColor: Colors.black26.withOpacity(0.15),
      );

      tempCircles.add(circle);

    }
  }

  
  


  // Simplified distance calculation between two LatLng points (in meters)
  double calculateSimpleDistance(LatLng p1, LatLng p2) {
    const double earthRadius = 6371000; // meters
    final double dLat = (p2.latitude - p1.latitude) * (pi / 180);
    final double dLng = (p2.longitude - p1.longitude) * (pi / 180);

    // Approximate distance calculation
    final double distance = sqrt(dLat * dLat + dLng * dLng) * earthRadius;

    return distance; // Distance in meters
  }

// Function to calculate the midpoint between two LatLng points
  LatLng calculateMidpoint(LatLng p1, LatLng p2) {
    final double lat = (p1.latitude + p2.latitude) / 2;
    final double lng = (p1.longitude + p2.longitude) / 2;
    return LatLng(lat, lng); // Return the midpoint
  }
  
}

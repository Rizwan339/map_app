import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController controller = MapController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  ShapeType? _selectedShape;

  static const LatLng initialPosition = LatLng(
    24.873763997221825,
    67.0565176158094,
  );

  void _onTap(point) {
    if (_selectedShape != null) {
      setState(() {
        controller.markerPoints.add(point);
        // _markPoint(point);
        _addMarker(point);
        switch (_selectedShape) {
          case ShapeType.polygon:
            controller.polygonPoints.add(point);
            controller.addPolygon();
            break;
          case ShapeType.polyline:
            controller.polylinePoints.add(point);
            controller.addPolyline();
            break;
          case ShapeType.circle:
            controller.circlePoints.add(point);
            controller.addCircle();
            // print('Mark Points : ${controller.circles.length}');
            break;
          case ShapeType.square:
            controller.polygonPoints.add(point);
            controller.addSquare();
            break;
          default:
            break;
        }
      });
    }
  }

  late BitmapDescriptor _customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon(image: "assets/dot.png");
  }

  Future<void> _loadCustomIcon({required String image}) async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)),
      image,
    );
    setState(() {
      _customIcon = customIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: const CameraPosition(
              target: initialPosition,
              zoom: 13,
            ),
            mapType: MapType.normal,
            polygons: controller.polygons.union(controller.tempPolygons),
            polylines: controller.polylines.union(controller.tempPolylines),
            circles: controller.circles.union(controller.tempCircles),
            onTap: _onTap,
            markers: controller.markers.union(controller.commanderIcons),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedShape = null;
                      controller.polygons.clear();
                      controller.polylines.clear();
                      controller.circles.clear();
                    });
                  },
                  icon: const Icon(Icons.back_hand),
                ),
                // Polyline Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedShape = ShapeType.polyline;
                      controller.polylinePoints.clear();
                    });
                  },
                  icon: const Icon(Icons.polyline),
                ),
                // Polygon Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedShape = ShapeType.polygon;
                      controller.polygonPoints.clear();
                    });
                  },
                  icon: const Icon(Icons.polymer),
                ),
                // CIrcle Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedShape = ShapeType.circle;
                      controller.circlePoints.clear();
                    });
                  },
                  icon: const Icon(Icons.circle),
                ),
                // Square Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedShape = ShapeType.square;
                      controller.polygonPoints.clear();
                    });
                  },
                  icon: const Icon(Icons.square),
                ),
              ],
            ),
          ),
          if (_selectedShape != null)
            Positioned(
              right: 10,
              top: 20,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    saveShape();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Done"),
              ),
            ),
          Positioned(
            bottom: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                setState(() {
                  controller.polygons.clear();
                  controller.polylines.clear();
                  controller.circles.clear();
                  controller.markers.clear();
                  controller.commanderIcons.clear();
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 50,
            child: IconButton(
              onPressed: () {
                setState(() {
                  commanderIconsDialog(context);
                });
              },
              icon: const Icon(Icons.add_box),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> commanderIconsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Commander Icons"),
          content: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _addIcon("assets/police-car.png");
                    Navigator.pop(context);
                    // print("Button pressed");
                  });
                },
                child: Container(
                    height: 30,
                    width: 40,
                    child: Image.asset(
                      "assets/police-car.png",
                      fit: BoxFit.contain,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _addIcon("assets/analysis.png");
                    Navigator.pop(context);
                  });
                },
                child: Container(
                    height: 30,
                    width: 40,
                    child: Image.asset(
                      "assets/analysis.png",
                      fit: BoxFit.contain,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _addIcon("assets/hand.png");
                    Navigator.pop(context);
                  });
                },
                child: Container(
                    height: 30,
                    width: 40,
                    child: Image.asset(
                      "assets/hand.png",
                      fit: BoxFit.contain,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _addIcon("assets/polygon.png");
                    Navigator.pop(context);
                  });
                },
                child: Container(
                    height: 30,
                    width: 40,
                    child: Image.asset(
                      "assets/polygon.png",
                      fit: BoxFit.contain,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to open a dialog for color selection
  Future<Color?> dialogBox(BuildContext context) {
    return showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Details Shape'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, Colors.red); // Return the selected color
                },
                child: const Text('Red color'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, Colors.blue);
                },
                child: const Text('Blue color'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, Colors.green);
                },
                child: const Text('Green color'),
              ),
            ],
          ),
        );
      },
    );
  }

  void saveShape() {
    switch (_selectedShape) {
      case ShapeType.polyline:
        controller
            .polylineCounter++; // Increment counter for changing the ID for the next polyline
        controller.polylinePoints = []; // Clear points for the next polyline
        controller.markers.clear();
        dialogBox(context).then((selectedColor) {
          if (selectedColor != null) {
            setState(() {
              // Add the circle with selected color to the actuall Set
              controller.polylines.add(controller.tempPolylines.last.copyWith(
                colorParam: selectedColor,
              ));
              controller.tempPolylines
                  .clear(); // Clear temp circles after adding
            });
          }
        });
        _selectedShape = null;
        break;
      case ShapeType.polygon:
        controller
            .polygonCounter++; // Increment counter for changing the ID for the next polyline
        controller.polygonPoints = []; // Clear points for the next polyline
        controller.markers.clear();
        dialogBox(context).then((selectedColor) {
          if (selectedColor != null) {
            setState(() {
              controller.polygons.add(controller.tempPolygons.last.copyWith(
                fillColorParam: selectedColor.withOpacity(0.3),
                strokeColorParam: selectedColor,
              ));
              controller.tempPolygons
                  .clear(); // Clear temp circles after adding
            });
          }
        });
        _selectedShape = null;
        break;
      case ShapeType.circle:
        controller
            .circleCounter++; // Increment counter for changing the ID for the next Circle
        controller.circlePoints = []; // Clear points for the next polyline
        controller.markers.clear();
        dialogBox(context).then((selectedColor) {
          if (selectedColor != null) {
            setState(() {
              controller.circles.add(controller.tempCircles.last.copyWith(
                fillColorParam: selectedColor.withOpacity(0.3),
                strokeColorParam: selectedColor,
              ));
              controller.tempCircles.clear(); // Clear temp circles after adding
            });
          }
        });
        _selectedShape = null;
        break;
      case ShapeType.square:
        controller
            .polygonCounter++; // Increment counter for changing the ID for the next Circle
        controller.polygonPoints = []; // Clear points for the next polyline
        controller.markers.clear();
        dialogBox(context).then((selectedColor) {
          if (selectedColor != null) {
            setState(() {
              controller.polygons.add(controller.tempPolygons.last.copyWith(
                fillColorParam: selectedColor.withOpacity(0.3),
                strokeColorParam: selectedColor,
              ));
              controller.tempPolygons
                  .clear(); // Clear temp circles after adding
            });
          }
        });
        _selectedShape = null;
        break;
      default:
        break;
    }
  }

  void _addMarker(LatLng point) {
    final marker = Marker(
      markerId: MarkerId('marker_${controller.markers.length}'),
      position: point,
      draggable: true,
      icon: _customIcon,
      anchor:
          const Offset(0.5, 0.5), // Set the anchor point to the bottom center
      onDragEnd: (newPosition) {
        setState(() {
          controller.markerPoints[controller.markers.length - 1] = newPosition;
          switch (_selectedShape) {
            case ShapeType.polygon:
              controller.addPolygon();
              break;
            case ShapeType.polyline:
              controller.addPolyline();
              break;
            case ShapeType.circle:
              controller.addCircle();
              break;
            case ShapeType.square:
              controller.addSquare();
              break;
            default:
              break;
          }
        });
      },
    );
    setState(() {
      controller.markers.add(marker);
      if (controller.markers.length >= 3) {
        controller.markers.clear();
      }
    });
  }

  Future<void> _addIcon(assetPath) async {
    final markerId = MarkerId(DateTime.now().toString());
    final BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)),
      assetPath,
    );
    final marker = Marker(
      markerId: markerId,
      position: initialPosition, // Example position
      icon: bitmapDescriptor, // Customize this with your icon
      draggable: true,
    );

    setState(() {
      controller.commanderIcons.add(marker);
    });
  }
}

enum ShapeType { polygon, circle, square, polyline }

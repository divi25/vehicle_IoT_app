import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(VehicleTrackerApp());

class VehicleTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VehicleTrackerScreen(),
    );
  }
}

class VehicleTrackerScreen extends StatefulWidget {
  @override
  _VehicleTrackerScreenState createState() => _VehicleTrackerScreenState();
}

class _VehicleTrackerScreenState extends State<VehicleTrackerScreen> {
  final List<Vehicle> vehicles = [];
  final Random rand = Random();
  
  @override
  void initState() {
    super.initState();
    _initializeVehicles();
    _startUpdates();
  }
  
  void _initializeVehicles() {
    vehicles.addAll([
      Vehicle('VH001', 60, 75, 85, 28.6139, 77.2090, true),
      Vehicle('VH002', 45, 50, 90, 28.6239, 77.2190, true),
      Vehicle('VH003', 80, 30, 95, 28.6039, 77.1990, true),
    ]);
  }
  
  void _startUpdates() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          for (var vehicle in vehicles) {
            vehicle.update(rand);
          }
        });
        _startUpdates();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.id,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetric('Speed', '${vehicle.speed.toStringAsFixed(1)} km/h'),
                      _buildMetric('Fuel', '${vehicle.fuel.toStringAsFixed(1)}%'),
                      _buildMetric('Temp', '${vehicle.temp.toStringAsFixed(1)}°C'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Location: (${vehicle.lat.toStringAsFixed(4)}, ${vehicle.lng.toStringAsFixed(4)})',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.engineering,
                        color: vehicle.engineOn ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 5),
                      Text(
                        vehicle.engineOn ? 'Engine ON' : 'Engine OFF',
                        style: TextStyle(
                          color: vehicle.engineOn ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class Vehicle {
  final String id;
  double speed;
  double fuel;
  double temp;
  double lat;
  double lng;
  bool engineOn;
  
  Vehicle(this.id, this.speed, this.fuel, this.temp, this.lat, this.lng, this.engineOn);
  
  void update(Random rand) {
    speed = (speed + rand.nextDouble() * 10 - 5).clamp(0, 120);
    fuel = (fuel - rand.nextDouble()).clamp(0, 100);
    temp = (temp + rand.nextDouble() * 2 - 1).clamp(60, 120);
    lat += rand.nextDouble() * 0.01 - 0.005;
    lng += rand.nextDouble() * 0.01 - 0.005;
    
    if (rand.nextDouble() < 0.1) engineOn = !engineOn;
    if (fuel < 10) fuel = 100;
  }
}

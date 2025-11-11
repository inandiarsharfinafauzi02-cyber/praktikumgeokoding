import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; //import tambahan

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Geolocator (Dasar)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- Variabel State Utama ---
  Position? _currentPosition; // Menyimpan data lokasi
  String? _errorMessage; // Menyimpa pesan error
  String? _currentAddress; // Menyimpan alamat hasil geocoding
  StreamSubscription<Position>? _positionStream; // Penyimpan stream

  String? _distanceToPNB; // Menyimpan jarak real-time ke titik PNB

  // Variabel untuk Latihan 1 dan 2 telah dihapus dari versi ini

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  

  Future<Position> _getPermissionAndLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan lokasi (GPS) di perangkat aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika tidak aktif, kirim error
      return Future.error('Layanan lokasi tidak aktif. Harap aktifkan GPS.');
    }

    // 2. Cek izin lokasi dari aplikasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Jika ditolak, minta izin
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika tetap ditolak, kirim error
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Jika ditolak permanen, kirim error
      return Future.error(
        'Izin lokasi ditolak permanen. Harap ubah di pengaturan aplikasi.',
      );
    }

    // 3. Jika izin diberikan, ambil lokasi saat ini
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _getAddressFromLatLng(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];
    setState(() {
      _currentAddress =
          "${place.street}, ${place.subLocality}, ${place.locality}, "
          "${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    });
  } catch (e) {
    setState(() {
      _currentAddress = "Gagal mendapatkan alamat: $e";
    });
  }
}

  void _handleGetLocation() async {
    try {
      Position position = await _getPermissionAndLocation();
      setState(() {
        _currentPosition = position;
        _errorMessage = null; // Hapus error jika sukses
      });

      await _getAddressFromLatLng(position); // Panggil geocoding di sini
      // Fungsi Latihan 1 & 2 dihapus dari sini
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Tampilkan error di UI
      });
    }
  }

  void _handleStartTracking() {
    _positionStream?.cancel();

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update setiap ada pergerakan 10 meter
    );

    try {
      // Mulai mendengarkan stream
      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen((Position position) async {
            setState(() {
              _currentPosition = position;
              _errorMessage = null;
            });

          // Titik tetap
          const double pnbLatitude = -8.2186;
          const double pnbLongitude = 114.3676;


          // Hitung jarak real-time menggunakan Geolocator.distanceBetween
          double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            pnbLatitude,
            pnbLongitude,
          );

          // Simpan hasil ke variabel state (_distanceToPNB)
          setState(() {
            _distanceToPNB = (distanceInMeters / 1000).toStringAsFixed(2); // ubah ke km
          });

          
          await _getAddressFromLatLng(position);  // Panggil geocoding setiap update lokasi
          });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _handleStopTracking() {
    _positionStream?.cancel(); // Hentikan stream
    setState(() {
      _errorMessage = "Pelacakan dihentikan.";
    });
  }

  // --- TAMPILAN (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Praktikum Geolocator (Dasar)")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 50, color: Colors.blue),
                SizedBox(height: 16),

                // --- Area Tampilan Informasi ---
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tampilkan Error
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),

                      SizedBox(height: 16),

                      // Tampilkan Posisi (Lat/Lng)
                      if (_currentPosition != null)
                        Text(
                          "Lat: ${_currentPosition!.latitude}\nLng: ${_currentPosition!.longitude}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // UI
                        SizedBox(height: 16),
                      if (_currentAddress != null)
                        Text(
                          "Alamat:\n$_currentAddress", // tampilkan alamat
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                    
                    // Tampilkan jarak real-time ke PNB
                    if (_distanceToPNB != null)
                      Text(
                        "Jarak ke PNB: $_distanceToPNB km",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),


                    ],
                  ),
                ),

                SizedBox(height: 32),

                //
                ElevatedButton.icon(
                  icon: Icon(Icons.location_searching),
                  label: Text('Dapatkan Lokasi Sekarang'),
                  onPressed: _handleGetLocation,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow),
                      label: Text('Mulai Lacak'),
                      onPressed: _handleStartTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.stop),
                      label: Text('Henti Lacak'),
                      onPressed: _handleStopTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
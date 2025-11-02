import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensimengajar/core/services/service_locator.dart';
import 'package:presensimengajar/features/attendance/data/datasources/live_camera_datasource.dart';
import '../../domain/entities/schedule_entity.dart';
import '../bloc/attendance_bloc.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi Mengajar'),
      ),
      body: BlocProvider(
        create: (_) => sl<AttendanceBloc>()..add(CheckForActiveCheckIn()),
        child: const CheckInView(),
      ),
    );
  }
}

class CheckInView extends StatelessWidget {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
            );
        }
        if (state is AttendanceSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
        }
        if (state is CheckOutSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
        }
        if (state is NoActiveCheckIn) {
          // If not checked in, automatically fetch today's schedule to start check-in flow
          context.read<AttendanceBloc>().add(FetchTodaySchedule());
        }
      },
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceInitial || state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ActiveCheckInFound) {
            return CheckOutView(attendanceId: state.attendanceId);
          }
          if (state is AttendanceScheduleLoaded) {
            return CheckInMapView(schedule: state.schedule);
          }
          if (state is NoActiveCheckIn) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttendanceFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AttendanceBloc>().add(CheckForActiveCheckIn());
                    },
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('State tidak diketahui'));
        },
      ),
    );
  }
}

class CheckOutView extends StatefulWidget {
  final int attendanceId;
  const CheckOutView({super.key, required this.attendanceId});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final LiveCameraDataSource _cameraDataSource = sl<LiveCameraDataSource>();

  @override
  void initState() {
    super.initState();
    _cameraDataSource.initialize();
  }

  @override
  void dispose() {
    _cameraDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<void>(
            future: _cameraDataSource.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraDataSource.controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Anda sudah melakukan check-in.',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceLoading) {
                      return const CircularProgressIndicator(color: Colors.white);
                    }
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<AttendanceBloc>().add(CheckOutButtonPressed());
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Check Out Sekarang'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CheckInMapView extends StatefulWidget {
  final ScheduleEntity schedule;

  const CheckInMapView({super.key, required this.schedule});

  @override
  State<CheckInMapView> createState() => _CheckInMapViewState();
}

class _CheckInMapViewState extends State<CheckInMapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  final LiveCameraDataSource _cameraDataSource = sl<LiveCameraDataSource>();

  @override
  void initState() {
    super.initState();
    _cameraDataSource.initialize();
  }

  @override
  void dispose() {
    _cameraDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng scheduleLocation = LatLng(widget.schedule.latitude, widget.schedule.longitude);
    final CameraPosition initialCameraPosition = CameraPosition(target: scheduleLocation, zoom: 15.5);
    final Set<Circle> circles = {
      Circle(
        circleId: const CircleId('school_radius'),
        center: scheduleLocation,
        radius: widget.schedule.radius.toDouble(),
        fillColor: Colors.blue.withValues(alpha: 0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      )
    };

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            circles: circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),
        Expanded(
          flex: 1,
          child: FutureBuilder<void>(
            future: _cameraDataSource.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraDataSource.controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              if (state is AttendanceLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<AttendanceBloc>().add(CheckInButtonPressed(widget.schedule.id));
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Check In Sekarang'),
              );
            },
          ),
        ),
      ],
    );
  }
}
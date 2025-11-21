import 'package:attandance_app/models/attendance_record.dart';
import 'package:attandance_app/services/auth_services.dart';
import 'package:attandance_app/services/firestore_service.dart';
import 'package:attandance_app/services/storage_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthServices _authServices = AuthServices();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageServices _storageServices = StorageServices();
  AttendanceRecord? _todayRecord;
  bool _isLoading= false;


  @override
  void initState() {
    super.initState();
    _listenToTodayRecord();
  }

  // mendengarkan semua hal yg terjadi di homescreen ->attendance record
  void _listenToTodayRecord() {
    final user = _authServices.currentUser;
    if (user != null) {
      _firestoreService.getTodayRecordStream(user.uid).listen((record) {
        // masih aktif 
        if (mounted) setState(() => _todayRecord = record);
      });
    }
  }

  // utk check in
  Future<void> _CheckIn({String? photoPath}) async {
    final user = _authServices.currentUser;
    // kalo user tidak ada di database
    if (user == null) return null;

    setState(() => _isLoading = true);

    // percobaan utk take photo ketika check in
    try {
      String? photoKey;
      if (photoPath != null) {
        photoKey = await _storageServices.uploadAttendancePhoto(photoPath, 'CheckIn');
      }

      final now = DateTime.now();
      final record = AttendanceRecord(
        id: '',
        userId: user.uid,
        chekInTime: now,
        date: DateTime(now.year, now.month, now.day),
        chekInPhotoPath: photoKey,
      );

      await _firestoreService.createAttendanceRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              photoPath != null ? 'Check in successfully with photo!' : 'Check in successfully',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          )
        );
      }
    } catch (e) {
      // kalau tidak berhasil check in
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checkhing in: ${e.toString()}'),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // check out
  Future<void> _checkOut({String? photoPath}) async {
    if (_todayRecord == null) return;

    setState(() => _isLoading = true);

    try {
      String? photoKey;
      if (photoPath != null) {
        photoKey = await _storageServices.uploadAttendancePhoto(photoPath, 'checkout');

        final updateRecord = AttendanceRecord(
          id: _todayRecord!.id,
          userId: _todayRecord!.userId,
          chekInTime: _todayRecord!.chekInTime,
          chekOutime: DateTime.now(),
          date: _todayRecord!.date,
          chekInPhotoPath: _todayRecord!.chekInPhotoPath,
          chekOutPhotoPath: photoKey,
        );

        await _firestoreService.uploadAttendancePhoto(updateRecord);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(photoPath != null ? 'Checked Out successfully with photo' : 'Check Out succesfully'),
            )
          );
        }
      }
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
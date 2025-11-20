class AttendanceRecord {
  final String id;
  final String userId;
  final DateTime chekInTime;
  final DateTime? chekOutime;
  final DateTime date;
  final String? location;
  final String? notes;
  final String? chekInPhotoPath;
  final String? chekOutPhotoPath;

  AttendanceRecord({required this.id, required this.userId, required this.chekInTime,  this.chekOutime, required this.date,  this.location,  this.notes,  this.chekInPhotoPath,  this.chekOutPhotoPath});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    chekInTime: DateTime.parse(json['chek_in_time'] as String),
    chekOutime: json['chek_out_time'] != null ? DateTime.parse(json['chek_out_time'] as String) : null,
    date: DateTime.parse(json['date'] as String),
    location: json['location'] as String?,
    notes: json['json'] as String?,
    chekInPhotoPath: json['chek_in_photo_path'] as String?, 
    chekOutPhotoPath: json['chek_out_photo_path'] as String?, 
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'id' : id,
      'user_id' : userId,
      'check_in_time': chekInTime.toIso8601String(),
      'check_otu_time': chekOutime?.toIso8601String(),
      'date':date.toIso8601String().split('T')[0],
      'location': location,
      'notes': notes,
      'check_in_photo_path': chekInPhotoPath,
      'check_out_photo_path': chekOutPhotoPath,

    };
  }

  Duration? get totalHour {
    if (chekOutime == null ) return null;
    return chekOutime!.difference(chekInTime);
  }
}
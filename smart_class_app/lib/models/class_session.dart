class ClassSession {
  final String? id;
  final String sessionId;
  final String studentId;

  // Check-in data
  final DateTime? checkinTimestamp;
  final double? checkinLat;
  final double? checkinLng;
  final String? qrCodeValue;
  final String? prevTopic;
  final String? expectedTopic;
  final int? moodScore;

  // Check-out data
  final DateTime? checkoutTimestamp;
  final double? checkoutLat;
  final double? checkoutLng;
  final String? learnedToday;
  final String? classFeedback;

  // Status
  final String status; // 'pending', 'checked_in', 'completed'

  ClassSession({
    this.id,
    required this.sessionId,
    required this.studentId,
    this.checkinTimestamp,
    this.checkinLat,
    this.checkinLng,
    this.qrCodeValue,
    this.prevTopic,
    this.expectedTopic,
    this.moodScore,
    this.checkoutTimestamp,
    this.checkoutLat,
    this.checkoutLng,
    this.learnedToday,
    this.classFeedback,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'session_id': sessionId,
      'student_id': studentId,
      'checkin_timestamp': checkinTimestamp?.toIso8601String(),
      'checkin_lat': checkinLat,
      'checkin_lng': checkinLng,
      'qr_code_value': qrCodeValue,
      'prev_topic': prevTopic,
      'expected_topic': expectedTopic,
      'mood_score': moodScore,
      'checkout_timestamp': checkoutTimestamp?.toIso8601String(),
      'checkout_lat': checkoutLat,
      'checkout_lng': checkoutLng,
      'learned_today': learnedToday,
      'class_feedback': classFeedback,
      'status': status,
    };
  }

  factory ClassSession.fromMap(Map<String, dynamic> map) {
  double? toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }

  int? toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  return ClassSession(
    id: map['id']?.toString(),
    sessionId: map['session_id'] ?? '',
    studentId: map['student_id'] ?? '',

    checkinTimestamp: map['checkin_timestamp'] != null
        ? DateTime.tryParse(map['checkin_timestamp'].toString())
        : null,

    checkinLat: toDouble(map['checkin_lat']),
    checkinLng: toDouble(map['checkin_lng']),

    qrCodeValue: map['qr_code_value'],
    prevTopic: map['prev_topic'],
    expectedTopic: map['expected_topic'],

    moodScore: toInt(map['mood_score']),

    checkoutTimestamp: map['checkout_timestamp'] != null
        ? DateTime.tryParse(map['checkout_timestamp'].toString())
        : null,

    checkoutLat: toDouble(map['checkout_lat']),
    checkoutLng: toDouble(map['checkout_lng']),

    learnedToday: map['learned_today'],
    classFeedback: map['class_feedback'],
    status: map['status'] ?? 'pending',
  );
}

  ClassSession copyWith({
    String? id,
    String? sessionId,
    String? studentId,
    DateTime? checkinTimestamp,
    double? checkinLat,
    double? checkinLng,
    String? qrCodeValue,
    String? prevTopic,
    String? expectedTopic,
    int? moodScore,
    DateTime? checkoutTimestamp,
    double? checkoutLat,
    double? checkoutLng,
    String? learnedToday,
    String? classFeedback,
    String? status,
  }) {
    return ClassSession(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      checkinTimestamp: checkinTimestamp ?? this.checkinTimestamp,
      checkinLat: checkinLat ?? this.checkinLat,
      checkinLng: checkinLng ?? this.checkinLng,
      qrCodeValue: qrCodeValue ?? this.qrCodeValue,
      prevTopic: prevTopic ?? this.prevTopic,
      expectedTopic: expectedTopic ?? this.expectedTopic,
      moodScore: moodScore ?? this.moodScore,
      checkoutTimestamp: checkoutTimestamp ?? this.checkoutTimestamp,
      checkoutLat: checkoutLat ?? this.checkoutLat,
      checkoutLng: checkoutLng ?? this.checkoutLng,
      learnedToday: learnedToday ?? this.learnedToday,
      classFeedback: classFeedback ?? this.classFeedback,
      status: status ?? this.status,
    );
  }

  String get moodEmoji {
    switch (moodScore) {
      case 1: return '😡';
      case 2: return '🙁';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }

  String get moodLabel {
    switch (moodScore) {
      case 1: return 'Very Negative';
      case 2: return 'Negative';
      case 3: return 'Neutral';
      case 4: return 'Positive';
      case 5: return 'Very Positive';
      default: return 'Neutral';
    }
  }
}

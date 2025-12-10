enum SeverityLevel { low, medium, high }

class Analysis {
  final String id;
  final DateTime date;
  final String symptoms;
  final List<String> categories;
  final SeverityLevel severity;
  final String? diagnosis;
  final List<String> recommendations;
  final String? imageUrl;

  Analysis({
    required this.id,
    required this.date,
    required this.symptoms,
    required this.categories,
    required this.severity,
    this.diagnosis,
    this.recommendations = const [],
    this.imageUrl,
  });

  String get formattedDate {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return months[month - 1];
  }

  String get severityLabel {
    switch (severity) {
      case SeverityLevel.low:
        return 'Faible';
      case SeverityLevel.medium:
        return 'Moyen';
      case SeverityLevel.high:
        return 'Élevé';
    }
  }

  String get severityEmoji {
    switch (severity) {
      case SeverityLevel.low:
        return '🟢';
      case SeverityLevel.medium:
        return '🟡';
      case SeverityLevel.high:
        return '🔴';
    }
  }

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      symptoms: json['symptoms'] ?? '',
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      severity: _severityFromString(json['severity'] ?? 'low'),
      diagnosis: json['diagnosis'],
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
      imageUrl: json['imageUrl'] ?? json['image_url'],
    );
  }

  static SeverityLevel _severityFromString(String severity) {
    switch (severity.toLowerCase()) {
      case 'medium':
      case 'moyen':
        return SeverityLevel.medium;
      case 'high':
      case 'élevé':
      case 'eleve':
        return SeverityLevel.high;
      default:
        return SeverityLevel.low;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'symptoms': symptoms,
      'categories': categories,
      'severity': severity.toString().split('.').last,
      'diagnosis': diagnosis,
      'recommendations': recommendations,
      'imageUrl': imageUrl,
    };
  }
}




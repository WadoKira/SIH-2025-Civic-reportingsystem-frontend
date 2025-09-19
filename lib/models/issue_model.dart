enum IssueCategory {
  pothole,
  streetlight,
  garbage,
  waterSupply,
  drainage,
  roadDamage,
  publicToilet,
  parkMaintenance,
  other
}

enum IssueStatus {
  submitted,
  acknowledged,
  inProgress,
  resolved,
  rejected
}

enum IssuePriority {
  low,
  medium,
  high,
  critical
}

class IssueModel {
  final String id;
  final String title;
  final String description;
  final IssueCategory category;
  final IssueStatus status;
  final IssuePriority priority;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> images;
  final String? audioNote;
  final String reportedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int upvotes;
  final List<String> comments;

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.status = IssueStatus.submitted,
    this.priority = IssuePriority.medium,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.images = const [],
    this.audioNote,
    required this.reportedBy,
    required this.createdAt,
    this.updatedAt,
    this.upvotes = 0,
    this.comments = const [],
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: IssueCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => IssueCategory.other,
      ),
      status: IssueStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => IssueStatus.submitted,
      ),
      priority: IssuePriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => IssuePriority.medium,
      ),
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      audioNote: json['audioNote'],
      reportedBy: json['reportedBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      upvotes: json['upvotes'] ?? 0,
      comments: List<String>.from(json['comments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'images': images,
      'audioNote': audioNote,
      'reportedBy': reportedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'upvotes': upvotes,
      'comments': comments,
    };
  }

  String get categoryDisplayName {
    switch (category) {
      case IssueCategory.pothole:
        return 'Pothole';
      case IssueCategory.streetlight:
        return 'Street Light';
      case IssueCategory.garbage:
        return 'Garbage';
      case IssueCategory.waterSupply:
        return 'Water Supply';
      case IssueCategory.drainage:
        return 'Drainage';
      case IssueCategory.roadDamage:
        return 'Road Damage';
      case IssueCategory.publicToilet:
        return 'Public Toilet';
      case IssueCategory.parkMaintenance:
        return 'Park Maintenance';
      case IssueCategory.other:
        return 'Other';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case IssueStatus.submitted:
        return 'Submitted';
      case IssueStatus.acknowledged:
        return 'Acknowledged';
      case IssueStatus.inProgress:
        return 'In Progress';
      case IssueStatus.resolved:
        return 'Resolved';
      case IssueStatus.rejected:
        return 'Rejected';
    }
  }
}
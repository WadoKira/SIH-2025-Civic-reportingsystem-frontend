import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class IssueProvider with ChangeNotifier {
  List<IssueModel> _issues = [];
  bool _isLoading = false;
  IssueModel? _selectedIssue;

  List<IssueModel> get issues => _issues;
  bool get isLoading => _isLoading;
  IssueModel? get selectedIssue => _selectedIssue;

  List<IssueModel> get myIssues => _issues.where((issue) => issue.reportedBy == 'current_user').toList();

  Future<void> loadIssues() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from backend
      await Future.delayed(const Duration(seconds: 1));
      
      _issues = _generateDummyIssues();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> reportIssue(IssueModel issue) async {
    try {
      // TODO: Send to backend
      await Future.delayed(const Duration(seconds: 2));
      
      _issues.insert(0, issue);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> upvoteIssue(String issueId) async {
    try {
      final index = _issues.indexWhere((issue) => issue.id == issueId);
      if (index != -1) {
        // TODO: Send upvote to backend
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  void selectIssue(IssueModel issue) {
    _selectedIssue = issue;
    notifyListeners();
  }

  List<IssueModel> getIssuesByCategory(IssueCategory category) {
    return _issues.where((issue) => issue.category == category).toList();
  }

  List<IssueModel> getIssuesByStatus(IssueStatus status) {
    return _issues.where((issue) => issue.status == status).toList();
  }

  List<IssueModel> _generateDummyIssues() {
    return [
      IssueModel(
        id: '1',
        title: 'Large Pothole on Main Street',
        description: 'There is a large pothole causing traffic issues',
        category: IssueCategory.pothole,
        status: IssueStatus.submitted,
        priority: IssuePriority.high,
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'Main Street, New Delhi',
        images: [],
        reportedBy: 'user1',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        upvotes: 15,
      ),
      IssueModel(
        id: '2',
        title: 'Broken Street Light',
        description: 'Street light not working for past 3 days',
        category: IssueCategory.streetlight,
        status: IssueStatus.acknowledged,
        priority: IssuePriority.medium,
        latitude: 28.6129,
        longitude: 77.2295,
        address: 'Park Street, New Delhi',
        images: [],
        reportedBy: 'user2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        upvotes: 8,
      ),
      IssueModel(
        id: '3',
        title: 'Overflowing Garbage Bin',
        description: 'Garbage bin overflowing, creating hygiene issues',
        category: IssueCategory.garbage,
        status: IssueStatus.inProgress,
        priority: IssuePriority.high,
        latitude: 28.6169,
        longitude: 77.2090,
        address: 'Market Area, New Delhi',
        images: [],
        reportedBy: 'user3',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        upvotes: 22,
      ),
    ];
  }
}
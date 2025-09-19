import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import '../../models/issue_model.dart';
import '../../widgets/issue_card.dart';

class MyIssuesScreen extends StatefulWidget {
  const MyIssuesScreen({super.key});

  @override
  State<MyIssuesScreen> createState() => _MyIssuesScreenState();
}

class _MyIssuesScreenState extends State<MyIssuesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Issues'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Submitted'),
            Tab(text: 'In Progress'),
            Tab(text: 'Resolved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Consumer<IssueProvider>(
        builder: (context, issueProvider, child) {
          final myIssues = issueProvider.myIssues;

          if (myIssues.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Issues Reported',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start by reporting your first civic issue',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildIssuesList(myIssues),
              _buildIssuesList(
                myIssues.where((issue) => issue.status == IssueStatus.submitted).toList(),
              ),
              _buildIssuesList(
                myIssues.where((issue) => 
                  issue.status == IssueStatus.acknowledged || 
                  issue.status == IssueStatus.inProgress
                ).toList(),
              ),
              _buildIssuesList(
                myIssues.where((issue) => issue.status == IssueStatus.resolved).toList(),
              ),
              _buildIssuesList(
                myIssues.where((issue) => issue.status == IssueStatus.rejected).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIssuesList(List<IssueModel> issues) {
    if (issues.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No issues in this category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<IssueProvider>(context, listen: false).loadIssues();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: issues.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IssueCard(
              issue: issues[index],
              onTap: () {
                _showIssueDetails(issues[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showIssueDetails(IssueModel issue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(issue.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        issue.statusDisplayName,
                        style: TextStyle(
                          color: _getStatusColor(issue.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  issue.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Category and Priority
                Row(
                  children: [
                    Chip(
                      label: Text(issue.categoryDisplayName),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(issue.priority.toString().split('.').last.toUpperCase()),
                      backgroundColor: _getPriorityColor(issue.priority).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getPriorityColor(issue.priority),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Description
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          issue.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        
                        // Location
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                issue.address,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Stats
                        Row(
                          children: [
                            _buildStatItem(
                              Icons.thumb_up_outlined,
                              issue.upvotes.toString(),
                              'Upvotes',
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              Icons.comment_outlined,
                              issue.comments.length.toString(),
                              'Comments',
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              Icons.access_time,
                              _formatDate(issue.createdAt),
                              'Reported',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(IssueStatus status) {
    switch (status) {
      case IssueStatus.submitted:
        return Colors.blue;
      case IssueStatus.acknowledged:
        return Colors.orange;
      case IssueStatus.inProgress:
        return Colors.purple;
      case IssueStatus.resolved:
        return Colors.green;
      case IssueStatus.rejected:
        return Colors.red;
    }
  }

  Color _getPriorityColor(IssuePriority priority) {
    switch (priority) {
      case IssuePriority.low:
        return Colors.green;
      case IssuePriority.medium:
        return Colors.orange;
      case IssuePriority.high:
        return Colors.red;
      case IssuePriority.critical:
        return Colors.red[900]!;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
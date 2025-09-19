import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/issue_model.dart';
import '../../widgets/issue_card.dart';
import '../../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IssueCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).loadIssues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<IssueProvider>(context, listen: false).loadIssues();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Text(
                        'Hello, ${authProvider.user?.name.split(' ').first ?? 'User'}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                ],
              ),

              // Quick Stats
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Consumer<IssueProvider>(
                    builder: (context, issueProvider, child) {
                      final totalIssues = issueProvider.issues.length;
                      final resolvedIssues = issueProvider.issues
                          .where((issue) => issue.status == IssueStatus.resolved)
                          .length;
                      final myIssues = issueProvider.myIssues.length;

                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Issues',
                              totalIssues.toString(),
                              Icons.report_problem_outlined,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Resolved',
                              resolvedIssues.toString(),
                              Icons.check_circle_outline,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'My Reports',
                              myIssues.toString(),
                              Icons.person_outline,
                              Colors.blue,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Category Filter
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryChip(
                        label: 'All',
                        isSelected: _selectedCategory == null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                      ),
                      ...IssueCategory.values.map((category) {
                        return CategoryChip(
                          label: _getCategoryDisplayName(category),
                          isSelected: _selectedCategory == category,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              // Issues List
              Consumer<IssueProvider>(
                builder: (context, issueProvider, child) {
                  if (issueProvider.isLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  List<IssueModel> filteredIssues = _selectedCategory == null
                      ? issueProvider.issues
                      : issueProvider.getIssuesByCategory(_selectedCategory!);

                  if (filteredIssues.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No issues found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to report an issue!',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IssueCard(issue: filteredIssues[index]),
                          );
                        },
                        childCount: filteredIssues.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(IssueCategory category) {
    switch (category) {
      case IssueCategory.pothole:
        return 'Pothole';
      case IssueCategory.streetlight:
        return 'Street Light';
      case IssueCategory.garbage:
        return 'Garbage';
      case IssueCategory.waterSupply:
        return 'Water';
      case IssueCategory.drainage:
        return 'Drainage';
      case IssueCategory.roadDamage:
        return 'Road';
      case IssueCategory.publicToilet:
        return 'Toilet';
      case IssueCategory.parkMaintenance:
        return 'Park';
      case IssueCategory.other:
        return 'Other';
    }
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantpal_2025/thank_you_page.dart';
import 'services.dart';

class FeedbackPage extends StatefulWidget {
  static const routeName = '/feedback';

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  List<String> _selectedIssues = [];
  bool _isAdmin = false;

  final List<String> _issuesOptions = [
    'App crashed',
    'Poor photo quality',
    'Slow performance',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  Future<void> _checkIfAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await DatabaseService().getUserProfile(user.uid);
      setState(() {
        _isAdmin = profile.email == 'admin@example.com';
      });
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    // ⭐ Rating validation
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating.')),
      );
      return;
    }

    // ⭐ If "Other" issue chosen → comment required
    if (_selectedIssues.contains('Other') &&
        _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your issue under "Other".')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final profile = await DatabaseService().getUserProfile(user.uid);

    final feedback = FeedbackModel(
      id: '',
      userId: user.uid,
      userName: profile.fullName ?? user.email ?? 'User',
      comment: _commentController.text.trim(),
      timestamp: DateTime.now(),
      rating: _rating,
      issues: _selectedIssues.isEmpty ? null : _selectedIssues,
    );

    await DatabaseService().addFeedback(feedback);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted successfully!')),
    );

    _commentController.clear();
    setState(() {
      _rating = 0;
      _selectedIssues.clear();
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThankYouPage()),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildIssuesList() {
    return Column(
      children: _issuesOptions.map((issue) {
        final selected = _selectedIssues.contains(issue);
        return ListTile(
          leading: Icon(
            selected ? Icons.check_box : Icons.check_box_outline_blank,
            color: selected ? Colors.green[700] : null,
          ),
          title: Text(issue),
          onTap: () {
            setState(() {
              if (selected) {
                _selectedIssues.remove(issue);
              } else {
                _selectedIssues.add(issue);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Feedback'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'View My Feedbacks',
            onPressed: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyFeedbacksPage(userId: user.uid),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⭐ Title
              Text(
                'Rate your experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),

              // ⭐ Rating
              _buildRatingStars(),

              // ⭐ Visual rating warning
              if (_rating == 0)
                const Text(
                  '★ Please select a rating',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),

              const SizedBox(height: 16),

              Text(
                'Select the issues you have experienced:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green[800],
                ),
              ),

              _buildIssuesList(),
              const SizedBox(height: 16),

              // ⭐ Comment Field
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your experience here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),

                // ⭐ Improved validation
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your comment';
                  }
                  if (val.trim().length < 10) {
                    return 'Comment must be at least 10 characters.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFeedbacksPage extends StatefulWidget {
  final String userId;
  MyFeedbacksPage({required this.userId});

  @override
  _MyFeedbacksPageState createState() => _MyFeedbacksPageState();
}

class _MyFeedbacksPageState extends State<MyFeedbacksPage> {
  final DatabaseService _dbService = DatabaseService();
  final Set<String> _selectedFeedbackIds = {};
  final Set<String> _hiddenFeedbackIds = {};
  bool _isSelectionMode = false;

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedFeedbackIds.contains(id)) {
        _selectedFeedbackIds.remove(id);
        if (_selectedFeedbackIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedFeedbackIds.add(id);
        _isSelectionMode = true;
      }
    });
  }

  void _selectAll(List<FeedbackModel> feedbacks) {
    setState(() {
      if (_selectedFeedbackIds.length == feedbacks.length) {
        _selectedFeedbackIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedFeedbackIds
          ..clear()
          ..addAll(feedbacks.map((fb) => fb.id));
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelectedFeedbacks() async {
    if (_selectedFeedbackIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Hide'),
        content: Text(
          'Hide ${_selectedFeedbackIds.length} feedback(s) from your view?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hide'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _hiddenFeedbackIds.addAll(_selectedFeedbackIds);
        _selectedFeedbackIds.clear();
        _isSelectionMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected feedback hidden.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FeedbackModel>>(
      stream: _dbService.feedbackStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Feedbacks'),
              backgroundColor: Colors.green[700],
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Feedbacks'),
              backgroundColor: Colors.green[700],
              centerTitle: true,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final allFeedbacks = snapshot.data ?? [];
        final feedbacks = allFeedbacks
            .where((fb) =>
        fb.userId == widget.userId &&
            !_hiddenFeedbackIds.contains(fb.id))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(_isSelectionMode
                ? '${_selectedFeedbackIds.length} selected'
                : 'My Feedbacks'),
            backgroundColor: Colors.green[700],
            centerTitle: true,
            actions: [
              if (_isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () => _selectAll(feedbacks),
                ),
              if (_isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelectedFeedbacks,
                ),
            ],
          ),
          body: feedbacks.isEmpty
              ? const Center(
            child: Text('You haven’t submitted any feedback yet.'),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final fb = feedbacks[index];
              final isSelected = _selectedFeedbackIds.contains(fb.id);

              return GestureDetector(
                onLongPress: () => _toggleSelection(fb.id),
                onTap: () {
                  if (_isSelectionMode) {
                    _toggleSelection(fb.id);
                  }
                },
                child: Card(
                  color: isSelected ? Colors.green[50] : Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_isSelectionMode)
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              'Your Feedback',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // ⭐ Rating display
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < (fb.rating ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange,
                              size: 18,
                            );
                          }),
                        ),

                        if (fb.issues != null && fb.issues!.isNotEmpty)
                          Wrap(
                            spacing: 6,
                            children: fb.issues!
                                .map((issue) => Chip(
                              label: Text(issue),
                              backgroundColor: Colors.red[100],
                            ))
                                .toList(),
                          ),

                        Text(fb.comment),
                        const SizedBox(height: 8),

                        if (fb.reply != null && fb.reply!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.green.shade300),
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.reply,
                                    color: Colors.green, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Admin reply: ${fb.reply}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 4),
                        Text(
                          '${fb.timestamp.year}/${fb.timestamp.month}/${fb.timestamp.day}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

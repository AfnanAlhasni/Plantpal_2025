import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'services.dart';

class CommentsPage extends StatelessWidget {
  static const routeName = '/comments';

  const CommentsPage({Key? key}) : super(key: key);

  Future<void> _downloadReport(BuildContext context, List<FeedbackModel> feedbacks) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Comments & Feedback Report 🌿',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          ...feedbacks.map((fb) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 15),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green, width: 1),
              borderRadius: pw.BorderRadius.circular(10),
              color: PdfColors.green50,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('User: ${fb.userName}',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: PdfColors.green900)),
                pw.Text('Date: ${_formatTimestamp(fb.timestamp)}',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                pw.SizedBox(height: 4),
                pw.Text('Rating: ${fb.rating ?? 0}/5',
                    style: pw.TextStyle(color: PdfColors.orange, fontSize: 12)),
                if (fb.issues != null && fb.issues!.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text('Issues:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Wrap(
                    spacing: 6,
                    children: fb.issues!
                        .map((issue) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.red100,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Text(issue, style: const pw.TextStyle(fontSize: 10)),
                    ))
                        .toList(),
                  ),
                ],
                pw.SizedBox(height: 6),
                pw.Text('Comment:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(fb.comment, style: const pw.TextStyle(fontSize: 12)),
                if (fb.reply != null && fb.reply!.isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text('Admin Reply:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                  pw.Text(fb.reply!, style: const pw.TextStyle(fontSize: 12)),
                ],
              ],
            ),
          )),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Comments_Feedback_Report.pdf',
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments & Feedback 🌿'),
        backgroundColor: Colors.green[700],
      ),
      body: FeedbackListOnly(onDownload: _downloadReport),
    );
  }
}

class FeedbackListOnly extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();
  final Future<void> Function(BuildContext, List<FeedbackModel>) onDownload;

  FeedbackListOnly({Key? key, required this.onDownload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FeedbackModel>>(
      stream: _dbService.feedbackStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final feedbacks = snapshot.data ?? [];
        if (feedbacks.isEmpty) {
          return const Center(child: Text('No feedback available currently.'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => onDownload(context, feedbacks),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: feedbacks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final fb = feedbacks[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fb.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                _formatTimestamp(fb.timestamp),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Rating: ',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < (fb.rating ?? 0)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.orange,
                                    size: 16,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (fb.issues != null && fb.issues!.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children: fb.issues!.map((issue) {
                                return Chip(
                                  label: Text(issue,
                                      style: const TextStyle(fontSize: 12)),
                                  backgroundColor: Colors.red[100],
                                );
                              }).toList(),
                            ),
                          if (fb.issues != null && fb.issues!.isNotEmpty)
                            const SizedBox(height: 8),
                          Text(
                            fb.comment,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),

                          // Display Admin Reply
                          if (fb.reply != null && fb.reply!.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.reply, color: Colors.green),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      fb.reply!,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 10),

                          // Reply button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final replyText = await _showReplyDialog(context);
                                if (replyText != null &&
                                    replyText.trim().isNotEmpty) {
                                  await _dbService.sendReply(fb.id, replyText.trim());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Reply sent successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.reply, color: Colors.white),
                              label: const Text('Reply'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Reply Dialog ---
  Future<String?> _showReplyDialog(BuildContext context) async {
    final TextEditingController replyController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Reply'),
        content: TextField(
          controller: replyController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your reply message...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, replyController.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  String personId, currId;
  ReportDialog(this.personId, this.currId);

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'message': _controller.text.trim(),
        'creatorId': widget.currId,
        'reportedId': widget.personId,
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Reported Successfully.'),
      )));
    } catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text('An Error Occurred.'),
      )));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      title: Text(
        'Report User?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Why do you want to report this user? ',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          TextField(
            onChanged: ((value) {
              setState(() {});
            }),
            controller: _controller,
            decoration: InputDecoration(hintText: 'Type here'),
            // style: ,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: _controller.text.trim().isEmpty ? null : _submit,
            child: _isLoading
                ? SizedBox(
                    height: 25, width: 25, child: CircularProgressIndicator())
                : Text('Report')),
      ],
    );
  }
}

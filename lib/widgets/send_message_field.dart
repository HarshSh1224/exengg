import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SendMessageField extends StatefulWidget {
  String personId, currId;
  SendMessageField(
    this.personId,
    this.currId, {
    Key? key,
  }) : super(key: key);

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  bool _isLoading = false;
  String _enteredMessage = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    _enteredMessage.trim();
    print(_enteredMessage);
    print('users/${widget.currId}/chats/${widget.personId}');
    setState(() {
      _isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('users/${widget.currId}/chats')
        .doc('${widget.personId}')
        .set({'data': 'data'});

    await FirebaseFirestore.instance
        .collection('users/${widget.currId}/chats/${widget.personId}/messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'creatorId': widget.currId,
    });
    await FirebaseFirestore.instance
        .collection('users/${widget.personId}/chats')
        .doc('${widget.currId}')
        .set({'data': 'data'});

    await FirebaseFirestore.instance
        .collection('users/${widget.personId}/chats/${widget.currId}/messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'creatorId': widget.currId,
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: TextField(
        onChanged: (value) {
          setState(() {
            _enteredMessage = value;
          });
        },
        controller: _controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            hintText: 'Type a message',
            // labelText: 'Type a message',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
      trailing: _isLoading
          ? SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
          : IconButton(
              color: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(),
              onPressed: _controller.text.trim().isEmpty ? null : _submit,
              icon: Icon(
                Icons.send,
                size: 29,
              ),
            ),
    );
  }
}

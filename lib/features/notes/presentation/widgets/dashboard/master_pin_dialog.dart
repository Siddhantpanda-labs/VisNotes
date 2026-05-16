import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MasterPinDialog extends StatefulWidget {
  final String correctPin;
  final VoidCallback onSuccess;
  final String title;

  const MasterPinDialog({
    super.key,
    required this.correctPin,
    required this.onSuccess,
    this.title = 'Enter Master PIN',
  });

  @override
  State<MasterPinDialog> createState() => _MasterPinDialogState();
}

class _MasterPinDialogState extends State<MasterPinDialog> {
  String _input = '';
  bool _isError = false;

  void _verify() {
    if (_input == widget.correctPin) {
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isError ? Icons.lock_open_outlined : Icons.lock_outline,
            color: _isError ? Colors.redAccent : Colors.black87,
          ),
          const SizedBox(width: 12),
          Text(
            _isError ? 'Incorrect PIN' : widget.title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: _isError ? Colors.redAccent : Colors.black87,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Please enter your secure PIN to access this note.',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          TextField(
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              _input = val;
              if (_isError) setState(() => _isError = false);
            },
            onSubmitted: (_) => _verify(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _verify,
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}

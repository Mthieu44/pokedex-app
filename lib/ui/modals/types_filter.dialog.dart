import 'package:flutter/material.dart';

class TypeFilterDialog extends StatefulWidget {
  const TypeFilterDialog({super.key});

  @override
  State<TypeFilterDialog> createState() => _TypeFilterDialogState();
}

class _TypeFilterDialogState extends State<TypeFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter by Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          // Here you can add your type filter options
          Text('Type filter options will go here.'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      )
    );
  }
}
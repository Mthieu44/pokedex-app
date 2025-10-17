import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pokedex_app/ui/modals/types_filter.dialog.dart';

class ActionMenuWidget extends StatelessWidget{
  const ActionMenuWidget({super.key});

  void _onFilterByTypeTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => TypeFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.filter_list,
      activeIcon: Icons.close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: Icon(Icons.category),
          label: 'Filter by Type',
          onTap: () {
            _onFilterByTypeTap(context);
          },
        ),
      ],
    );
  }
}
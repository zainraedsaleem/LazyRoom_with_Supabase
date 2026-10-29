/*
import 'package:flutter/material.dart';
class ProfileField extends StatelessWidget {
  String title;
  String value;
  Icon icon;
  ProfileField({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          SizedBox(width: 5),
          Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          Spacer(),
          Expanded(
            child: Text(
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.clip,
              value,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
*/

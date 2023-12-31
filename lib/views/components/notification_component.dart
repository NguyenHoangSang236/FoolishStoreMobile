import 'package:fashionstore/data/entity/notification.dart' as noti;
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationComponent extends StatefulWidget {
  const NotificationComponent({super.key, required this.notification});

  final noti.Notification notification;

  @override
  State<StatefulWidget> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.notification.seen
          ? Colors.transparent
          : const Color(0xFFB7E1E4),
      padding: EdgeInsets.symmetric(horizontal: 15.width, vertical: 15.height),
      child: Row(
        children: [
          Container(
            height: 80.size,
            width: 80.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.radius),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/image/additional_logo.png'),
              ),
            ),
          ),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.notification.title ?? 'UNKNOWN',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.size,
                  ),
                ),
                Text(
                  widget.notification.content ?? 'UNKNOWN',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.size,
                  ),
                ),
                Text(
                  widget.notification.notificationDate.dateTime,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.size,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

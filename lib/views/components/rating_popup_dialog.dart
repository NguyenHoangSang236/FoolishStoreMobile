import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/cupertino.dart';

class RatingPopupDialog extends StatefulWidget {
  const RatingPopupDialog({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _RatingPopupDialogState();
}

class _RatingPopupDialogState extends State<RatingPopupDialog> {
  int ratePoint = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...ratingStarList(isRated: true),
          ...ratingStarList(isRated: false),
        ],
      ),
      actions: [
        // The "Yes" button
        CupertinoDialogAction(
          onPressed: () {
            context.router.pop(ratePoint);
          },
          isDefaultAction: true,
          child: const Text(
            'Confirm',
            style: TextStyle(
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
        // The "No" button
        CupertinoDialogAction(
          onPressed: () {
            context.router.pop(0);
          },
          isDestructiveAction: true,
          child: const Text('Cancel'),
        )
      ],
    );
  }

  List<Widget> ratingStarList({bool isRated = false}) {
    return List<Widget>.generate(
      isRated ? ratePoint : 5 - ratePoint,
      (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              ratePoint = isRated ? index + 1 : ratePoint + index + 1;
            });
          },
          child: Container(
            height: 30.size,
            width: 30.size,
            margin: EdgeInsets.fromLTRB(0, 9.height, 2.width, 10.height),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isRated
                      ? 'assets/icon/star_icon.png'
                      : 'assets/icon/unrating_star_icon.png',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

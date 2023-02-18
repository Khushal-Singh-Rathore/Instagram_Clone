import 'package:flutter/material.dart';
import 'package:instagram/widgets/color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({required this.snap, super.key});

  @override
  State<CommentCard> createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 10, right: 9),
      child: Column(
        children: [
          //  ***************************************************************************
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap['ProfilePhoto']),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.snap['username']),
                          const SizedBox(width: 5),
                          Text(
                              DateFormat.MMMd().format(
                                  widget.snap['datePublished'].toDate()),
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 13))
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(widget.snap['comment'])
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.favorite_outline,
                          size: 18,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    Text(
                      '1',
                      style: TextStyle(color: secondaryColor),
                    )
                  ],
                ),
              ]),
          // **************************************
          const SizedBox(
            height: 15,
          ),
          // &&&&&&&&&&&&&&&&&&&&&&&&&&&

          // &&&&&&&&&&&&&&&&&&&&&&&&&&&
        ],
      ),
    );
  }
}

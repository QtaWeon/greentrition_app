import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/classes/comment.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/comment.dart';
import 'package:greentrition/views/profile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  final bool fromThisUser;

  const CommentTile({Key key, this.comment, this.fromThisUser = false})
      : super(key: key);

  @override
  CommentTileState createState() => CommentTileState();
}

class CommentTileState extends State<CommentTile> {
  bool liked = false;

  @override
  void initState() {
    getLocalLikeStatus(this.widget.comment.id).then((value) {
      this.setState(() {
        liked = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: this.widget.fromThisUser
                  ? Color(0xff99EE99).withOpacity(0.4)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Container(
            margin: EdgeInsets.only(top: 5, left: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showCupertinoModalBottomSheet(
                                    enableDrag: true,
                                    expand: false,
                                    context: context,
                                    builder: (context) {
                                      return UserInformation(
                                          this.widget.comment.author,
                                          this.widget.comment.userId);
                                    });
                              },
                              child: CircleAvatar(
                                child: Text(
                                    this.widget.comment.author.toString()[0]),
                                backgroundColor: colorTextDark,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 10, 8.0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    this.widget.comment.author.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      this.widget.comment.text,
                                      style: GoogleFonts.openSans(),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        customBorder: CircleBorder(),
                        onTap: () {
                          setState(() {
                            liked = !liked;
                            if (liked) {
                              this.widget.comment.likes += 1;
                            } else {
                              this.widget.comment.likes -= 1;
                            }
                          });
                          toggleLike(this.widget.comment.id);
                        },
                        child: IconButton(
                          icon: liked
                              ? Row(
                                  children: [
                                    Icon(Icons.thumb_up, color: colorLike),
                                    this.widget.comment.likes > 0
                                        ? Text(
                                            this
                                                .widget
                                                .comment
                                                .likes
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey[800]),
                                          )
                                        : SizedBox(
                                            width: 0,
                                          )
                                  ],
                                )
                              : Row(children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey,
                                  ),
                                  this.widget.comment.likes > 0
                                      ? Text(
                                          this.widget.comment.likes.toString(),
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                        )
                                      : SizedBox(
                                          width: 0,
                                        )
                                ]),
                        ),
                      )
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

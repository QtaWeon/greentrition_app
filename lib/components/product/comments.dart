import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greentrition/classes/comment.dart';
import 'package:greentrition/components/registration/register_for_feature.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/functions/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'comment.dart';
import 'package:google_fonts/google_fonts.dart';

class Comments extends StatefulWidget {
  final String product_id;
  final ScrollController scrollController;

  const Comments({Key key, this.product_id, this.scrollController})
      : super(key: key);

  @override
  CommentsState createState() => CommentsState();
}

class CommentsState extends State<Comments> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  Key login_key = UniqueKey();
  List<Comment> _comments = [];
  List<Comment> _displayedComments = [];
  int maxCountComments = 0;
  bool initialized = false;
  String newComment = "";
  String author;
  TextEditingController _textEditController;
  bool showLoading = false;
  bool lock = true;
  bool loadCommentsTriggered = false;

  @override
  void initState() {
    isFreeUser().then((value) => lock = value);
    this.widget.scrollController.addListener(onScroll);
    AppDb.getComments(this.widget.product_id).then((value) {
      if (mounted) {
        setState(() {
          _comments = value;
          _comments.sort((a, b) => b.likes.compareTo(a.likes));
          maxCountComments = _comments.length;
          Future.delayed(Duration(milliseconds: 10), () {
            showMoreComments(10);
          });
          initialized = true;
        });
      }
    });
    getUsername().then((value) {
      setState(() {
        author = value;
      });
    });
    _textEditController = TextEditingController();
    super.initState();
  }

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: colorTextDark,
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  void submitComment() {
    if (author == null) {
      showToast("Ein Fehler ist aufgetreten.");
    } else if (newComment.length <= 4) {
      showToast("Text zu kurz.");
    } else if (newComment.length > 144) {
      showToast("Text zu lang.");
    } else {
      AppDb.addComment(this.widget.product_id, newComment, author,
          categoryToText[Category.all]);
      _textEditController.clear();
      FocusScope.of(context).unfocus();

      // delayed re-fetch
      Future.delayed(Duration(milliseconds: 500), () {
        loadComments();
      });
    }
  }

  void onScroll() {
    if (this.widget.scrollController.offset >
        this.widget.scrollController.position.maxScrollExtent - 20) {
      setState(() {
        showLoading = true;
      });

      //check if max available comments are shown
      //Means that all comments are moved to displayComments array
      //then trigger loadComment once
      if (_comments.length == 0 && !loadCommentsTriggered) {
        loadCommentsTriggered = true;
        loadComments();
      }

      Timer(Duration(milliseconds: 400), () {
        loadCommentsTriggered = false;
        setState(() {
          showLoading = false;
        });
        showMoreComments(5);
      });
    }
  }

  //Comments are removed from _comments and added to _displayedComments
  void showMoreComments(int amount) {
    int lengthNow = _displayedComments.length;
    if (lengthNow < maxCountComments)
      for (int i = 0; i < amount; i++) {
        if (_comments.isNotEmpty) {
          int index = _displayedComments.length;
          Comment comment = _comments.removeAt(0);
          _displayedComments.insert(index, comment);
          if (listKey.currentState != null) {
            listKey.currentState.insertItem(index);
          }
        }
      }
  }

  void loadComments() {
    if (maxCountComments == 0 || _comments.length == 0 && showLoading) {
      AppDb.getComments(this.widget.product_id).then((value) {
        if (maxCountComments > value.length) {
          _comments = value;
        } else {
          //Only add new comments
          _comments = value.sublist(maxCountComments);
          _comments.sort((a, b) => b.likes.compareTo(a.likes));
        }
        setState(() {
          //increase maxCount
          maxCountComments += _comments.length;

          initialized = true;
        });
        Future.delayed(Duration(milliseconds: 10), () {
          showMoreComments(5);
        });
      });
    }
  }

  void updateLoginKey() {
    this.login_key = UniqueKey();
  }

  void showLoginPopup() {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
      return RegisterForFeature(
        login_key: this.updateLoginKey,
      );
    }));
  }

  Container buildComments() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: backgroundColorEnd.withOpacity(0.7),
      ),
      child: AnimatedList(
          key: listKey,
          physics: NeverScrollableScrollPhysics(),
          initialItemCount: _displayedComments.length,
          shrinkWrap: true,
          itemBuilder: (context, index, animation) {
            Comment comment = _displayedComments[index];
            return comment.author == author
                ? SizeTransition(
                    sizeFactor: animation,
                    child: Dismissible(
                      onDismissed: (direction) {
                        listKey.currentState.removeItem(
                            index,
                            (context, animation) =>
                                SizedBox(width: 0, height: 0));
                        _displayedComments.removeAt(index);
                        //remove from DB
                        AppDb.removeComment(comment.id);
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: colorSugar,
                        child: Icon(Icons.delete),
                      ),
                      key: ValueKey(index),
                      child: CommentTile(comment: comment, fromThisUser: true),
                    ))
                : CommentTile(
                    comment: comment,
                  );
          }),
    );
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialized
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorTextGrey,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 3),
                  child: TextField(
                    // enabled: !lock,
                    controller: _textEditController,
                    style: GoogleFonts.openSans(),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                      border: InputBorder.none,
                      hintText: "Öffentlich kommentieren...",
                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          Icons.send,
                          color: colorVegan,
                        ),
                        onPressed: () {
                          if (!lock) {
                            submitComment();
                          } else {
                            showLoginPopup();
                          }
                        },
                      ),
                    ),
                    onTap: () {
                      if (lock) {
                        showLoginPopup();
                      }
                    },
                    onChanged: (str) {
                      setState(() {
                        newComment = str;
                      });
                    },
                    onSubmitted: (str) {
                      submitComment();
                    },
                  ),
                ),
              ),
              // IconButton(
              // icon: Icon(
              //   Icons.send,
              //   color: colorVegan,
              // ),
              // onPressed: () {
              //   submitComment();
              // },
              // ),
        buildComments(),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: showLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorVegan),
          )
              : SizedBox(
            height: 0,
          ),
        )
      ],
    )
        : SizedBox(
      height: 0,
    );
  }
}

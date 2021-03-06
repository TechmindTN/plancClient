import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final String type;
  final String userName;
  final String myimageUrl;
  final String imageUrl;
  final bool isMe;
  final Key key;

  MessageBubble(
    this.content,
    this.type,
    this.userName,
    this.imageUrl,
    this.myimageUrl,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //   colors: [
                //     Color.fromARGB(255, 155, 39, 176),
                //     Color.fromARGB(255, 233, 30, 98)
                //   ],
                //   tileMode: TileMode.clamp,
                //   begin: Alignment.topRight,
                //   end: Alignment.bottomLeft,
                // ),
                color: !isMe ? Colors.blue[200] : Colors.blue[700],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe ? Radius.zero : const Radius.circular(12),
                  bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                ),
                border: Border.all(
                    width: 2, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              width: 200,
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(162, 255, 255, 255),
                    ),
                  ),
                  type == "text"
                      ? Text(
                          content,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        )
                      : Center(
                          child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      insetPadding: EdgeInsets.all(0),
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        color:
                                            Colors.transparent.withOpacity(0.3),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: Image.network(
                                          content,
                                          // scale: 20,

                                          fit: BoxFit.fill,
                                          // width: MediaQuery.of(context).size.width*0.9,
                                          // height: MediaQuery.of(context).size.height*0.8,

                                          // scale: 0.1,
                                        ),
                                      ));
                                });
                            //Get.toNamed(Routes.CATEGORY, arguments: _category);
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: [
                                ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                      content,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                    // child: CachedNetworkImage(
                                    //   height: 100,
                                    //   width: double.infinity,
                                    //   fit: BoxFit.cover,
                                    //   imageUrl: media,
                                    //   placeholder: (context, url) => Image.asset(
                                    //     'assets/img/loading.gif',
                                    //     fit: BoxFit.cover,
                                    //     width: double.infinity,
                                    //     height: 100,
                                    //   ),
                                    //   errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                    // ),
                                    ),
                              ],
                            ),
                          ),
                        ))
                ],
              ),
            )
          ],
        ),
        isMe
            ? Positioned(
                top: 0,
                right: 180,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
              )
            : Positioned(
                top: 0,
                left: 180,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(myimageUrl),
                ),
              ),
      ],
      clipBehavior: Clip.none,
    );
  }
}

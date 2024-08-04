import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tinder_cards/post.dart';
import 'package:flutter_tinder_cards/profile_picture.dart';
import 'package:flutter_tinder_cards/skeleton_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TinderCard extends StatefulWidget {
  final String username;
  final String profileImageURL;
  final Post post;
  final Function onDrag;
  final Color skeletonBackgroundColor;

  const TinderCard({
    super.key,
    required this.username,
    this.profileImageURL = '',
    required this.post,
    required this.onDrag,
    this.skeletonBackgroundColor = const Color.fromARGB(255, 69, 69, 69)
  });

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {

  int page = 0;
  Offset offset = Offset.zero;
  PageController photoController = PageController(initialPage: 0);
  
  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.sizeOf(context).width;
    double sHeight = MediaQuery.sizeOf(context).height;
    double hLimit = sHeight/16;
    double wLimit = sWidth/8;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          offset += details.delta;
        });
      },
      onPanEnd: (details) {
        if (offset.dx.abs() > wLimit || offset.dy.abs() > hLimit){
          //OUTSIDE OF SAFE BOX
          if (offset.dx.abs() > offset.dy.abs()){
            //X AXIS
            if (offset.dx > 0){
              setState(() {
                offset = Offset(sWidth*1.6, 0);
              });
              widget.onDrag(widget.key, widget.post, 'Right');
            }else{
              setState(() {
                offset = Offset(-sWidth*1.6, 0);
              });
              widget.onDrag(widget.key, widget.post, 'Left');
            }
          }else{
            //Y AXIS REMOVED
            if (offset.dy > 0){
              setState(() {
                offset = Offset(0, sHeight*1.1);
              });
              widget.onDrag(widget.key, widget.post, 'Down');
            }else{
              setState(() {
                offset = Offset(0, -sHeight*1.1);
              });
              widget.onDrag(widget.key, widget.post, 'Up');
            }
          }
        }else{
          setState(() {
            offset = Offset.zero;
          });
        }
      },
      child: AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        transform: Matrix4.identity()
          ..translate(offset.dx, offset.dy)
          ..rotateZ(offset.dx / sWidth * 15 * pi / 180),
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            SkeletonCard(
              backgroundColor: widget.skeletonBackgroundColor,
            ),
            PageView.builder(
              itemCount: widget.post.imageURLs.length,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: photoController,
              onPageChanged: (index) {
                page = index;
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTapUp: (details) {
                      if (details.globalPosition.dx > sWidth / 2){
                      if (page < widget.post.imageURLs.length - 1){
                        setState(() {
                          photoController.jumpToPage(page + 1);
                        });
                      }
                    }else{
                      if (page > 0){
                        setState(() {
                          photoController.jumpToPage(page - 1);
                        });
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 250),
                          cacheKey: widget.post.imageURLs[index],
                          imageUrl: widget.post.imageURLs[index],
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: offset.dx.abs() > wLimit ? 1 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: 
                              offset.dx == 0 ?
                                [Colors.transparent, Colors.transparent]
                              : offset.dx > 0 ?
                                [ Color.fromARGB(
                                  ((offset.dx.abs() * 100) / sWidth / 2).toInt() + 100, 
                                70, 250, 110), Colors.transparent]
                              : [ Color.fromARGB(
                                  ((offset.dx.abs() * 100) / sWidth / 2).toInt() + 100,
                                250, 70, 110), Colors.transparent],
                              stops: const [0.02, 1],
                              begin: const Alignment(0.0, 1.0),
                              end: const Alignment(0.0, -2),
                            )
                          )
                        )
                      )
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Visibility(
                          visible: widget.post.imageURLs.length > 1,
                          child: AnimatedSmoothIndicator(
                            activeIndex: page,
                            count: widget.post.imageURLs.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 6,
                              dotWidth: 24,
                              radius: 4,
                              spacing: 8,
                              activeDotColor: Colors.white
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfilePicture(
                              title: widget.username,
                              image: widget.profileImageURL, 
                              size: 36,
                              color: Theme.of(context).textTheme.bodyMedium!.color!,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '@${widget.username}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.post.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
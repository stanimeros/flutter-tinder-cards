import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tinder_cards/photo_slider.dart';
import 'package:flutter_tinder_cards/skeleton_card.dart';

class TinderCard extends StatefulWidget {
  final List<String> imageURLs;
  final Function onDrag;
  final Color skeletonBackgroundColor;
  final Widget overlayWidget;

  const TinderCard({
    super.key,
    this.imageURLs = const [],
    required this.onDrag,
    this.overlayWidget = const Column(),
    this.skeletonBackgroundColor = const Color.fromARGB(255, 69, 69, 69),
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
              widget.onDrag(widget.key, 'Right');
            }else{
              setState(() {
                offset = Offset(-sWidth*1.6, 0);
              });
              widget.onDrag(widget.key, 'Left');
            }
          }else{
            //Y AXIS REMOVED
            if (offset.dy > 0){
              setState(() {
                offset = Offset(0, sHeight*1.1);
              });
              widget.onDrag(widget.key, 'Down');
            }else{
              setState(() {
                offset = Offset(0, -sHeight*1.1);
              });
              widget.onDrag(widget.key, 'Up');
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
            PhotoSlider(
              imageURLs: widget.imageURLs,
            ),
            widget.overlayWidget
          ],
        ),
      )
    );
  }
}
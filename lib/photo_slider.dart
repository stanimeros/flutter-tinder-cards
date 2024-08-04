import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PhotoSlider extends StatefulWidget {
  final List<String> imageURLs;

  const PhotoSlider({
    super.key,
    this.imageURLs = const []
  });

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  int page = 0;
  PageController photoController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.sizeOf(context).width;
    return  PageView.builder(
      itemCount: widget.imageURLs.length,
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
              if (page < widget.imageURLs.length - 1){
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
                  cacheKey: widget.imageURLs[index],
                  imageUrl: widget.imageURLs[index],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Visibility(
                        visible: widget.imageURLs.length > 1,
                        child: AnimatedSmoothIndicator(
                          activeIndex: page,
                          count: widget.imageURLs.length,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
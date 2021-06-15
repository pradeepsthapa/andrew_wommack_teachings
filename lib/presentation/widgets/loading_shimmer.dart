import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        LoadingShimmer(
          height: 220,
          shapeBorder: RoundedRectangleBorder(),
          width: size.width,
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
          child: Align(
              alignment: Alignment.topLeft,
              child: LoadingShimmer(
                height: 20,
                width: size.width * .7,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
          child: LoadingShimmer(
            height: 20,
            width: size.width,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LoadingShimmer(
                  width: 150,
                  height: 30,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              LoadingShimmer(
                  width: 150,
                  height: 30,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
            ],
          ),
        ),
        ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                child: ListTile(
                  leading: LoadingShimmer(
                    height: 60,
                    width: 64,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingShimmer(
                        height: 15,
                        width: size.width * .5,
                        shapeBorder: RoundedRectangleBorder(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LoadingShimmer(
                        height: 12,
                        width: size.width,
                        shapeBorder: RoundedRectangleBorder(),
                      )
                    ],
                  ),
                  // subtitle: LoadingShimmer(height: 12,width:size.width,shapeBorder: RoundedRectangleBorder(),),
                ),
              );
            }),
      ],
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder? shapeBorder;

  const LoadingShimmer(
      {@required this.width,
      @required this.height,
      @required this.shapeBorder});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[900]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
            color: isDark ? Colors.grey[800]! : Colors.grey[300],
            shape: shapeBorder!),
      ),
    );
  }
}

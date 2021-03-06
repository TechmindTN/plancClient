import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_pages.dart';
import '../../category/controllers/category_controller.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (_, index) {
              var _category = controller.categories.elementAt(index);
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORY, arguments: _category);
                },
                child: Container(
                  width: 100,
                  margin: EdgeInsetsDirectional.only(
                      end: 20, start: index == 0 ? 25 : 0, bottom: 3, top: 3),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: new BoxDecoration(
                    color: Get.theme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.3),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    // gradient: new LinearGradient(
                    //     colors: [_category.color.withOpacity(1), _category.color.withOpacity(0.1)],
                    //     begin: AlignmentDirectional.topStart,
                    //     //const FractionalOffset(1, 0),
                    //     end: AlignmentDirectional.bottomEnd,
                    //     stops: [0.1, 0.9],
                    //     tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 5, top: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                              child: Center(
                            child: Image.network(
                              _category.icon,
                              fit: BoxFit.scaleDown,
                            ),
                          )),
                          // child: (_category.mediaUrl.toLowerCase().endsWith('.svg')
                          //     ? SvgPicture.network(
                          //         _category.mediaUrl,
                          //         color: _category.color,
                          //       )
                          //     : CachedNetworkImage(
                          //         fit: BoxFit.cover,
                          //         imageUrl: _category.mediaUrl,
                          //         placeholder: (context, url) => Image.asset(
                          //           'assets/img/loading.gif',
                          //           fit: BoxFit.cover,
                          //         ),
                          //         errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          //       )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _category.name,
                            maxLines: 2,
                            style: Get.textTheme.bodyText2.merge(TextStyle(
                              color: Ui.parseColor('#00B6BF'),
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}

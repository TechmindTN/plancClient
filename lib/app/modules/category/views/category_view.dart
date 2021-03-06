import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/home_search_bar_widget.dart';
import '../../home/widgets/address_widget.dart';
import '../controllers/category_controller.dart';
import '../widgets/services_list_widget.dart';
import '../../search/widgets/search_services_list_widget.dart';

class CategoryView extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshEServices(showMessage: true);
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              expandedHeight: 280,
              elevation: 0.5,
              primary: true,
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              title: Text(
                controller.category.value.name ?? '',
                style: Get.textTheme.headline6
                    .merge(TextStyle(color: Get.theme.primaryColor)),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios,
                    color: Get.theme.primaryColor),
                onPressed: () => {Get.back()},
              ),
              bottom: HomeSearchBarWidget(),
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 75, bottom: 115),
                          decoration: new BoxDecoration(
                            color: Ui.parseColor('#00CED1'),
                            // gradient: new LinearGradient(
                            //     // colors: [controller.category.value.color.withOpacity(1), controller.category.value.color.withOpacity(0.2)],
                            //     begin: AlignmentDirectional.topStart,
                            //     //const FractionalOffset(1, 0),
                            //     end: AlignmentDirectional.bottomEnd,
                            //     stops: [0.1, 0.9],
                            //     tileMode: TileMode.clamp),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                          ),
                          child:
                              // (controller.category.value.mediaUrl.toLowerCase().endsWith('.svg')
                              //     ? SvgPicture.network(
                              //         controller.category.value.mediaUrl,
                              //         color: controller.category.value.color,
                              //       )
                              //     :
                              CachedNetworkImage(
                            fit: BoxFit.scaleDown,
                            imageUrl: controller.category.value.icon,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              scale: 5,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          )
                          // ),
                          ),
                    ],
                  )).marginOnly(bottom: 42),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  Container(
                    height: 60,
                    child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(CategoryFilter.values.length,
                            (index) {
                          var _filter = CategoryFilter.values.elementAt(index);
                          return Obx(() {
                            return Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 20),
                              child: RawChip(
                                elevation: 0,
                                label: Text(_filter.toString().tr),
                                labelStyle: controller.isSelected(_filter)
                                    ? Get.textTheme.bodyText2.merge(TextStyle(
                                        color: Get.theme.primaryColor))
                                    : Get.textTheme.bodyText2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                                backgroundColor: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.1),
                                // selectedColor: controller.category.value.color,
                                selected: controller.isSelected(_filter),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                showCheckmark: true,
                                checkmarkColor: Get.theme.primaryColor,
                                onSelected: (bool value) {
                                  controller.toggleSelected(_filter);
                                  if (controller
                                      .isSelected(CategoryFilter.ALL)) {
                                    controller.sortAll();
                                  }

                                  if (controller
                                      .isSelected(CategoryFilter.RATING)) {
                                    controller.sortRating();
                                  }

                                  controller.getEServicesOfCategory(
                                      filter: controller.selected.value);
                                },
                              ),
                            );
                          });
                        })),
                  ),
                  Container(
                    height: 445,
                    child:
                        SearchServicesListWidget(services: controller.services),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

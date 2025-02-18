import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/repository/location_data_fetch.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/find_food/widgets/list_tile_widget.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationDataRepository locationDataRepository =
        Get.find<LocationDataRepository>();
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(
        showLogOut: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () {
            final dataList = locationDataRepository.combinedDataList;
            return locationDataRepository.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) =>
                        buildListTile(dataList[index]),
                  );
          },
        ),
      ),
    );
  }
}

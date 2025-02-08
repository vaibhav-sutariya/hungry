import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/res/components/customElevatedButton.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/view_models/controllers/add_foodbank/add_foodbank_view_model.dart';

class FoodBankConfirmationScreen extends StatelessWidget {
  FoodBankConfirmationScreen({super.key});

  final AddFoodbankViewModel controller = Get.put(AddFoodbankViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Q/A',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Checkbox 1: Accepting Remaining Food
              Obx(() => CheckboxListTile(
                    title: Text('1. Are you accepting Remaining Food?'),
                    value: controller.acceptingRemainingFood.value,
                    onChanged: (value) =>
                        controller.toggleAcceptingRemainingFood(value),
                    activeColor: AppColors.kPrimaryColor,
                  )),
              Obx(() {
                if (controller.acceptingRemainingFood.value) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomTextField(
                      controller: controller.minPeopleAcceptedController.value,
                      labelText: 'Minimum People Accepted',
                      hintText: 'Enter the minimum number of people',
                      suffixIcon: Icon(Icons.people),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),

              // Checkbox 2: Distributing to Needy Person
              Obx(() => CheckboxListTile(
                    title: Text(
                        '2. Are you distributing food to any hungry Needy Person?'),
                    value: controller.distributingToNeedyPerson.value,
                    onChanged: (value) =>
                        controller.toggleDistributingToNeedyPerson(value),
                    activeColor: AppColors.kPrimaryColor,
                  )),
              Obx(() {
                if (!controller.distributingToNeedyPerson.value) {
                  return CheckboxListTile(
                    title: Text(
                        'If a hungry person locates you and comes to your center, can you give them a free meal?'),
                    value: controller.freeMealAvailable.value,
                    onChanged: (value) =>
                        controller.toggleFreeMealAvailable(value),
                    activeColor: AppColors.kPrimaryColor,
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),

              // Checkbox 3: Accepting Donations
              Obx(() => CheckboxListTile(
                    title: Text('3. Are you accepting Donations?'),
                    value: controller.acceptingDonations.value,
                    onChanged: (value) =>
                        controller.toggleAcceptingDonations(value),
                    activeColor: AppColors.kPrimaryColor,
                  )),

              SizedBox(height: 20),

              // Terms and Conditions Checkbox
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.acceptTermsAndConditions.value,
                        onChanged: (value) =>
                            controller.toggleAcceptTermsAndConditions(value),
                        activeColor: AppColors.kPrimaryColor,
                      ),
                      Expanded(
                        child: Text(
                          'Accept the Terms & Conditions and Privacy Policy of Hungry (India).',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )),

              SizedBox(height: 20),

              // Submit Button
              Obx(
                () => Center(
                  child: controller.loading.value
                      ? CircularProgressIndicator(
                          color: AppColors.kPrimaryColor,
                        )
                      : CustomElevatedButton(
                          onPressed: () {
                            controller.saveFoodBankData();
                          },
                          text: 'Submit',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

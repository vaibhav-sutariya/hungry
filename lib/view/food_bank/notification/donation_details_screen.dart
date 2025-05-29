import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/models/left_over_food_model.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view_models/controllers/add_foodbank/donation_details_view_model.dart';

class DonationDetailsScreen extends StatelessWidget {
  const DonationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        Get.arguments as Map<String, dynamic>? ?? {};
    final String id = args['id'] ?? 'N/A';

    final controller = Get.put(DonationDetailsViewModel());
    controller.fetchFoodDetails(id);

    return RefreshIndicator(
      color: AppColors.kPrimaryColor,
      backgroundColor: AppColors.kWhiteColor,
      onRefresh: () async {
        await controller.fetchFoodDetails(id);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(),
        drawer: MyDrawer(
          showLogOut: false,
        ),
        body: SafeArea(
          child: Container(
            child: Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: controller.isLoading
                    ? _buildLoadingState()
                    : controller.error != null
                        ? _buildErrorState(controller.error!)
                        : controller.food == null
                            ? _buildNoDataState()
                            : _buildContent(context, controller),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.kPrimaryColor,
          ),
          const SizedBox(height: 16),
          Text('Loading Donation Details...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      key: const ValueKey('error'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(error,
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.find<DonationDetailsViewModel>()
                .fetchFoodDetails(Get.arguments['id']),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      key: const ValueKey('no_data'),
      child: Text(
        'No data available',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, DonationDetailsViewModel controller) {
    final food = controller.food!;

    return ListView(
      key: const ValueKey('content'),
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Donation Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildInfoCard(context, food),
        const SizedBox(height: 16),
        _buildMap(food.latitude, food.longitude),
        const SizedBox(height: 24),
        _buildActionButtons(context, controller, food),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, LeftoverFood food) {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile(
                icon: Icons.person,
                label: 'Donor',
                value: food.fName,
                onTap: () => {}),
            _buildInfoTile(
              icon: Icons.phone,
              label: 'Phone',
              value: food.phone,
              onTap: () {},
            ),
            _buildInfoTile(
              icon: Icons.location_on,
              label: 'Address',
              value: food.address,
            ),
            _buildInfoTile(
              icon: Icons.people,
              label: 'Persons',
              value: food.numberOfPersons,
            ),
            _buildInfoTile(
              icon: Icons.description,
              label: 'Details',
              value: food.details,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(double latitude, double longitude) {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 300),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('donation_location'),
                position: LatLng(latitude, longitude),
                infoWindow: const InfoWindow(title: 'Donation Location'),
              ),
            },
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.kPrimaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: '$label : ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: value,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context,
      DonationDetailsViewModel controller, LeftoverFood food) {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.check_circle_outline,
            label: 'Claim',
            color: AppColors.kPrimaryColor,
            onPressed: () => _showClaimConfirmation(context, controller),
          ),
          _buildActionButton(
            icon: Icons.phone,
            label: 'Contact',
            color: Colors.green,
            onPressed: () {
              controller.contactDonor(food.phone);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        iconColor: AppColors.kWhiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showClaimConfirmation(
      BuildContext context, DonationDetailsViewModel controller) {
    Get.defaultDialog(
      title: 'Confirm Claim',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      content: Text(
        'Are you sure you want to claim this donation?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            controller.claimDonation();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Claim', style: TextStyle(color: AppColors.kWhiteColor)),
        ),
      ],
    );
  }
}

class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInAnimation(
      {super.key, required this.child, this.delay = Duration.zero});

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    Future.delayed(widget.delay, () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

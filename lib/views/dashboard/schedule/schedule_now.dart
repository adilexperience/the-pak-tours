// take location or products in parameter to schedule
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:the_pak_tours/views/views_exporter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ScheduleNow extends StatefulWidget {
  final ProductModel product;
  final UserModel seller;
  const ScheduleNow({
    Key? key,
    required this.product,
    required this.seller,
  }) : super(key: key);

  @override
  State<ScheduleNow> createState() => _ScheduleNowState();
}

class _ScheduleNowState extends State<ScheduleNow> {
  bool _isLoading = false,
      isPlanningToday = true; // setting planning today to initial true
  TimeOfDay _time = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _isLoading
              ? Positioned.fill(
                  child: Stack(
                    children: [
                      Container(
                        color: AppColors.strongText.withOpacity(0.25),
                      ),
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () => Constants.pop(context),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back,
                              size: 26.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        PrimaryCard(
                          cardColor: AppColors.lightPrimary.withOpacity(0.50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Schedule visit",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                "Let us know when you are planning for a visit to this location and we will notify seller to keep this product ready and expect you.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryCard(
                                      onPressed: () => _toggleVisit(true),
                                      cardColor: isPlanningToday
                                          ? AppColors.primary
                                          : Colors.white,
                                      child: Text(
                                        "Planning to visit today",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: isPlanningToday
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: PrimaryCard(
                                      onPressed: () => _toggleVisit(false),
                                      cardColor: !isPlanningToday
                                          ? AppColors.primary
                                          : Colors.white,
                                      child: Text(
                                        "In Upcoming Days?",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: !isPlanningToday
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              !isPlanningToday
                                  ? const SizedBox(height: 40.0)
                                  : const SizedBox.shrink(),
                              !isPlanningToday
                                  ? PrimaryButton(
                                      buttonText: "Select Date of your visit",
                                      buttonTextColor: Colors.black,
                                      buttonColor: Colors.white,
                                      onPressed: () => _selectDate(context),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 20.0),
                              PrimaryButton(
                                buttonText:
                                    "Select approximate time of your visit",
                                buttonTextColor: Colors.black,
                                buttonColor: Colors.white,
                                onPressed: () => Navigator.of(context).push(
                                  showPicker(
                                    context: context,
                                    value: _time,
                                    onChange: onTimeChanged,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              InputField(
                                leadingIcon: Icons.production_quantity_limits,
                                fieldHint:
                                    'Enter number of items you will purchase',
                                controller: quantityController,
                                inputType: TextInputType.number,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                "You are scheduling a visit to purchase 10 ${widget.product.title} from ${widget.seller.name}. Your expected arrival is on ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} at ${_time.hour}:${_time.minute}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              PrimaryButton(
                                onPressed: () => _processSchedule(),
                                buttonText: "Schedule Visit",
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _toggleVisit(bool isVisitingToday) {
    isPlanningToday = isVisitingToday;
    if (isPlanningToday) {
      selectedDate = DateTime.now();
    }

    setState(() {});
  }

  void onTimeChanged(TimeOfDay selectedTime) {
    _time = selectedTime;
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // user can pick today and onwards 30 days
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _processSchedule() async {
    String quantity = quantityController.text.trim();
    // if time is before now, we should ask user to select time.

    DateTime _selectedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime _today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (quantity.isEmpty) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "Please type how many items you wish to purchase",
        ),
      );
    } else if (_selectedDate.isAtSameMomentAs(_today) &&
        (toDouble(_time) <= toDouble(TimeOfDay.now()))) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "Please select time ahead of now.",
        ),
      );
    } else {
      _isLoading = true;
      setState(() {});

      await ApiRequests.sendNotification(
        "Visit Scheduled for ${widget.product.title}",
        "Visit is scheduled for a purchase of 10 ${widget.product.title} from ${widget.seller.name}. Customer arrival is expected on ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} at ${_time.hour}:${_time.minute}",
        widget.product.seller,
        widget.product.image,
      );

      _isLoading = false;
      setState(() {});

      Constants.pushAndRemoveAll(
        context,
        const Dashboard(),
      );
    }
  }

  // to compare time of day we have to use it in double
  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}

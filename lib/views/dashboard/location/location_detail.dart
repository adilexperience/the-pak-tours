import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:the_pak_tours/views/views_exporter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LocationDetailScreen extends StatefulWidget {
  final PlaceModel place;

  const LocationDetailScreen({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  List<ReviewModel> reviews = [];
  TextEditingController feedbackController = TextEditingController();
  double placeRating =
      5.0; // setting this initial so user can either go with this or update
  bool isAddingReview = false;

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  Future<void> getReviews() async {
    reviews = await ApiRequests.getReviewsOfPlace(widget.place.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    widget.place.images.first,
                    height: 400,
                    width: _size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  margin: const EdgeInsets.only(bottom: 110.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          TileCard(
                            title: widget.place.type,
                            textColor: AppColors.primary,
                            borderRadius: 15.0,
                            bgColor: AppColors.primary.withOpacity(0.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        widget.place.title,
                        style: const TextStyle(
                          color: AppColors.strongText,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.place.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemSize: 30.0,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double ratedValue) {},
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            "${widget.place.rating} (${reviews.length} reviews)",
                            style: const TextStyle(
                              color: AppColors.lightText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        widget.place.description,
                        style: const TextStyle(
                          color: AppColors.lightText,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _size.width * 0.02),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '5-day forecast | Every 3 hours',
                                  style: GoogleFonts.questrial(
                                    color: Colors.black,
                                    fontSize: _size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.black),
                              FutureBuilder<WeatherModel>(
                                future: ApiRequests.getWeatherInformation(
                                  widget.place.location.latitude,
                                  widget.place.location.longitude,
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }
                                  WeatherModel weather = snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: weather.list?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      ListElement? weatherListElement =
                                          weather.list!.elementAt(index);
                                      return buildSevenDayForecast(
                                        "${weatherListElement!.dtTxt!.day}-${weatherListElement.dtTxt!.month}-${weatherListElement.dtTxt!.year} ${weatherListElement.dtTxt!.toString().substring(11, 16)}",
                                        weatherListElement.main!.tempMin!,
                                        weatherListElement.main!.tempMax!,
                                        'http://openweathermap.org/img/w/${weatherListElement.weather!.first!.icon}.png',
                                        _size,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      reviews.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Hear what others say",
                                  style: TextStyle(
                                    color: AppColors.strongText,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                const Text(
                                  "Every feedback is appreciated and helpful for other tourists to explore the location",
                                  style: TextStyle(
                                    color: AppColors.lightText,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  height: 120.0,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemCount: reviews.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      ReviewModel review = reviews[index];
                                      return Container(
                                        width: 280.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: AppColors.lightText
                                              .withOpacity(0.10),
                                        ),
                                        margin: const EdgeInsets.only(
                                          right: 10.0,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                        ),
                                        child: FutureBuilder<UserModel>(
                                            future: ApiRequests.getUserById(
                                                review.userId),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                );
                                              }
                                              return Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: AppColors
                                                        .lightText
                                                        .withOpacity(0.10),
                                                    radius: 26.0,
                                                    backgroundImage: snapshot
                                                            .data!
                                                            .imageUrl
                                                            .isEmpty
                                                        ? const AssetImage(
                                                            "assets/images/user.png")
                                                        : NetworkImage(snapshot
                                                                .data!.imageUrl)
                                                            as ImageProvider,
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Text(
                                                          "${snapshot.data!.name} Say's",
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 1.5),
                                                        Text(
                                                          review.remarks,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .strongText
                                                                .withOpacity(
                                                                    0.85),
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                              ],
                            ),
                      const Text(
                        "Leave a rating",
                        style: TextStyle(
                          color: AppColors.strongText,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Your feedback will help more tourists explore ${widget.place.title}.",
                        style: const TextStyle(
                          color: AppColors.lightText,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      RatingBar.builder(
                        initialRating: placeRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 24.0,
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double ratedValue) {
                          placeRating = ratedValue;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 2.5),
                      InputField(
                        leadingIcon: Icons.pending_actions,
                        fieldHint: 'Enter your remarks',
                        controller: feedbackController,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isAddingReview
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : PrimaryButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 15.0,
                                  ),
                                  buttonText: "Publish review",
                                  onPressed: () => _publishReview(),
                                ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "Nearby Sellers",
                        style: TextStyle(
                          color: AppColors.strongText,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder<List<UserModel>>(
                          future: ApiRequests.getNearbySellers(
                            widget.place.location,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                            if (snapshot.data == null) {
                              return const NoRecordsAvailable(
                                title: "No nearby sellers available",
                                description:
                                    "At the moment location does not have sellers available. Exploring location is fun itself.",
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data?.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                UserModel seller = snapshot.data![index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.lightText.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundColor: AppColors.lightText,
                                        backgroundImage: seller.imageUrl.isEmpty
                                            ? const AssetImage(
                                                "assets/images/user.png",
                                              )
                                            : NetworkImage(seller.imageUrl)
                                                as ImageProvider,
                                      ),
                                      const SizedBox(width: 20.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              seller.name,
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2.5,
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            Text(
                                              "${Constants.getDistance(
                                                LatLng(
                                                    widget.place.location
                                                        .latitude,
                                                    widget.place.location
                                                        .longitude),
                                                LatLng(
                                                  seller.location!.latitude,
                                                  seller.location!.longitude,
                                                ),
                                                responseInKilometer: false,
                                              )} meters away",
                                              style: const TextStyle(
                                                color: AppColors.strongText,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2.5),
                                            FutureBuilder<List<ProductModel>>(
                                                future: ApiRequests
                                                    .getProductsOfSeller(
                                                        seller.id),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Center(
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    );
                                                  }
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data?.length} products available",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .strongText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      snapshot.data!.isEmpty
                                                          ? const SizedBox
                                                              .shrink()
                                                          : PrimaryButton(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 5.0,
                                                                horizontal: 8.0,
                                                              ),
                                                              buttonText:
                                                                  "View Products",
                                                              fontSize: 12.0,
                                                              onPressed: () =>
                                                                  Constants
                                                                      .push(
                                                                context,
                                                                SellerProfile(
                                                                  seller:
                                                                      seller,
                                                                  products:
                                                                      snapshot
                                                                          .data!,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  );
                                                }),
                                            const SizedBox(height: 2.5),
                                            Text(
                                              "Member since ${seller.joinedAt.toDate().month}/${seller.joinedAt.toDate().year}",
                                              style: const TextStyle(
                                                color: AppColors.secondary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Nearby Hotels",
                        style: TextStyle(
                          color: AppColors.strongText,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 280.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.place.hotels.length,
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          itemBuilder: (BuildContext context, int index) {
                            HotelModel hotel = widget.place.hotels[index];
                            return HotelCard(hotel: hotel);
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        "Other nearby locations",
                        style: TextStyle(
                          color: AppColors.strongText,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 260.0,
                        child: FutureBuilder<List<PlaceModel>>(
                          future: ApiRequests.getNearbyPlaces(
                            LatLng(
                              widget.place.location.latitude,
                              widget.place.location.longitude,
                            ),
                            activePlaceID: widget.place.id,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                            if (snapshot.data!.isEmpty) {
                              return const NoRecordsAvailable(
                                title: "No Place Available",
                                description:
                                    "There is always more to do, head to map screen and start exploring",
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              itemBuilder: (BuildContext context, int index) {
                                PlaceModel place = snapshot.data![index];
                                return PlaceBigCard(place: place);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50.0,
            left: 25.0,
            child: Tooltip(
              message: "Go back",
              child: InkWell(
                onTap: () => Constants.pop(context),
                child: const GlassmorphismedWidget(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            right: 15.0,
            child: StreamLikedWidget(place: widget.place),
          ),
        ],
      ),
    );
  }

  Widget buildSevenDayForecast(
      String time, double minTemp, double maxTemp, String weatherIcon, size) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                time,
                style: GoogleFonts.questrial(
                  color: Colors.black,
                  fontSize: size.height * 0.025,
                ),
              ),
            ),
            Image.network(
              weatherIcon,
              color: Colors.black,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$minTemp˚C',
                      style: GoogleFonts.questrial(
                        color: Colors.black38,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      '$maxTemp˚C',
                      style: GoogleFonts.questrial(
                        color: Colors.black,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black),
      ],
    );
  }

  void _publishReview() async {
    String feedback = feedbackController.text.trim();
    if (feedback.isEmpty) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "Enter your feedback to publish the review",
        ),
      );
    } else {
      isAddingReview = true;
      setState(() {});

      await ApiRequests.publishReview(widget.place.id, feedback, placeRating);
      int totalReviews =
          reviews.length + 1; // adding +1 to include this new review in rating
      double totalStars =
          placeRating; // adding user rating as initial and then adding previous ratings to get complete rating
      for (var element in reviews) {
        totalStars += element.rating;
      }

      double finalRating = totalStars / totalReviews;
      await ApiRequests.updatePlaceRating(finalRating, widget.place.id);

      isAddingReview = false;
      await getReviews(); // set state is present in this function
    }
  }
}

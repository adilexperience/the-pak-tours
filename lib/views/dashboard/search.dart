import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<PlaceModel> allPlaces = [], searchedPlaces = [];
  bool isSearching = false;
  String searchedWord = "";

  @override
  void initState() {
    listenToSearchField();
    getAllPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      backgroundColor: AppColors.lightText.withOpacity(0.10),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/baltit_fort.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Where are you \ngoing?",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: material.Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SearchBar(
                      searchControl: searchController,
                      searchPressed: () =>
                          searchPlace(searchController.text.trim()),
                    ),
                  ),
                ],
              ),
            ),
            isSearching
                ? Container(
                    padding: const EdgeInsets.fromLTRB(
                      15.0,
                      20.0,
                      0,
                      15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10.0),
                        Text(
                          "\"Showing results for $searchedWord\"",
                          style: const TextStyle(
                            color: AppColors.strongText,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          height: 240.0,
                          child: searchedPlaces.isEmpty
                              ? const NoRecordsAvailable(
                                  title: "No places available",
                                  description:
                                      "No places available similar to your searching keyword, try searching some other place",
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: searchedPlaces.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    PlaceModel place = searchedPlaces[index];
                                    return PlaceBigCard(place: place);
                                  },
                                ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 260.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 5.0,
                      ),
                      child: GlassmorphicBGImageCard(
                        imageURL: "assets/images/search_pakistan_banner.jpeg",
                        cardTitle: "Do you know?",
                        cardDescription:
                            "Pakistan is home number of UNESCO world heritage sites like, Archaeological Ruins at Moenjodaro, Buddhist Ruins of Takht-i-Bahi and Neighbouring City Remains at Sahr-i-Bahlol, Fort and Shalamar Gardens in Lahore, Historical Monuments at Makli, Thatta, Rohtas Fort and Taxila.",
                        belowChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.0),
                            TileCard(
                              title: "Insightful",
                              bgColor: material.Colors.yellow,
                              textColor: AppColors.strongText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                15.0,
                20.0,
                0,
                15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    "My Wishlist",
                    style: TextStyle(
                      color: AppColors.strongText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: 240.0,
                    child: FutureBuilder<List<PlaceModel>>(
                        future: ApiRequests.getLikedPlaces(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return const NoRecordsAvailable(
                              title: "No records available",
                              description:
                                  "Start interacting with application to get things going",
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
                        }),
                  ),
                  const SizedBox(height: 100.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getAllPlaces() async {
    allPlaces = await ApiRequests.getAllPlaces();
    setState(() {});
  }

  void searchPlace(String title) {
    searchedWord = title;
    if (searchedWord.isEmpty) return;

    isSearching = true;

    if (searchedWord.isNotEmpty) {
      for (var place in allPlaces) {
        if (place.title.toLowerCase().contains(title.toLowerCase())) {
          searchedPlaces.add(place);
        }
      }
    }

    setState(() {});
  }

  void listenToSearchField() {
    searchController.addListener(() {
      if (searchController.text.trim().isEmpty) {
        isSearching = false;
        searchedPlaces = [];
      }
      setState(() {});
    });
  }
}

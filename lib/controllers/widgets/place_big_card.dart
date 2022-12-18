import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/controllers/widgets/widgets_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:the_pak_tours/views/views_exporter.dart';

class PlaceBigCard extends StatelessWidget {
  final PlaceModel place;
  const PlaceBigCard({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Constants.push(
        context,
        LocationDetailScreen(
          place: place,
        ),
      ),
      child: Container(
        width: 280.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: NetworkImage(place.images.first),
            fit: BoxFit.fill,
          ),
        ),
        margin: const EdgeInsets.only(right: 10.0),
        child: Stack(
          children: [
            Positioned(
              top: 10.0,
              right: 20.0,
              child: StreamLikedWidget(place: place),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: GlassmorphismedWidget(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      place.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      place.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}

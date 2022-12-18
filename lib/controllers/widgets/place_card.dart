import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:the_pak_tours/views/views_exporter.dart';

class PlaceCard extends StatefulWidget {
  final bool isFirstOfList;
  final PlaceModel place;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.isFirstOfList,
  }) : super(key: key);

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Constants.push(
        context,
        LocationDetailScreen(place: widget.place),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppColors.primary.withOpacity(0.6),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightText.withOpacity(0.45),
              blurRadius: 6,
              spreadRadius: 6,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(
          right: 10.0,
          left: widget.isFirstOfList ? 15.0 : 0.0,
        ),
        width: 205,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                      child: Image.network(
                        widget.place.images.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: StreamLikedWidget(place: widget.place),
                  ),
                  Positioned(
                    top: 15.0,
                    left: 5.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.95),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.5,
                        horizontal: 15.0,
                      ),
                      child: Text(
                        widget.place.type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 5.0,
                  right: 2.0,
                  bottom: 3.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.place.title,
                      style: const TextStyle(
                        color: AppColors.strongText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      widget.place.description,
                      style: const TextStyle(
                        color: AppColors.lightText,
                        fontSize: 12.0,
                      ),
                      maxLines: 3,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';

class StreamLikedWidget extends StatelessWidget {
  final PlaceModel place;
  const StreamLikedWidget({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: ApiRequests.isPlaceAlreadyLiked(place.id),
      builder: (context, snapshot) {
        return Tooltip(
          message: "Add to wishlist",
          child: PlaceInteractIcon(
            icon: !snapshot.hasData
                ? CupertinoIcons.heart
                : (snapshot.data.docs.length == 1)
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
            color: !snapshot.hasData
                ? null
                : (snapshot.data.docs.length == 1)
                    ? AppColors.primary
                    : null,
            isLikedIcon: true,
            place: place,
            isAlreadyLiked:
                !snapshot.hasData ? false : snapshot.data.docs.length == 1,
            likedDocID: !snapshot.hasData
                ? ""
                : snapshot.data.docs.length == 0
                    ? ""
                    : snapshot.data.docs[0]["id"],
            child:
                !snapshot.hasData ? const CupertinoActivityIndicator() : null,
          ),
        );
      },
    );
  }
}

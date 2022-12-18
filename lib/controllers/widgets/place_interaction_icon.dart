import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';

class PlaceInteractIcon extends StatefulWidget {
  final String? url, likedDocID;
  final PlaceModel? place;
  final IconData icon;
  final Widget? child;
  final Color? color;
  final bool isLikedIcon, isGlassTheme, isAlreadyLiked;
  final double? lat, lang;

  const PlaceInteractIcon({
    Key? key,
    required this.icon,
    this.color,
    this.url,
    this.likedDocID,
    this.lat,
    this.lang,
    this.child,
    this.place,
    this.isLikedIcon = false,
    this.isGlassTheme = true,
    this.isAlreadyLiked = false,
  }) : super(key: key);

  @override
  State<PlaceInteractIcon> createState() => _PlaceInteractIconState();
}

class _PlaceInteractIconState extends State<PlaceInteractIcon> {
  bool isPlaceMarkedVisited = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.isLikedIcon
          ? widget.isAlreadyLiked
              ? markPlaceUnLiked()
              : markPlaceLiked()
          : null,
      child: widget.isGlassTheme
          ? GlassmorphismedWidget(
              padding: const EdgeInsets.all(10.0),
              child: widget.child ??
                  Icon(
                    widget.icon,
                    color: widget.color ?? Colors.white,
                    size: 24.0,
                  ),
            )
          : widget.child ??
              Icon(
                widget.icon,
                color: widget.color ?? Colors.white,
                size: 20.0,
              ),
    );
  }

  void markPlaceLiked() async {
    await ApiRequests.markPlaceAsLiked(
      widget.place!.id,
      context,
    );
  }

  void markPlaceUnLiked() async {
    await ApiRequests.markPlaceAsUnLiked(
      widget.place!.id,
      widget.likedDocID!,
      context,
    );
  }
}

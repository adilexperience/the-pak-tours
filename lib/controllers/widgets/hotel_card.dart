import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  const HotelCard({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              hotel.image,
              width: 200.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            hotel.title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.lightText,
                size: 12.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                hotel.address,
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Text(
            "${hotel.price} Pkr/Night",
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            hotel.description,
            style: const TextStyle(
              color: AppColors.lightText,
              fontSize: 13.0,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

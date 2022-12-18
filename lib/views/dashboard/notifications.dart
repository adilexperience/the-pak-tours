import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightText.withOpacity(0.10),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                const Text(
                  "Notification",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: "DINNextLTPro_Bold",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Activity",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.strongText.withOpacity(0.1),
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: const Offset(6, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 3.5,
                      ),
                      child: StreamBuilder<dynamic>(
                          stream: ApiRequests.getStreamOfNotifications(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            }
                            return Text(
                              "${snapshot.data.docs.length}",
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: StreamBuilder<dynamic>(
                stream: ApiRequests.getStreamOfNotifications(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LoadingOverlay();
                  if (snapshot.data.docs.length == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/no_notification.png"),
                          const SizedBox(height: 20.0),
                          const Text(
                            "No new notifications",
                            style: TextStyle(
                              color: AppColors.strongText,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            "To this moment you are all synced but there is always slot to explore more",
                            style: TextStyle(
                              color: AppColors.strongText,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 150.0)
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot notificationDocument =
                          snapshot.data.docs[index];
                      NotificationModel notification =
                          NotificationModel.fromJson(notificationDocument.data()
                              as Map<String, dynamic>);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.strongText.withOpacity(0.1),
                              blurRadius: 10.0,
                              spreadRadius: 3.0,
                              offset: const Offset(7, 8),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  notification.imageUrl,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        timeAgo.format(
                                            notification.sentAt.toDate()),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: AppColors.lightText,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    notification.description,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: AppColors.strongText,
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
          ),
        ],
      ),
    );
  }
}

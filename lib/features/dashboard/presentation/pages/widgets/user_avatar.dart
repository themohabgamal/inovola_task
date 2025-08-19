import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 48.r,
        height: 48.r,
        child: CachedNetworkImage(
          imageUrl: 'https://avatar.iran.liara.run/public/18',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 24.r,
              color: Colors.grey[600],
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 24.r,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}

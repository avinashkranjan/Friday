import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: SvgPicture.asset(
              "assets/icons/grad_cap.svg",
              height: 70.0,
            ),
          ),
          Consumer<UserInfoServices>(
            builder: (ctx, _userInfo, _) {
              return Row(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      _userInfo.user != null
                          ? "Hello, " + _userInfo.user!.name.split(" ")[0]
                          : AppLocalizations.of(context)?.hellosir ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: _userInfo.user != null &&
                            _userInfo.user!.profilePictureUrl.isNotEmpty
                        ? NetworkImage(_userInfo.user!.profilePictureUrl)
                        : AssetImage("assets/images/profile_pic.jpg")
                            as ImageProvider<Object>,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

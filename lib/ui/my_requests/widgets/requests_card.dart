import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';
import 'package:with_you_app/ui/my_requests/request_details.dart';

class RequestCardBuilder extends StatelessWidget {
  final String emptyImagePath;
  const RequestCardBuilder(
      {Key? key, required this.requests, required this.emptyImagePath})
      : super(key: key);
  final List<RequestEntity> requests;
  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Image.asset(
          emptyImagePath,
          scale: 1.5,
        ),
      );
    }
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final requestEntity = requests[index];
        return InkWell(
          onTap: () {
            navigate(
                context,
                RequestDetailsPage(
                  requestEntity: requestEntity,
                ));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.fromLTRB(25, 15, 15, 15),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white,
              border: Border.all(color: AppColors.neutral_30),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.neutral_30,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Date : ${requestEntity.date}  -  No.Persons : ${requestEntity.numberOfPersons}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(
                        fontSize: 12, color: AppColors.neutral_100)),
                const SizedBox(
                  height: 10,
                ),
                Text(requestEntity.userId.split('@').first,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(
                        fontSize: 20, color: AppColors.neutral_500)),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 20, 40),
    );
  }
}

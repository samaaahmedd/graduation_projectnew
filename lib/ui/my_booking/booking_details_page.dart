import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/domain/models/trips/booking_model.dart';
import 'package:with_you_app/ui/my_trips/widgets/trip_page_details_body.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({Key? key, required this.bookingEntity})
      : super(key: key);
  final MyBookingEntity bookingEntity;

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.leadingAppBar(context),
      body: TripDetailsBody(
        tripEntity: widget.bookingEntity.trip,
        user: widget.bookingEntity.user,
      ),
    );
  }
}

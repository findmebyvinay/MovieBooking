import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qflix/cubit/movies_cubit.dart';

class SeatSelector extends StatefulWidget {
  const SeatSelector({
    super.key,
  });

  @override
  State<SeatSelector> createState() => _SeatSelectorState();
}

class _SeatSelectorState extends State<SeatSelector> {
  int columns = 7;
    int rows = 5;
   //List<int> bookedSeats = [5, 10, 15, 20];

  void select(int index) {
    // context.read<MoviesCubit>().selectSeat(getSeatLabel(index));
    context.read<MoviesCubit>().selectSeat(index);
   print(getSeatLabel(index));
   
    //print(getStatus(index));
    //print(List.generate(1, (index) =>int.parse(getSeatLabel(index))));
   
  }

  SeatStatus getStatus(int index) {
    final cubit = context.read<MoviesCubit>().state;
    if (cubit.empty.contains(index)) {
      return SeatStatus.empty;
    }
    if (cubit.selected.contains(index)) {
      return SeatStatus.selected;
    }
    if (cubit.allBookedSeats.contains(index)) {
      return SeatStatus.booked;
    }
    return SeatStatus.free;
  }
    String getSeatLabel(int index) {
      // return index.toString();
      int seatNum= index++;
      return seatNum.toString();
   // int row = (index / columns).floor() + 1;
    //int col = index % columns + 1;
    //return '${String.fromCharCode(64 + row)}$col';
  }
  @override
  Widget build(BuildContext context) {
  //  context.read<MoviesCubit>().resetBooking();
  context.read<MoviesCubit>().loadSeats();

    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width / columns*rows,
          // columns * state.seats,
          child: Stack(
            children: [
              GridView.count(
                crossAxisCount: columns,
                children: List.generate(
                  state.seats,
                  (index) => Seat(
                    status: getStatus(index),
                    index:index,
                    seatLabel: getSeatLabel(index),
                    onTap: (){if (getStatus(index) != SeatStatus.booked) {
                       // context.read<MoviesCubit>().selectSeat(1);
                        select(index);
                      }}
                    // => select(index),
                  ),
                ),
              ),
              if (state.status.isLoading)
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width/ columns*rows,
                    ),
                  ),
                ),
              if (state.status.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: .5,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

enum SeatStatus { empty, free, selected,booked }

class Seat extends StatelessWidget {
  const Seat({super.key, required this.status, this.onTap,
    required this.seatLabel, required this.index});

   final String seatLabel;
   final int index;
  final SeatStatus status;
  final VoidCallback? onTap;
   
  @override
  Widget build(BuildContext context) {
    if (status == SeatStatus.empty) {
      return const SizedBox.shrink();
    }

     Color seatColor;
    switch (status) {
      case SeatStatus.free:
        seatColor = Colors.grey.shade800;
        break;
      case SeatStatus.selected:
        seatColor = Colors.white;
        break;
      case SeatStatus.booked:
        seatColor = Colors.red;
        break;
      case SeatStatus.empty:
        // This case should not be reached
        seatColor = Colors.transparent;
        break;
    }
     return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:seatColor,
        /* status == SeatStatus.selected
            ? Colors.white
            : status == SeatStatus.booked
                ? Colors.red
                : Colors.grey.shade800,*/
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                seatLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: status == SeatStatus.booked ? null : onTap,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),/*
      child: InkWell(
        onTap: status == SeatStatus.booked
        // || status == SeatStatus.booked
            ? null
            : onTap,
        borderRadius: BorderRadius.circular(10),
      ),*/
    );
    /*return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: status == SeatStatus.selected ? Color.fromARGB(255, 255, 255, 255) : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),
    /*return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: status == SeatStatus.selected
            ? Colors.white
            : status == SeatStatus.busy
                ? Colors.white24
                : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),*/
      child: InkWell(
        onTap: status == SeatStatus.busy ? null : onTap,
        borderRadius: BorderRadius.circular(10),
      ),
    );*/
  }
}

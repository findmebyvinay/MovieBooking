import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qflix/ProductDetailsWidget.dart';
import 'package:qflix/models/seats_model.dart';

import '../screens/booking_screen.dart';
part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesState(booked: [],allBookedSeats: [],
    selected: [],
    availableSeats: [], 
    status: MoviesStatus.initial,
    seats:0,));

  var selected = <int>[];
  //var booked = <int>[];

  Future<void> loadSeats() async {
    int seats = 35;
    selected = [];
    List<int> bookedSeats = await getBookedSeatsFromFirestore();
    List<int> availableSeats = List.generate(seats, (index) => index);
    availableSeats.removeWhere((seat) => bookedSeats.contains(seat));
  //  booked = []; // Initially, no seats are booked
    emit(MoviesState(
    status: MoviesStatus.loading, 
    seats: seats,
    booked:bookedSeats,
    selected: [],
    availableSeats: availableSeats,
));

    await Future.delayed(const Duration(seconds: 1));
    /*final busy = <int>[];
    for (var i = 0; i < 15; i++) {
      final x = Random().nextInt(seats);
      busy.add(x);
    }*/
    emit(MoviesState(
      status: MoviesStatus.loaded,
      seats: seats,
      //empty: [0, 6],
      selected:[],
      //busy:[]
      booked:bookedSeats, 
      availableSeats: availableSeats,
      allBookedSeats:bookedSeats,
       //busy,
    ));
  }

  Future<void> selectSeat(int seatIndex) async {
    print("selected seats are:${state.selected}");
    //print("seats are$selected");
    //print(state.selected);
 //   print(state.availableSeats);
    
     if (state.booked.contains(seatIndex)) {
      // Cannot select a booked seat
      return;
    }
    //  List<int> selectedSeats;
      //List<int> availableSeats;
      List<int> selectedSeats = List.from([1,2,3]);
      // List<int> selectedSeats = List.from(state.selected);
  List<int> availableSeats = List.from(state.availableSeats);

  if (selectedSeats.contains(seatIndex)) {
    // If the seat is already selected, deselect it
    selectedSeats.remove(seatIndex);
    availableSeats.add(seatIndex);
  } else {
    // If the seat is not selected, select it
    selectedSeats.add(seatIndex);
    availableSeats.remove(seatIndex);
  }
    emit(state.copyWith(
    selected: selectedSeats,
    availableSeats: availableSeats,
  ));
  }
  /*     
  if (state.selected.contains(seatIndex)) {
    // If the seat is already selected, deselect it
    selectedSeats = List.from(state.selected)..remove(seatIndex);
    availableSeats = List.from(state.availableSeats)..add(seatIndex);
  } else {
    // If the seat is not selected, select it
    selectedSeats = List.from(state.selected)..add(seatIndex);
    availableSeats = List.from(state.availableSeats)..remove(seatIndex);
  }
   emit(state.copyWith(
    selected: selectedSeats,
    availableSeats: availableSeats,
  ));}*/
   Future<void> book(
   String productId, 
   String productName, 
   String message,
   List<int> seatLabel) async {
    print("book called");
     print("selected seats are:${state.selected}");
  await savePaymentData(productId, productName, message);

   List<int> prevBookedSeats = await getBookedSeatsFromFirestore();
    print("Previously booked seats: $prevBookedSeats");
    // List<int> seatLabel = selected;
   List <int> newBookedSeats = [...prevBookedSeats, ...seatLabel];
     print("New booked seats (including selected): $newBookedSeats");
   // List<dynamic> newBookedSeatsAsDynamic = [...prevBookedSeats, ...state.selected];
  //List<int> newBookedSeats = newBookedSeatsAsDynamic.cast<int>().toList();

    await updateBookedSeatsInFirestore(newBookedSeats);
    
  List<int> availableSeats = List.from(state.availableSeats);
  availableSeats.removeWhere((seat) => seatLabel.contains(seat));
   print("Selected seats after booking:$seatLabel");

     List<int> selectedSeats = seatLabel;

  print("Selected seats after booking: $selectedSeats");
    //final availableSeats = List.from(state.availableSeats);
    //availableSeats.removeWhere((seat) => seatLabel.contains(seat));

    //selected.clear();
      emit(state.copyWith(
      status: MoviesStatus.loaded,
      booked: newBookedSeats,
      allBookedSeats: newBookedSeats,
      selected: [],
      availableSeats: availableSeats,
    ));
   // ProductDetailsWidget(productId:int.parse(productId) , 
    //productName: productName, 
    //totalPrice:300);
   /*final newBookedSeats = [...state.booked, ...selected];
      final newAllBookedSeats = [...state.allBookedSeats, ...selected];
    //booked.addAll(selected); // Add the selected seats to the booked list
    selected.clear(); // Clear the selected list

     await updateBookedSeatsInFirestore(newAllBookedSeats);
    emit(state.copyWith(
      status: MoviesStatus.loaded,
      //booked,
      //booked: booked, // Update the busy list with the booked seats
      selected: selected,
       booked:newBookedSeats,
       allBookedSeats: newAllBookedSeats,
    ));*/
  }
  Future<void> updateBookedSeatsInFirestore(List<int> newBookedSeats) async {
   // print(state.selected);
    
  try {
    // Get a reference to the Firestore collection or document where you want to store the booked seats
    DocumentReference bookingDocRef = FirebaseFirestore.instance.collection('bookings').doc('bookedSeats');
     print("Seat is upated");
   
    // Update the 'bookedSeats' field with the new booked seat indices
     await bookingDocRef.set({'bookedSeats': newBookedSeats}, SetOptions(merge: true));
      //await bookingDocRef.update({'bookedSeats': newBookedSeats});
    // print(state.selected);
  } catch (e) {
    print('Error updating booked seats in Firestore: $e');
  }
}
  Future<List<int>> getBookedSeatsFromFirestore() async {
  try {
    // Get a reference to the Firestore collection or document where you want to store the booked seats
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('bookings').doc('bookedSeats').get();
    if (snapshot.exists && snapshot.data() != null && (snapshot.data() as Map).containsKey('bookedSeats')) {
      // Convert the 'bookedSeats' field to a List<int>
      List<dynamic> bookedSeatsList = (snapshot.data() as Map)['bookedSeats'];
      List<int> bookedSeatsIntList = bookedSeatsList.cast<int>().toList();
      return bookedSeatsIntList;
    } else {
      // Return an empty list if the document or field doesn't exist
      return [];
    }
  } catch (e) {
    print('Error getting booked seats from Firestore: $e');
    return [];
  }
}
}

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

import 'state.dart';

class ApiFetchHydratedCubit extends HydratedCubit<ApiFetchState> {
  final  logger = Logger();
  ApiFetchHydratedCubit() : super(const ApiFetchState()) {
    /// you can use fetch data to fetch data directly
    /// remove it  if you want to wait until user ask for it
    fetchData();
  }

  Future<void> fetchData()  async {
    /// if the last state was success then
    ///there was already a loaded date the last time the user were here
    if(state.uiState == UIState.success){

      logger.d('2nd time to load a data ');
      /// try to get new data if possible
      /// if not then leave the last loaded data
        final response = await apiClient.getVenues();
        if (response.code == 200) {
          emit(state.copyWith(uiState: UIState.success, apiResponse: response,));
          return ;
        }
      }


    try {
      logger.d('first time to load a data ');
      emit(state.copyWith(uiState: UIState.inProgress));
      final response = await apiClient.getVenues();

      if (response.code == 200) {
        emit(state.copyWith(uiState: UIState.success, apiResponse: response,));
      } else {
        emit(state.copyWith(uiState: UIState.invalidCredentialsError, failureMessage: response.message,));
      }
    } on DioException catch (e) {
      emit(state.copyWith(uiState: UIState.genericError, failureMessage: e.handleDioError()));
    }
  }



  /// you will just change the object that you want to cache
  @override
  ApiFetchState? fromJson(Map<String, dynamic> json) {
    return  ApiFetchState(
      apiResponse: VenuesResponse.fromJson(json['apiResponse'])   ,
       failureMessage: json['failureMessage']    ,
      uiState: UIState.values[json['uiState'] as int]   ,
    );

  }

  @override
  Map<String, dynamic>? toJson(ApiFetchState state) {
    return  {
      'apiResponse': state.apiResponse?.toJson() ?? VenuesResponse(),
      'failureMessage': state.failureMessage,
      'uiState': state.uiState.index ,
    };

  }
  }





import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

// Define the enum for API states
enum UIState {
  /// Used when the form has not been sent yet.
  idle,

  /// Used to disable all buttons and add a progress indicator to the main one.
  inProgress,

  /// Used to close the screen and navigate back to the caller screen.
  success,

  /// Used to display a generic snack bar saying that an error has occurred, e.g., no internet connection.
  genericError,

  /// Used to show a more specific error telling the user they got the email and/or password wrong.
  invalidCredentialsError,
}


// Define your Cubit state
class ApiFetchState extends Equatable {
  final VenuesResponse? apiResponse;
  final String? failureMessage;
  final UIState uiState;

  const ApiFetchState({
    this.apiResponse,
    this.failureMessage,
    /// making the state loading or idle in first build is up to you
    this.uiState = UIState.inProgress,
  });

  // CopyWith method for state modification
  ApiFetchState copyWith({
    VenuesResponse? apiResponse,
    String? failureMessage,
    UIState? uiState,
  }) {
    return ApiFetchState(
      apiResponse: apiResponse ?? this.apiResponse,
      failureMessage: failureMessage ?? this.failureMessage,
      uiState: uiState ?? this.uiState,
    );
  }

  @override
  List<Object?> get props => [apiResponse, uiState, failureMessage];
}

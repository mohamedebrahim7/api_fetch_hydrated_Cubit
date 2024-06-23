# Fetch API Hydrated Cubit

A Flutter code snippet demonstrating how to fetch data from an API using Cubit for state management,   <br>  with enhanced state persistence
 using [hydrated_bloc](https://pub.dev/packages/hydrated_bloc).

## Overview

This code snippet extends upon the  [Api Fetch Cubit](https://github.com/mohamedebrahim7/api_fetch_cubit). by incorporating state hydration for improved user experience across app sessions.<br> Key features include:


### Key Features

- **Definition**: `HydratedApiFetchCubit` using Flutter Bloc for state management.
- **Data Fetching**: Fetching data from an API endpoint using Dio or any other http package.
- **UI State Handling**: Efficiently manages and displays UI states based on API responses.
- **State Persistence**: Persists the last successful API response locally using `hydrated_bloc`, ensuring a smooth user experience.

**Note**: For details on the original `ApiFetchCubit`, which shares similar functionality without state hydration, refer to [Api Fetch Cubit](https://github.com/mohamedebrahim7/api_fetch_cubit).


## Usage

### `fetchData` Method

The `fetchData()` method handles fetching data from an API endpoint based on the current state of the `api_fetch_hydrated_Cubit`. It ensures efficient data loading and persistence strategies:

```dart
Future<void> fetchData() async {
  // If the last state was success, attempt to load new data
  if (state.uiState == UIState.success) {
    logger.d('2nd time to load data');
    try {
      final response = await apiClient.getVenues();
      if (response.code == 200) {
        emit(state.copyWith(uiState: UIState.success, apiResponse: response));
        return;
      }
    } catch (_) {
      // If fetching new data fails, retain the last loaded data
    }
  }

  // First time or if new data fetch failed, load initial data
  try {
    logger.d('First time to load data');
    emit(state.copyWith(uiState: UIState.inProgress));
    final response = await apiClient.getVenues();
    if (response.code == 200) {
      emit(state.copyWith(uiState: UIState.success, apiResponse: response));
    } else {
      emit(state.copyWith(
        uiState: UIState.invalidCredentialsError,
        failureMessage: response.message,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      uiState: UIState.genericError,
      failureMessage: e.handleDioError(),
    ));
  }
}

# MVVM_Architecture_Pattern

MVVM Structure:
Model:
Movie and MovieResult structs represent the data models containing information about movies fetched from an API.
ViewModel:
MovieListViewModel manages the movie-related data and logic.
It communicates with the Model to fetch movie data from an API.
Notifies the ViewController through a delegate about successful data retrieval or any errors encountered during the fetch process.
View:
MovieListViewController acts as the View layer responsible for UI.
Sets up the TableView and handles TableView data source and delegate methods.
Receives updates from the ViewModel about changes in the movie data and updates the UI accordingly.
Workflow:
View Initialization:
MovieListViewController is loaded when the app starts.
It sets up the TableView and delegates necessary TableView methods to itself.
ViewModel Interaction:
MovieListViewController creates an instance of MovieListViewModel.
It assigns itself as the delegate of the ViewModel to receive updates.
Fetching Movie Data:
Upon viewDidLoad(), MovieListViewController triggers viewModel.fetchMovieList().
The MovieListViewModel initiates a network request to fetch movie data from the API.
Upon successful fetch, the ViewModel updates its movies array and notifies the delegate (the ViewController) using delegate methods (moviesFetched() or movieFetchFailed()).
TableView Updates:
When moviesFetched() is called, the ViewController updates its TableView with the new movie data received from the ViewModel.
The TableView's dataSource methods (numberOfRowsInSection and cellForRowAt) fetch data from the ViewModel's movies array to populate the TableView with movie details.
User Interaction:
When a user interacts with the TableView (e.g., selecting a row), the ViewController can handle the interaction accordingly (for instance, fetching more details about a selected movie).

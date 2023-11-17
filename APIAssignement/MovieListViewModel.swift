import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func moviesFetched()
    func movieFetchFailed(with error: Error)
}

class MovieListViewModel {
    weak var delegate: MovieListViewModelDelegate?
    var movies: [Movie] = []

    func fetchMovieList() {
        let apiUrl = "https://www.omdbapi.com/?apikey=6e2b52e9&s=action&y=2023"

        if let url = URL(string: apiUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
                guard let self = self else { return }

                if let error = error {
                    self.delegate?.movieFetchFailed(with: error)
                    return
                }

                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(MovieResult.self, from: data)
                        self.movies = result.search
                        self.delegate?.moviesFetched()
                    } catch {
                        self.delegate?.movieFetchFailed(with: error)
                    }
                }
            }.resume()
        }
    }
}


// MovieListViewController.swift

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Register the custom cell class
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")

        tableView.dataSource = self
        tableView.delegate = self

        // Fetch movie list using GCD
        fetchMovieListWithGCD()
    }

    func fetchMovieListWithGCD() {
        // API URL
        let apiUrl = "https://www.omdbapi.com/?apikey=6e2b52e9&s=action&y=2023"

        // Perform the network request using GCD
        DispatchQueue.global().async {
            if let url = URL(string: apiUrl),
               let data = try? Data(contentsOf: url) {
                do {
                    // Parse the JSON response into Movie objects
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieResult.self, from: data)
                    self.movies = result.search

                    // Reload the table view on the main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell with the correct identifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell {
            let movie = movies[indexPath.row]

            // Configure the cell using your movie data
            cell.textLabel?.text = movie.title
            cell.detailTextLabel?.text = "Year: \(movie.year), IMDb: \(movie.imdbID)"

            return cell
        } else {
            fatalError("Failed to dequeue a cell.")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Fetch detailed information for the selected movie using Async/Await
        fetchMovieDetailsWithAsyncAwait(for: indexPath.row)
    }

    // Fetch movie details using Async/Await
    func fetchMovieDetailsWithAsyncAwait(for index: Int) {
        let movie = movies[index]
        let detailApiUrl = "https://www.omdbapi.com/?apikey=6e2b52e9&i=\(movie.imdbID)"

        guard let url = URL(string: detailApiUrl) else {
            return
        }

        // Perform the network request using Async/Await
        async {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let detailedMovie = try decoder.decode(Movie.self, from: data)
                // Print or use detailedMovie as needed
                print("Detailed Movie Information: \(detailedMovie)")
            } catch {
                print("Error fetching movie details: \(error)")
            }
        }
    }
}


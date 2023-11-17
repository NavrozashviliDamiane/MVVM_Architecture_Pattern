
import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var viewModel = MovieListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchMovieList()
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("Failed to dequeue a cell.")
        }
        
        let movie = viewModel.movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = "Year: \(movie.year), IMDb: \(movie.imdbID)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection if needed
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func moviesFetched() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func movieFetchFailed(with error: Error) {
        print("Error fetching movies: \(error)")
        // Handle error scenario if needed
    }
}

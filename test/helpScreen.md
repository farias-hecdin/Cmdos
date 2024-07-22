# Normal
```
Usage:
  Example [--Add] [--search]...

Commands:
  --Add    Adds a new book to the library
  --search Searches for books in the library

Options:
  -v, --version  Displays the version number
  -h, --help     Displays this help screen

--Add options:
  -t, --title   The title of the book
  -a, --author  The author of the book
  -l, --pages   The number of pages in the book

--search options:
  -t, --title           The title of the book to search for
  -a, --author          The author of the book to search for
  -c, --case-sensitive  Perform a case-sensitive search (default is case-insensitive)

Example usage:
  Example --Add -t "The Great Book" -a "John Doe" -l 200
  Example --search -t "great" -a "doe"
  Example --search -t "Great" -a "Doe" -c
```

# Minimal
```
Usage:
  Example [--Add] [--search]...

Commands:
  --Add          Adds a new book to the library
  --search       Searches for books in the library

Options:
  -v, --version  Displays the version number
  -h, --help     Displays this help screen or an specific <command>

--Add options:
  [-t, --title] [-a, --author]  [-l, --pages]

--search options:
  [-t, --title] [-a, --author] [-c, --case-sensitive]

Example usage:
  Example --Add -t "The Great Book" -a "John Doe" -l 200
  Example --search -t "great" -a "doe"
  Example --search -t "Great" -a "Doe" -c
```

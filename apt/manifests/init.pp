class apt {
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  # Ensure apt is setup before running apt-get update
  # keeping this here as an example of how to do dependencies in this direction, but no plans to use right now
  #Apt::Key <| |> -> Exec["apt-update"]
  #Apt::Source <| |> -> Exec["apt-update"]

  # Ensure apt-get update has been run before installing any packages
  Exec["apt-update"] -> Package <| |>
}
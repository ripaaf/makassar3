<?php

// Define your Server host name here.
$HostName = "localhost";

// Define your MySQL Database Name here.
$DatabaseName = "itsla_maintenance";

// Define your Database User Name here.
$HostUser = "root";

// Define your Database Password here.
$HostPass = "makassar3";

// Creating MySQL Connection.
$con = mysqli_connect($HostName, $HostUser, $HostPass, $DatabaseName);

// Getting the received JSON into $json variable.
$json = file_get_contents('php://input');

// Decoding the received JSON and store into $obj variable.
$obj = json_decode($json, true);

// Getting User email from JSON $obj array and store into $email.
$email = $obj['email'];

// SQL query to fetch technician status based on email.
$sql = "SELECT teknisi FROM user WHERE email = '$email'";

// Executing the query.
$result = mysqli_query($con, $sql);

// Checking if the query execution was successful.
if ($result) {
  // Fetching the technician status from the result set.
  $row = mysqli_fetch_assoc($result);
  $teknisi = $row['teknisi'];

  // Creating a response array.
  $response = array('teknisi' => $teknisi);

  // Sending the response as JSON.
  echo json_encode($response);
} else {
  // Query execution failed. Handle the error here.
  $response = array('error' => 'Failed to fetch technician status.');

  // Sending the error response as JSON.
  echo json_encode($response);
}

// Closing the database connection.
mysqli_close($con);
?>

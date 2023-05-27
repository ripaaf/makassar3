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

// Check if the user already exists.
$checkQuery = "SELECT username, teknisi FROM user WHERE email = '$email'";
$checkResult = mysqli_query($con, $checkQuery);

$response = array();

if (mysqli_num_rows($checkResult) > 0) {
    $row = mysqli_fetch_assoc($checkResult);

    $response['username'] = $row['username'];
    $response['teknisi'] = $row['teknisi'];
} else {
    $response['error'] = "User not found";
}

// Closing MySQL connection.
mysqli_close($con);

// Encoding response as JSON.
$jsonResponse = json_encode($response);

// Outputting the JSON response.
echo $jsonResponse;
?>

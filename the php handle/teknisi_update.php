<?php

// Define your Server host name here.
$HostName = "localhost";

// Define your MySQL Database Name here.
$DatabaseName = "itsla_maintenance";

// Define your Database User Name here.
$HostUser = "root";

// Define your Database Password here.
$HostPass = ""; 

// Creating MySQL Connection.
$con = mysqli_connect($HostName, $HostUser, $HostPass, $DatabaseName);

// Getting the received JSON into $json variable.
$json = file_get_contents('php://input');

// Decoding the received JSON and store into $obj variable.
$obj = json_decode($json, true);

// Getting User email from JSON $obj array and store into $email.
$email = $obj['email'];

// Getting Teknisi from JSON $obj array and store into $teknisi.
$teknisi = $obj['teknisi'];

// Convert $teknisi value to lowercase and check if it is "true" or "false".
$teknisi = strtolower($teknisi);
if ($teknisi == "true") {
    $teknisi = "true";
} else {
    $teknisi = "false";
}

// Prepare and execute the SQL query to update the "teknisi" column for the selected email.
$query = "UPDATE user SET teknisi = '$teknisi' WHERE email = '$email'";
$result = mysqli_query($con, $query);

if ($result) {
    // Update successfuly
    $response["message"] = "Teknisi data updated successfully.";
} else {
    // Error in updating
    $response["message"] = "Error updating teknisi data.";
}

// Convert the response array to JSON format.
echo json_encode($response);

mysqli_close($con);
?>

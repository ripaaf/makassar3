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

// Getting User username from JSON $obj array and store into $username.
$username = $obj['username'];

// Getting User email from JSON $obj array and store into $email.
$email = $obj['email'];

// Getting Password from JSON $obj array and store into $password.
$password = $obj['password'];

// Getting Teknisi from JSON $obj array and store into $teknisi.
$teknisi = $obj['teknisi'];

// Validate email format.
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $response = 'Invalid email format';
    $responseJson = json_encode($response);
    echo $responseJson;
    exit;
}

// Hash the password.
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Check if the user already exists.
$checkQuery = "SELECT * FROM user WHERE email = '$email'";
$checkResult = mysqli_query($con, $checkQuery);

if (mysqli_num_rows($checkResult) > 0) {
    // If user already exists.
    $response = 'Email already exists';
    $responseJson = json_encode($response);
    echo $responseJson;
} else {
    // Get the last inserted id
    $lastIdQuery = "SELECT MAX(id) as lastId FROM user";
    $lastIdResult = mysqli_query($con, $lastIdQuery);
    $lastIdRow = mysqli_fetch_assoc($lastIdResult);
    $lastId = $lastIdRow['lastId'] ?? 0;

    // Increment the last id
    $newId = $lastId + 1;

    // User does not exist, proceed with registration.
    $registerQuery = "INSERT INTO user (id, username, email, password, teknisi) VALUES ('$newId', '$username', '$email', '$hashedPassword', '$teknisi')";
    $registerResult = mysqli_query($con, $registerQuery);

    if ($registerResult) {
        // Successfully registered.
        $response = 'Registration successful';
        $responseJson = json_encode($response);
        echo $responseJson;
    } else {
        // Failed to register.
        $response = 'Registration failed';
        $responseJson = json_encode($response);
        echo $responseJson;
    }
}

mysqli_close($con);

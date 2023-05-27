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

// Getting Password from JSON $obj array and store into $password.
$password = $obj['password'];

// Applying User Login query with email.
$loginQuery = "SELECT * FROM user WHERE email = '$email'";
$loginResult = mysqli_query($con, $loginQuery);

if (mysqli_num_rows($loginResult) > 0) {
    $user = mysqli_fetch_assoc($loginResult);
    $storedPassword = $user['password'];
    
    // Verify the stored hashed password with the entered password.
    if (password_verify($password, $storedPassword)) {
        // Password is correct. Login successful.
        $response = 'Login Matched';
        $responseJson = json_encode($response);
        echo $responseJson;
    } else {
        // Password is incorrect.
        $response = 'Invalid Username or Password. Please Try Again';
        $responseJson = json_encode($response);
        echo $responseJson;
    }
} else {
    // User does not exist.
    $response = 'Invalid Username or Password. Please Try Again';
    $responseJson = json_encode($response);
    echo $responseJson;
}

mysqli_close($con);
?>
